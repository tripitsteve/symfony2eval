# !/usr/bin/env bash

# ==============================================================================
# prevent this script from running more than once
# ==============================================================================
eval vagrant_installed_file="~/.vagrant_installed"  # use eval to expand the path

if [ -f $vagrant_installed_file ]
then
    echo "Vagrant up already run.  Exiting..."
    exit 0
fi

# ==============================================================================
# install dependencies
# ==============================================================================

# dependency: cURL
echo -n "Installing cURL..."
yes | apt-get install curl
echo "done!"

# dependency: composer
echo -n "Installing composer..."
curl -sS https://getcomposer.org/installer | php -- --install-dir=/bin
echo "done!"

# dependency: php5-intl
echo -n "Installing php5-intl..."
yes | apt-get install php5-intl
echo "done!"

# dependency: php5-apc
echo -n "Installing php-apc..."
yes | apt-get install php-apc
echo "done!"

# dependency: php5-mysql
echo -n "Installing php5-mysql..."
yes | apt-get install php5-mysql
echo "done!"

# dependency: redis

# ==============================================================================
# modify settings
# ==============================================================================

echo -n "modifying php timezone settings..."

# setting: php5-cli/php.ini timezone
cat /etc/php5/cli/php.ini | sed -i 's#;date.timezone =#date.timezone = "America/Los_Angeles"#' /etc/php5/cli/php.ini

# setting: php5-cgi/php.ini timezone
cat /etc/php5/cgi/php.ini | sed -i 's#;date.timezone =#date.timezone = "America/Los_Angeles"#' /etc/php5/cgi/php.ini

echo "done!"

# ==============================================================================
# cleanup
# ==============================================================================

#
# create .vagrant_installed to indicate that this script finished successfully
#
echo -n "Creating .vagrant_installed..."
touch $vagrant_installed_file
echo 'done!'

echo "Installation complete!  <3"