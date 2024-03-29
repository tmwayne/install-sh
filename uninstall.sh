#!/bin/bash
#
# Uninstall-sh
#
# Uninstall shell scripts
# Companion script to install-sh
#
# Tyler Wayne (2020)
#

THIS_PROG=$( basename $0 )
USAGE="Usage: $THIS_PROG [-i install_dir] prog_name"

help="$USAGE
Uninstalls program from local bin directory.

Options:
  -h, --help                Print this help.
  -i, --install-dir=DIR     Directory program is installed in.
                            Defaults to ~/.local/bin
"

## ARGUMENTS
########################################

# Default arguments
INSTALL_DIR=~/.local/bin/

for arg in "$@"; do
  shift
  case "$arg" in
    --help)         set -- "$@" "-h" ;;
    --install-dir)  set -- "$@" "-i" ;;
    --*)            echo "$THIS_PROG: unrecognized option '$arg'" >&2
                    echo "Try '$THIS_PROG --help' for more information."
                    exit 2 ;;
    *)              set -- "$@" "$arg"
  esac
done

# Command-line arguments
OPTIND=1
while getopts ":hi:" opt; do
  case $opt in
    h) echo -e "$help"; exit 0 ;;
    i) INSTALL_DIR=$( realpath $OPTARG ) ;;
    \?) echo "$THIS_PROG: unrecognized option '-$OPTARG'" >&2
        echo "Try '$THIS_PROG --help' for more information."
        exit 2 ;;
  esac
done
shift $((OPTIND-1))

PROG_NAME=$1
TARGET="$INSTALL_DIR"/$PROG_NAME

## ASSERTIONS
########################################

if [ $# -lt 1 ]; then
  echo $USAGE
  exit 1
fi

## MAIN
########################################

if rm -f "$TARGET"; then
  echo "Successfully uninstalled $PROG_NAME!"
else
  echo "$THIS_PROG: error: unable to uninstall $PROG_NAME ..." >&2
fi
