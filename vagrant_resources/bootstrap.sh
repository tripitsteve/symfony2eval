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
# install php and modify settings
# ==============================================================================

echo -n "installing a whole lotta php..."
yes | apt-get install php5-fpm php5-mysql php5-curl php5-gd php5-intl php-pear php5-imagick php5-imap php5-mcrypt php5-memcached php5-ming php5-ps php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl php5-xcache &> /dev/null || exit 1
echo "done!"

# setting: use unix socket instead of port 9000
sed -i 's#listen = 127.0.0.1:9000#listen = /tmp/php5-fpm.sock#' /etc/php5/fpm/pool.d/www.conf

# setting: php.ini timezone
echo -n "modifying php timezone settings..."
sed -i 's#;date.timezone =#date.timezone = "America/Los_Angeles"#' /etc/php5/cli/php.ini
sed -i 's#;date.timezone =#date.timezone = "America/Los_Angeles"#' /etc/php5/fpm/php.ini
echo "done!"

echo -n "restarting php..."
service php5-fpm restart
echo "done!"

# ==============================================================================
# install dependencies
# ==============================================================================

# dependency: cURL
echo -n "Installing cURL..."
yes | apt-get install curl &> /dev/null || exit 1
echo "done!"

# dependency: composer
echo -n "Installing composer..."
curl -sS https://getcomposer.org/installer | php -- --install-dir=/bin &> /dev/null || exit 1
echo "done!"

# dependency: php5-intl
echo -n "Installing php5-intl..."
yes | apt-get install php5-intl &> /dev/null || exit 1
echo "done!"

# dependency: php5-apc
echo -n "Installing php-apc..."
yes | apt-get install php-apc &> /dev/null || exit 1
echo "done!"

# dependency: php5-mysql
echo -n "Installing php5-mysql..."
yes | apt-get install php5-mysql &> /dev/null || exit 1
echo "done!"

# dependency: redis

# ==============================================================================
# modify nginx settings
# ==============================================================================

echo -n "turning nginx off..."
nginx -s stop
echo "done!"

# setting: nginx.conf
if [ -f "/etc/nginx/nginx.conf" ]
then
    mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
fi
echo -n "modifying nginx.conf..."
cp /vagrant/nginx/nginx.conf /etc/nginx/nginx.conf
echo "done!"

# setting: nginx mimetypes
if [ -f "/etc/nginx/mime.types" ]
then
    mv /etc/nginx/mime.types /etc/nginx/mime.types.bak
fi
echo -n "modifying nginx mimetypes..."
cp /vagrant/nginx/mime.types /etc/nginx/mime.types
echo "done!"

# setting: sites-available
if [ -f "/etc/nginx/sites-available/default" ]
then
    echo -n "renaming default int sites-available..."
    mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak
    echo "done!"
fi
cp /vagrant/nginx/sites-available/tweetit.com /etc/nginx/sites-available

# setting: sites-enabled
echo -n "enabling tweetit.com in nginx config..."
ln -s /etc/nginx/sites-available/tweetit.com /etc/nginx/sites-enabled/tweetit.com
echo "done!"

echo -n "disabling default in nginx sites-enabled..."
rm /etc/nginx/sites-enabled/default
echo "done!"

# setting: nginx configurations
echo -n "moving h5bp nginx configurations..."
cp -r /vagrant/nginx/conf /etc/nginx/
echo "done!"

# mkdir: nginx logs
echo -n "making nginx log directory..."
mkdir /etc/nginx/logs/
touch /etc/nginx/logs/static.log
echo "done!"

echo -n "turning nginx on..."
nginx -s reload
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

echo "♥♥♥ Installation complete ♥♥♥"