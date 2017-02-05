# variables
PASSWORD="123456789"
CONFIG="example.com"

# upgrade system
add-apt-repository ppa:ondrej/php
apt update
apt -y upgrade

# install mariadb
debconf-set-selections <<< "mysql-server mysql-server/root_password password ${PASSWORD}"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${PASSWORD}"
apt-get -y install mariadb-server mariadb-client

# install apache2
apt-get -y install apache2
apt-get install -y php7.0 php7.0-mysql libapache2-mod-php7.0
service apache2 restart

# set virtualhosts up on apache2
a2dissite 000-default.conf
service apache2 restart
cat > /etc/apache2/sites-available/${CONFIG}.conf <<EOF1
<VirtualHost *:80>
     ServerAdmin webmaster@${CONFIG}
     ServerName ${CONFIG}
     ServerAlias www.${CONFIG}
     DocumentRoot /var/www/${CONFIG}/public_html/
     ErrorLog /var/www/${CONFIG}/logs/error.log
     CustomLog /var/www/${CONFIG}/logs/access.log combined
</VirtualHost>
EOF1
mkdir -p /var/www/${CONFIG}/public_html
mkdir /var/www/${CONFIG}/logs
chown -R $USER:$USER /var/www/${CONFIG}/public_html
chmod -R 755 /var/www

a2ensite ${CONFIG}.conf
service apache2 restart
