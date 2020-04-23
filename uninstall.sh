#!/bin/bash

THIS_PROG=$( basename $0 )
USAGE="Usage: $THIS_PROG [-i install_dir] prog_name"

Help() {
  # Function to display help at command line
  echo $USAGE
  echo
  echo "Options:"
  echo "  -h                  Print this help."
  echo "  -i install_dir      Directory program is installed in."
  echo
  echo "     prog_name        Name of file to uninstall"
  echo
}

## ARGUMENTS
########################################

# Default arguments
INSTALL_DIR=~/.local/bin/

# Command-line arguments
while getopts ":hf:i:p:" opt; do
  case $opt in
    h)  # Help
      Help
      exit 1
      ;;
    i)  # Installation directory
      INSTALL_DIR=$( readlink -f $OPTARG )
      ;;
    \?) # Default
      echo "Invalid option: -$OPTARG" >&2
      ;;
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
  echo "${0}: error: $PROG_NAME not found in $INSTALL_DIR ..."
  exit 1
fi

## MAIN
########################################

if rm -f "$TARGET"; then
  echo "Successfully uninstalled ${PROG_NAME}!"
else
  echo "$0: error: unable to uninstall $PROG_NAME ..."
fi
