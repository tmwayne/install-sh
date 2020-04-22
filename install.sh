#!/bin/bash

THIS_PROG=$( basename $0 )
USAGE="Usage: $THIS_PROG [-i install_dir] [-p prog_name] file_name"

## ARGUMENTS
##############################

# Default arguments
# PROG_NAME=check-battery
INSTALL_DIR=~/.local/bin/
# FILE_NAME=/home/tyler/scripts/check-battery/check-battery.sh

# Command-line arguments
while getopts ":f:i:p:" opt; do
  case $opt in
    h)  # Help
      echo $USAGE
      exit 1
      ;;
    i)  # Installation directory
      INSTALL_DIR=$( readlink -f $OPTARG )
      ;;
    p)  # Program name
      PROG_NAME=$OPTARG
      ;;
    \?) # Default
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done
shift $((OPTIND-1))

## ASSERTIONS
##############################

if [ $# -lt 1 ]; then
  echo $USAGE
  exit 1
fi

if [ ! -d "$INSTALL_DIR" ]; then
  echo "${0}: error: target directory $INSTALL_DIR does not exist ..."
  exit 1
fi

FILE_NAME=$( readlink -f $1 )

if [ ! -f "$FILE_NAME" ]; then
  echo "${0}: error: $FILE_NAME not found ..."
  exit 1
fi


## MAIN
##############################


BASE_NAME=$( basename ${FILE_NAME%%.*} )
PROG_NAME=${PROG_NAME:-$BASE_NAME}

TARGET="$INSTALL_DIR"/$PROG_NAME

# Check for existing file
if [ -f "$TARGET" ]; then
  target_exists=1
else
  target_exists=0
fi

overwrite=y
if [ $target_exists -eq 1 ]; then
  read -p "Target already exists. Overwrite? (y/n) [n]: " overwrite
fi

if [ "$overwrite" != "y" ]; then
  echo "${0}: error: aborting without overwriting ..."
  exit 1
fi

# Make backup
if [ $target_exists -eq 1 ]; then
  mv "$TARGET" "$TARGET".bk
fi

# Install
if ln -s "$FILE_NAME" "$TARGET"; then
  successful_install=1
else
  successful_install=0
fi

if [ $successful_install -eq 1 ]; then
  echo "Successfully installed ${PROG_NAME}!"
  exit_code=0
else
  echo "${0}: error: failed to install target ..."
  rm -f "$TARGET"
  exit_code=1
fi

# Clean up
if [ $target_exists -eq 1 ]; then
  mv "$TARGET".bk "$TARGET"
  rm -f "$TARGET".bk
fi

# Exit
exit $exit_code

