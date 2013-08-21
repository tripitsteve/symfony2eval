# !/usr/bin/env bash

# ==============================================================================
# prevent this script from running more than once
# ==============================================================================
eval vagrant_installed_file="~/.vagrant_installed"  # use eval to expand the path

if [ -f $vagrant_installed_file ]
then
    echo "Vagrant up already run.  Exiting..."
#    exit 0
fi

# ==============================================================================
# install dependencies
# ==============================================================================

# dependency: cURL
yes | apt-get install curl

# dependency: composer
curl -sS https://getcomposer.org/installer | php -- --install-dir=/bin

# dependency: redis



#
# create .vagrant_installed to indicate that this script finished successfully
#
touch $vagrant_installed_file

echo 'done!'