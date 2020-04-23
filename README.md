# Install-sh

Install and uninstall executables into an installation directory
with ease. This is useful for shell scripts you've written
that you'd like to be able to call from anywhere.

## Installation

Clone this repo. Navigate to where you've cloned it. Copy and paste the
following commands.

    chmod 0755 install.sh uninstall.sh
    ./install.sh -n install-sh install.sh

This will create a symlink in your `~/.local/bin` directory to `install.sh`.
It will name the program `install-sh`.  

Then install `uninstall.sh`.

    install-sh -n uninstall-sh uninstall.sh

## Usage

If you don't specify the name with the `-n` flag, the program will be installed
using the base name of the file path.

    install-sh /path/to/some-program.sh

will install under the name `some-program`

To uninstall a package, simply provide the program name.

    uninstall-sh some-program

