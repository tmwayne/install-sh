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
USAGE="Usage: $THIS_PROG [-f] [-i install_dir] [-n prog_name] file_name"

help="$USAGE
Installs program into local bin directory as copy or symlink.

Options:
  -c, --copy                Install a copy instead of a symlink.
  -h, --help                Print this help.
  -i, --install-dir=DIR     Directory program is installed in.
  -f, --force               Force overwrite if already exists.
                            Defaults to ~/.local/bin
  -n, --name=NAME           Name to install program as.
"

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
    --force)        set -- "$@" "-f" ;;
    --name)         set -- "$@" "-n" ;;
    --*)            echo "$THIS_PROG: unrecognized option '$arg'" >&2
                    echo "Try '$THIS_PROG --help' for more information."
                    exit 2 ;;
    *)              set -- "$@" "$arg"
  esac
done

# Command-line arguments
OPTIND=1
while getopts ":hcfi:n:" opt; do
  case $opt in
    h) echo -e "$help"; exit 0 ;;
    c) COPY=y ;;
    i) INSTALL_DIR=$( realpath $OPTARG ) ;;
    n) PROG_NAME=$OPTARG ;;
    f) FORCE=y ;;
    \?) echo "$THIS_PROG: unrecognized option '-$OPTARG'" >&2
        echo "Try '$THIS_PROG --help' for more information."
        exit 2 ;;
  esac
done
shift $((OPTIND-1))

FILE_NAME=$( realpath -q "$1" )

BASE_NAME=$( basename "${FILE_NAME%%.*}" )
PROG_NAME=${PROG_NAME:-$BASE_NAME}

TARGET="$INSTALL_DIR"/$PROG_NAME
TMP="$TARGET".tmp

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

# Check for existing file
if [ -f "$TARGET" ]; then
  target_exists=y
fi

if [ "$FORCE" == y ]; then
  overwrite=y
elif [ "$target_exists" == y ]; then
  read -p "$PROG_NAME already exists. Overwrite? (y/n) [n]: " overwrite
fi

if [ "$target_exists" == y ] && [ "$overwrite" != y ]; then
  echo "$THIS_PROG: error: aborting without overwriting ..." >&2
  exit 1
fi

# Install and save whether it was success
if [ "$COPY" == y ]; then
  if cp "$FILE_NAME" "$TMP"; then successful_install=y; fi
else
  ## ln returns an exit code of 0 even if the link it creates is broken
  ## we ensure that the link it create works
  if ln -s "$FILE_NAME" "$TMP" && realpath "$TMP" > /dev/null 2>&1; then
    successful_install=y;
  fi
fi

if [ "$successful_install" == y ]; then
  echo "Successfully installed $PROG_NAME!"
  mv "$TMP" "$TARGET"
else
  echo "$THIS_PROG: error: failed to install $PROG_NAME ..." >&2
  rm -f "$TMP"
  exit 1
fi


