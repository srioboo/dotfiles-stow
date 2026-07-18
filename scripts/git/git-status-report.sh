#!/usr/bin/env bash
#
# git-status-report.sh
#
# Recorre una carpeta (por defecto, la carpeta donde está el script) y
# muestra en consola un mini-informe del estado de versionado de cada
# proyecto git que encuentre: rama actual, cambios en staging, cambios
# sin stage, archivos sin seguimiento y si faltan commits por subir
# (push) o por bajar (pull).
#
# Uso:
#   ./git-status-report.sh [carpeta] [--max-depth N]
#
# Ejemplos:
#   ./git-status-report.sh                # analiza la carpeta actual
#   ./git-status-report.sh ~/Work         # analiza otra carpeta
#   ./git-status-report.sh ~/Work --max-depth 2

set -o pipefail

ROOT_DIR="."
MAX_DEPTH=4

# --- Parseo de argumentos -------------------------------------------------
while [[ $# -gt 0 ]]; do
  case "$1" in
    --max-depth)
      MAX_DEPTH="$2"
      shift 2
      ;;
    -h|--help)
      grep '^#' "$0" | sed 's/^# \{0,1\}//;s/^#$//'
      exit 0
      ;;
    *)
      ROOT_DIR="$1"
      shift
      ;;
  esac
done

if [[ ! -d "$ROOT_DIR" ]]; then
  echo "Error: '$ROOT_DIR' no es una carpeta válida." >&2
  exit 1
fi

ROOT_DIR="$(cd "$ROOT_DIR" && pwd)"

# --- Colores (se desactivan si no hay terminal) ---------------------------
if [[ -t 1 ]]; then
  C_RESET=$'\033[0m'
  C_BOLD=$'\033[1m'
  C_GREEN=$'\033[32m'
  C_YELLOW=$'\033[33m'
  C_RED=$'\033[31m'
  C_CYAN=$'\033[36m'
  C_GRAY=$'\033[90m'
else
  C_RESET=""; C_BOLD=""; C_GREEN=""; C_YELLOW=""; C_RED=""; C_CYAN=""; C_GRAY=""
fi

# Carpetas que nunca queremos recorrer (dependencias, builds, etc.)
PRUNE_NAMES=(node_modules .venv venv vendor dist build target .next .nuxt .gradle .idea .DS_Store)

# --- Localiza repositorios git (carpetas que contienen .git) --------------
prune_expr=()
for name in "${PRUNE_NAMES[@]}"; do
  prune_expr+=(-name "$name" -o)
done
unset 'prune_expr[${#prune_expr[@]}-1]' # quita el último -o suelto

REPOS=()
while IFS= read -r line; do
  [[ -n "$line" ]] && REPOS+=("$line")
done < <(
  find "$ROOT_DIR" -maxdepth "$MAX_DEPTH" \( "${prune_expr[@]}" \) -prune -o \
    -type d -name ".git" -print 2>/dev/null | sed 's|/\.git$||' | sort
)

if [[ "${#REPOS[@]}" -eq 0 ]]; then
  echo "No se encontró ningún repositorio git en: $ROOT_DIR"
  exit 0
fi

