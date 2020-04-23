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

Help() {
  # Function to display help at command line
  echo $USAGE
  echo
  echo "Options:"
  echo "  -h, --help                Print this help."
  echo "  -i, --install-dir=DIR     Directory program is installed in."
  echo
  echo "  prog_name                 Name of file to uninstall"
}

## ARGUMENTS
########################################

# Default arguments
INSTALL_DIR=~/.local/bin/

for arg in "$@"; do
  shift
  case "$arg" in
    "--help")         set -- "$@" "-h" ;;
    "--install-dir")  set -- "$@" "-i" ;;
    "--*")            echo "$THIS_PROG: error: invalid option: ${arg}" >&2
                      echo $USAGE; exit 1 ;;
    *)                set -- "$@" "$arg"
  esac
done

# Command-line arguments
OPTIND=1
while getopts ":hcf:i:p:" opt; do
  case $opt in
    h) Help; exit 1 ;;
    i) INSTALL_DIR=$( readlink -f $OPTARG ) ;;
    \?) echo "$THIS_PROG: error: invalid option: -$OPTARG" >&2
        echo $USAGE; exit 1 ;;
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

if [ ! -f "$TARGET" ]; then
  echo "${0}: error: $PROG_NAME not found in $INSTALL_DIR ..." >&2
  exit 1
fi

## MAIN
########################################

if rm -f "$TARGET"; then
  echo "Successfully uninstalled ${PROG_NAME}!"
else
  echo "$0: error: unable to uninstall $PROG_NAME ..." >&2
fi
