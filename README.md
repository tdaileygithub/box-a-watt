# box-a-watt
killawatt 3d printed box cover, image processing and emoncms display of power usage

# Emoncms  setup

	sudo apt-get install apache2 mysql-server mysql-client php libapache2-mod-php php-mysql php-curl php-pear php-dev php-mcrypt php-json git-core redis-server build-essential -y
	mysql_secure_installation
	mysqld --initialize
	sudo mysqladmin -p -u root version

	sudo pear channel-discover pear.swiftmailer.org
	sudo pecl install swift/swift redis
	printf "extension=redis.so" | sudo tee /etc/php/7.0/mods-available/redis.ini 1>&2

	sudo phpenmod redis
	sudo a2enmod rewrite
	sudo cat <<EOF >> /etc/apache2/sites-available/emoncms.conf
	<Directory /var/www/html/emoncms>
	    Options FollowSymLinks
	    AllowOverride All
	    DirectoryIndex index.php
	    Order allow,deny
	    Allow from all
	</Directory>
	EOF
	sudo echo 'ServerName localhost' >> /etc/apache2/apache2.conf
	sudo a2ensite emoncms
	sudo service apache2 reload

	cd /var/www/
	sudo chown $USER html
	cd html
	git clone -b stable https://github.com/emoncms/emoncms.git
	cd /var/www/html/emoncms
	git pull

	sudo mysql -u root -p
	CREATE DATABASE emoncms DEFAULT CHARACTER SET utf8;
	CREATE USER 'emoncms'@'localhost' IDENTIFIED BY 'YOUR_SECURE_PASSWORD_HERE';
	GRANT ALL ON emoncms.* TO 'emoncms'@'localhost';
	flush privileges;

	sudo mkdir /var/lib/phpfiwa
	sudo mkdir /var/lib/phpfina
	sudo mkdir /var/lib/phptimeseries

	sudo chown www-data:root /var/lib/phpfiwa
	sudo chown www-data:root /var/lib/phpfina
	sudo chown www-data:root /var/lib/phptimeseries

	cd /var/www/html/emoncms/
	cp default.settings.php settings.php

	nano settings.php
	$username = "USERNAME";
	$password = "YOUR_SECURE_PASSWORD_HERE";
	$server   = "localhost";
	$database = "emoncms";

	cd /var/www/html/emoncms/Modules
	git clone https://github.com/emoncms/dashboard.git
	git clone https://github.com/emoncms/app.git
	
	sudo touch /var/log/emoncms.log
	sudo chmod 666 /var/log/emoncms.log

	http://localhost/emoncms/

# ssocr

	Used to process pictures captured with raspistill

	https://github.com/auerswal/ssocr
	sudo apt-get install libimlib2-dev