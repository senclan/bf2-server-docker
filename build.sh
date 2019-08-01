#!/bin/sh

set -e

# https://stackoverflow.com/a/21188136
abspath() {
  # $1 : relative filename
  filename=$1
  parentdir=$(dirname "${filename}")

  if [ -d "${filename}" ]; then
      echo "$(cd "${filename}" && pwd)"
  elif [ -d "${parentdir}" ]; then
    echo "$(cd "${parentdir}" && pwd)/$(basename "${filename}")"
  fi
}

script_dir="$(abspath "$(dirname "$0")")"
dockerfile="${script_dir}/Dockerfile"
default_installer="bf2-linuxded-1.5.3153.0-installer.sh"
default_installer_path="${script_dir}/${default_installer}"
default_tag="bf2/server:latest"
default_extract_path="${script_dir}/files"

die(){
    exit_code=$1
    shift
    >&2 echo $@
    exit $exit_code
}

print_help(){
    >&2 echo "USAGE: $0 [OPTION]..."
    >&2 echo
    >&2 echo "Options:"
    >&2 echo "  -h        Prints this message"
    >&2 echo "  -i PATH   Path to installer [default: $default_installer_path]"
    >&2 echo "  -t tag    Tag for docker image [default: $default_tag]"
}

extract(){
    installer="$1"
    extract_path="$2"
    >&2 echo "Using installer: '$1'"
    >&2 echo "Extracting files to '$extract_path'"
    sh "$installer" --noexec --nox11 --target "$extract_path"
}

build(){
        docker_file="$(abspath "$1")"
        build_tag="$2"
        shift 2
        >&2 echo "Building docker image with tag '$build_tag'"
    (
        cd "$script_dir"
        docker build -t "$build_tag" -f "$docker_file" "$script_dir" $@
    )
}

installer="$default_installer_path"
build_tag="$default_tag"

while getopts ":hi:t:" opt; do
    case ${opt} in
        h )
            print_help
            exit 1
        ;;
        i )
            installer="$(abspath "$OPTARG")"
        ;;
        t )
            build_tag="$OPTARG"
        ;;
        \? )
            echo "Invalid Option: -$OPTARG" 1>&2
            exit 1
        ;;
    esac
done
shift $((OPTIND -1))

[ -f "$installer" ] || die 2 "Installer not found '$installer'"

extract "$installer" "$default_extract_path"
build "$dockerfile" "$build_tag" $@
