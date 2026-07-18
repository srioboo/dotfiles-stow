#!/usr/bin/env bash

docs::_resolve_script_path() {
	local -r candidate="${1-}"
	local resolved=""

	if [ -n "$candidate" ] && [ -f "$candidate" ]; then
		echo "$candidate"
		return 0
	fi

	if [ -n "$candidate" ]; then
		resolved="$(command -v "$candidate" 2>/dev/null || true)"
		if [ -n "$resolved" ] && [ -f "$resolved" ]; then
			echo "$resolved"
			return 0
		fi
	fi

	echo ""
}

docs::_print_help() {
	local -r script_path="$1"

	while IFS= read -r line; do
		case "$line" in
		"##?"*)
			line="${line#\#\#\?}"
			line="${line# }"
			output::write "$line"
			;;
		esac
	done <"$script_path"
}

docs::_print_version() {
	local -r script_path="$1"

	while IFS= read -r line; do
		case "$line" in
		"#??"*)
			line="${line#\#\?\?}"
			line="${line# }"
			output::write "$line"
			return 0
			;;
		esac
	done <"$script_path"
}

docs::parse() {
	local script_path=""
	local -r caller_source="${BASH_SOURCE[1]-}"

	if [ $# -gt 0 ] && [ -n "${1-}" ] && [ -f "$1" ] && { [ "$1" = "$0" ] || [ "$1" = "$caller_source" ]; }; then
		script_path="$1"
		shift
	else
		script_path="$(docs::_resolve_script_path "$caller_source")"
		if [ -z "$script_path" ]; then
			script_path="$(docs::_resolve_script_path "$0")"
		fi
	fi

	if [ -z "$script_path" ]; then
		return 0
	fi

	local show_help=false
	local show_version=false

	for arg in "$@"; do
		case "$arg" in
		-h | --help | help) show_help=true ;;
		-v | --version | version) show_version=true ;;
		esac
	done

	if [ "$show_help" = true ]; then
		docs::_print_help "$script_path"
		exit 0
	fi

	if [ "$show_version" = true ]; then
		docs::_print_version "$script_path"
		exit 0
	fi
}
