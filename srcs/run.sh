#!/bin/bash

service mysql start

# ssl configuration
openssl req	-newkey rsa:4096 \
			-days 365 \
			-nodes \
			-x509 \
			-subj "/C=KR/ST=Seoul/O=42Seoul/OU=Gam/CN=localhost" \
			-keyout localhost.dev.key \
			-out localhost.dev.crt

mv localhost.dev.key /etc/ssl/private/
mv localhost.dev.crt /etc/ssl/certs/
chmod 600 /etc/ssl/private/localhost.dev.key /etc/ssl/certs/localhost.dev.crt

# Nginx configuration
cp -p ./tmp/default /etc/nginx/sites-available

# Wordpress configuration
tar -xvf ./tmp/wordpress-5.6.2.tar.gz
rm ./tmp/wordpress-5.6.2.tar.gz
mv /wordpress/ /var/www/html
cp ./tmp/wp-config.php /var/www/html/wordpress

# MariaDB configuration
echo "CREATE DATABASE wordpress;" \
	| mysql -u root --skip-password
echo "CREATE USER 'haseo'@'localhost' IDENTIFIED BY 'haseo';" \
	| mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'haseo'@'localhost' WITH GRANT OPTION;" \
	| mysql -u root --skip-password
echo "FLUSH PRIVILEGES" \
	| mysql -u root --skip-password

# phpMyAdmin configuration
tar -xvf ./tmp/phpMyAdmin-4.9.7-all-languages.tar.gz
rm ./tmp/phpMyAdmin-4.9.7-all-languages.tar.gz
mv phpMyAdmin-4.9.7-all-languages phpmyadmin
mv phpmyadmin /var/www/html/
cp ./tmp/config.inc.php /var/www/html/phpmyadmin/
mysql < /var/www/html/phpmyadmin/sql/create_tables.sql

# permission setting
chown -R www-data:www-data /var/www/*
find /var/www -type d -exec chmod 755 {} \;
find /var/www -type f -exec chmod 644 {} \;

# service start
service nginx start
service mysql restart
service php7.3-fpm start
service php7.3-fpm status

bash
