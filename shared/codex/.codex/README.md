# Subagentes Orquestador para Codex y OpenCode

Paquete portable con la arquitectura de orquestador y subagentes.

Incluye:

- `codex/agents`: agentes TOML para Codex.
- `codex/AGENTS.md`: protocolo global de uso de subagentes en Codex.
- `opencode/agents`: agentes OpenCode, incluyendo `orquestador` y `oo-*`.
- `opencode/aliases`: aliases compatibles `build` y `plan`.
- `opencode/plugins`: plugin de delegacion background.

## Reglas importantes

- El orquestador decide, divide y coordina.
- Los subagentes hacen trabajo acotado y devuelven evidencia compacta.
- `oo-claudevil` usa Claude Code y es caro.
- `oo-claudevil` solo debe llamarse si se pide explicitamente o al final de una tarea grande ya terminada y validada.
- Para ejecuciones cortas con `opencode run`, usar `task`.
- Para sesiones vivas largas, usar `delegate`.
- `delegation_read` debe ser una consulta rapida: resultado o estado en marcha.

## Instalar en Codex

Desde esta carpeta:

```sh
mkdir -p ~/.codex/agents
cp codex/agents/*.toml ~/.codex/agents/
cp codex/AGENTS.md ~/.codex/AGENTS.md
```

Validar:

```sh
python3 -c 'import pathlib,tomllib; [tomllib.loads(p.read_text()) for p in pathlib.Path.home().joinpath(".codex/agents").glob("oo-*.toml")]; print("codex agents ok")'
codex features list | rg multi_agent
codex debug prompt-input "verifica subagentes" | rg "oo-claudevil|Protocolo de subagentes Codex"
```

## Instalar en OpenCode

Desde esta carpeta:

```sh
mkdir -p ~/.config/opencode/agents
mkdir -p ~/.config/opencode/plugins
mkdir -p ~/.opencode/agents

cp opencode/agents/*.md ~/.config/opencode/agents/
cp opencode/plugins/background-agents.ts ~/.config/opencode/plugins/
cp opencode/aliases/*.md ~/.opencode/agents/
```

Validar:

```sh
bun --check ~/.config/opencode/plugins/background-agents.ts
opencode agent list
opencode agent list --pure | rg "orquestador|oo-claudevil|oo-qa|oo-abogado-diablo"
```

## Probar ClaudEvil sin OpenCode

Esto consume Claude Code. Usa Sonnet 4.6 con limite maximo de 1.50 USD.

```sh
printf '%s' 'Responde exactamente: CLAUDEVIL_OK' | claude -p --model claude-sonnet-4-6 --output-format json --max-budget-usd 1.50 --no-session-persistence --tools ""
```

## Probar OpenCode con ClaudEvil

Esto tambien consume Claude Code.

```sh
opencode run --agent orquestador --format json --title smoke-claudevil "Peticion explicita de ClaudEvil. No modifiques archivos. Usa task con oo-claudevil para una prueba minima. Debe cerrar con VEREDICTO_CLAUDEVIL_SMOKE."
```

## Subagentes incluidos

- `oo-analista`: diagnostico y lectura sin editar.
- `oo-implementador`: cambios acotados y autovalidacion.
- `oo-qa`: pruebas, build, lint y regresiones.
- `oo-navegador`: validacion UI con navegador.
- `oo-abogado-diablo`: critica interna de decisiones.
- `oo-estado`: continuidad y checkpoints.
- `oo-claudevil`: segunda opinion externa con Claude Code.

## Instalacion segura

Antes de copiar encima de una configuracion existente, puedes hacer backup:

```sh
mkdir -p ~/Desktop/backup-agentes
cp -R ~/.codex/agents ~/Desktop/backup-agentes/codex-agents 2>/dev/null || true
cp -R ~/.config/opencode/agents ~/Desktop/backup-agentes/opencode-agents 2>/dev/null || true
cp -R ~/.opencode/agents ~/Desktop/backup-agentes/opencode-aliases 2>/dev/null || true
```

## Veredicto esperado

Si todo esta bien:

- Codex carga 7 agentes `oo-*`.
- OpenCode muestra `orquestador` y los 7 subagentes `oo-*`.
- `oo-claudevil` no se usa salvo peticion explicita o cierre final de tarea grande.
