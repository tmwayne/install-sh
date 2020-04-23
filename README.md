# Install-sh

Install and uninstall user created executables into installation directory
with ease.

## Installation

Clone this repo. Navigate to where you've cloned it. Copy and paste the
following commands.

  chmod 0755 install.sh uninstall.sh
  ./install.sh -n install-sh install.sh

This will create a symlink in your ~/.local/bin directory to install.sh.
It will name the program name will be install-sh.
You can use it to install uninstall.sh

  install-sh -n uninstall-sh uninstall.sh

If you don't specify the name with the -n flag, the program will be installed
using the base name of the file path.

  install-sh uninstall.sh

This will install uninstall.sh as `uninstall`

To uninstall a package, simply provide the program name.

  uninstall-sh some-program

