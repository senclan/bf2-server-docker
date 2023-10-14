#!/usr/bin/env bash
set -Eeo pipefail

BF2_START_SCRIPT="${BF2_START_SCRIPT:-/bf2/start.sh}"

declare -a flags=(
    "dedicated"
    "multi"
    "demo"
    "lowPriority"
    "noStatusMonitor"
    "ranked"
    "ai"
)

declare -a options=(
    "joinServer"
    "config"
    "mapList"
    "loadLevel"
    "maxPlayers"
    "gameMode"
    "modPath"
    "port"
    "rsconfig"
)

main(){
	# if first arg looks like a flag, assume we want to run bf2server
	if [ "${1:0:1}" = '+' ]; then
		set -- bf2server "$@"
	fi

    if [ "$1" = "bf2server" ]; then
        declare -a args=("$@")

        for flag in "${flags[@]}"; do
            evar="BF2_${flag^^}"
            
            if [[ "${!evar}" =~ y|yes|t|true|1 ]]; then
                args+=("+$flag")
            fi
        done

        for option in "${options[@]}"; do
            evar="BF2_${option^^}"
            
            if [ -n "${!evar}" ]; then
                args+=("+$option" "${!evar}")
            fi
        done

        set -- "${args[@]}"
    fi

    exec "$@"
}

main "$@"
