#!/bin/bash
#
# Install-sh
#
# Install shell scripts easily into a local bin folder.
# Can install via both hard copy and symlink
#
# Tyler Wayne (2020)
#

THIS_PROG=$( basename $0 )
USAGE="Usage: $THIS_PROG [-i install_dir] [-p prog_name] file_name"

Help() {
  # Function to display help at command line
  echo $USAGE
  echo
  echo "Options:"
  echo "  -h, --help                Print this help."
  echo "  -c, --copy                Install a copy instead of a symlink."
  echo "  -i, --install-dir=DIR     Directory program is installed in."
  echo "  -p, --prog-name=NAME      Name to install program as."
  echo
  echo "  file_name                 Name of file to install"
}

## ARGUMENTS
##############################

# Default arguments
INSTALL_DIR=~/.local/bin/

for arg in "$@"; do
  shift
  case "$arg" in
    --help)         set -- "$@" "-h" ;;
    --copy)         set -- "$@" "-c" ;;
    --install-dir)  set -- "$@" "-i" ;;
    --prog-name)    set -- "$@" "-p" ;;
    --*)            echo "$THIS_PROG: unrecognized option '$arg'" >&2
                    echo "Try '$THIS_PROG --help' for more information."
                    exit 2 ;;
    *)              set -- "$@" "$arg"
  esac
done

# Command-line arguments
OPTIND=1
while getopts ":hcf:i:p:" opt; do
  case $opt in
    h) Help; exit ;;
    c) COPY=y ;;
    i) INSTALL_DIR=$( readlink -f $OPTARG ) ;;
    p) PROG_NAME=$OPTARG ;;
    \?) echo "$THIS_PROG: unrecognized option '-$OPTARG'" >&2
        echo "Try '$THIS_PROG --help' for more information."
        exit 2 ;;
  esac
done
shift $((OPTIND-1))

FILE_NAME=$( readlink -f "$1" )

BASE_NAME=$( basename "${FILE_NAME%%.*}" )
PROG_NAME=${PROG_NAME:-$BASE_NAME}

## ASSERTIONS
##############################

if [ $# -lt 1 ]; then
  echo $USAGE
  exit 1
fi

if [ ! -d "$INSTALL_DIR" ]; then
  echo "$THIS_PROG: error: target directory $INSTALL_DIR does not exist ..." >&2
  exit 1
fi

if [ ! -f "$FILE_NAME" ]; then
  echo "$THIS_PROG: error: $FILE_NAME not found ..." >&2
  exit 1
fi


## MAIN
##############################



TARGET="$INSTALL_DIR"/$PROG_NAME

# Check for existing file
if [ -f "$TARGET" ]; then
  target_exists=y
fi

if [ "$target_exists" == "y" ]; then
  read -p "$PROG_NAME already exists. Overwrite? (y/n) [n]: " overwrite
fi

if [ "$overwrite" != "y" ]; then
  echo "$THIS_PROG: error: aborting without overwriting ..." >&2
  exit 1
fi

# Install and save whether it was success
if [ "$COPY" == "y" ]; then
  if cp "$FILE_NAME" "$TARGET".new; then successful_install=y; fi
else
  if ln -s "$FILE_NAME" "$TARGET".new; then successful_install=y; fi
fi

if [ "$successful_install" == "y" ]; then
  echo "Successfully installed ${PROG_NAME}!"
  mv "$TARGET".new "$TARGET"
else
  echo "$THIS_PROG: error: failed to install $PROG_NAME ..." >&2
  rm -f "$TARGET".new
  exit 1
fi