total=${#REPOS[@]}
limpios=0
con_cambios=0
con_pendientes_push=0

echo
echo "${C_BOLD}Informe de versionado — ${ROOT_DIR}${C_RESET}"
echo "${C_GRAY}$(date '+%Y-%m-%d %H:%M')${C_RESET}"
echo "${C_GRAY}$(printf '=%.0s' {1..60})${C_RESET}"

for repo in "${REPOS[@]}"; do
  name="${repo#"$ROOT_DIR"/}"
  [[ "$name" == "$ROOT_DIR" ]] && name="."

  cd "$repo" || continue

  # Rama actual (o detached HEAD)
  branch="$(git symbolic-ref --short -q HEAD)"
  if [[ -z "$branch" ]]; then
    short_sha="$(git rev-parse --short HEAD 2>/dev/null)"
    branch="HEAD detached @ ${short_sha:-?}"
  fi

  # Cambios en staging (añadidos al index, listos para commit)
  staged_count="$(git diff --cached --name-only 2>/dev/null | wc -l | tr -d ' ')"

  # Cambios sin stage (archivos trackeados modificados, sin añadir)
  unstaged_count="$(git diff --name-only 2>/dev/null | wc -l | tr -d ' ')"

  # Archivos sin seguimiento (untracked)
  untracked_count="$(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')"

  # Estado respecto al remoto (push/pull pendientes)
  upstream="$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)"
  push_pending=0
  pull_pending=0
  remote_info=""
  if [[ -n "$upstream" ]]; then
    counts="$(git rev-list --left-right --count "${upstream}...HEAD" 2>/dev/null)"
    pull_pending="$(awk '{print $1}' <<< "$counts")"
    push_pending="$(awk '{print $2}' <<< "$counts")"
    pull_pending="${pull_pending:-0}"
    push_pending="${push_pending:-0}"
  else
    remote_info="${C_GRAY}sin upstream configurado${C_RESET}"
  fi

  has_changes=0
  [[ "$staged_count" -gt 0 || "$unstaged_count" -gt 0 || "$untracked_count" -gt 0 ]] && has_changes=1

  # --- Cabecera del proyecto ---
  if [[ "$has_changes" -eq 1 || "$push_pending" -gt 0 || "$pull_pending" -gt 0 ]]; then
    status_icon="${C_YELLOW}●${C_RESET}"
  else
    status_icon="${C_GREEN}●${C_RESET}"
  fi

  echo
  echo "${status_icon} ${C_BOLD}${name}${C_RESET}  ${C_CYAN}[${branch}]${C_RESET}"

  # --- Detalle de working tree ---
  if [[ "$has_changes" -eq 0 ]]; then
    echo "  ${C_GREEN}Working tree limpio${C_RESET}"
    ((limpios++))
  else
    ((con_cambios++))
    parts=()
    [[ "$staged_count" -gt 0 ]] && parts+=("${C_YELLOW}${staged_count} en staging${C_RESET}")
    [[ "$unstaged_count" -gt 0 ]] && parts+=("${C_YELLOW}${unstaged_count} modificado(s) sin stage${C_RESET}")
    [[ "$untracked_count" -gt 0 ]] && parts+=("${C_YELLOW}${untracked_count} sin seguimiento${C_RESET}")
    joined=""
    for p in "${parts[@]}"; do
      if [[ -z "$joined" ]]; then joined="$p"; else joined="${joined} | ${p}"; fi
    done
    echo "  ${joined}"
  fi

  # --- Detalle de sincronización con el remoto ---
  if [[ -n "$upstream" ]]; then
    if [[ "$push_pending" -gt 0 && "$pull_pending" -gt 0 ]]; then
      echo "  ${C_RED}${push_pending} commit(s) sin pushear${C_RESET} y ${C_RED}${pull_pending} commit(s) sin traer (pull)${C_RESET} — respecto a ${upstream}"
      ((con_pendientes_push++))
    elif [[ "$push_pending" -gt 0 ]]; then
      echo "  ${C_RED}${push_pending} commit(s) sin pushear${C_RESET} (ahead de ${upstream})"
      ((con_pendientes_push++))
    elif [[ "$pull_pending" -gt 0 ]]; then
      echo "  ${C_YELLOW}${pull_pending} commit(s) sin traer${C_RESET} (behind de ${upstream})"
    else
      echo "  ${C_GREEN}Sincronizado con ${upstream}${C_RESET}"
    fi
  else
    echo "  ${remote_info}"
  fi
done

echo
echo "${C_GRAY}$(printf '=%.0s' {1..60})${C_RESET}"
echo "${C_BOLD}Resumen:${C_RESET} ${total} repos · ${C_GREEN}${limpios} limpios${C_RESET} · ${C_YELLOW}${con_cambios} con cambios sin commitear${C_RESET} · ${C_RED}${con_pendientes_push} con commits sin pushear${C_RESET}"
echo
