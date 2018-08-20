# box-a-watt

killawatt P4400 with 3d printed box cover, image processing and emoncms display of power usage.

# Parts List [work in progress]

- [$20 - P3 P4400 kill a watt](https://www.amazon.com/P3-P4400-Electricity-Usage-Monitor/dp/B00009MDBU)
- [$5 - Lowe's - Black Solar LED Path Light](https://www.lowes.com/pd/Portfolio-4x-Brighter-4-8-Lumen-Black-Solar-LED-Path-Light/1000398433)
- [$10 - Pi Zero W](https://www.adafruit.com/product/3400)
- [$2 - LED Backlight Small](https://www.adafruit.com/product/1626)

**Total** : $37

# Pi Setup

## Disable red camera capture led

	sudo nano /boot/config.txt
	disable_camera_led=1
	sudo reboot

# [Emoncms](https://emoncms.org) setup

## Install Emoncms package dependencies 

	sudo apt-get install apache2 mysql-server mysql-client php libapache2-mod-php php-mysql php-curl php-pear php-dev php-mcrypt php-json git-core redis-server build-essential -y

## mysql installation

	sudo mysql_secure_installation
	sudo mysqld --initialize
	sudo mysqladmin -p -u root version

	sudo mysql -u root -p
	CREATE DATABASE emoncms DEFAULT CHARACTER SET utf8;
	CREATE USER 'emoncms'@'localhost' IDENTIFIED BY 'YOUR_SECURE_PASSWORD_HERE';
	GRANT ALL ON emoncms.* TO 'emoncms'@'localhost';
	flush privileges;
	exit

## apache and php configuration

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

	sudo mkdir /var/lib/phpfiwa
	sudo mkdir /var/lib/phpfina
	sudo mkdir /var/lib/phptimeseries

	sudo chown www-data:root /var/lib/phpfiwa
	sudo chown www-data:root /var/lib/phpfina
	sudo chown www-data:root /var/lib/phptimeseries

	cd /var/www/html/emoncms/Modules
	git clone https://github.com/emoncms/dashboard.git
	git clone https://github.com/emoncms/app.git
	
	sudo touch /var/log/emoncms.log
	sudo chmod 666 /var/log/emoncms.log

## emoncms configuration

	cd /var/www/html/emoncms/
	cp default.settings.php settings.php

	nano settings.php
	$username = "emoncms";
	$password = "YOUR_SECURE_PASSWORD_HERE";
	$server   = "localhost";
	$database = "emoncms";

	http://localhost/emoncms/

# [ssocr](https://github.com/auerswal/ssocr)

[ssorc manual](https://www.unix-ag.uni-kl.de/~auerswal/ssocr/)

Used to process images captured with raspistill.

## Install ssocr dependencies 

	sudo apt-get install libimlib2-dev

## make

	cd ssocr
	make

## example command

 	./ssocr -v -d -1 -P -S -D -t 20 crop 650 410 600 500  remove_isolated erosion 3 opening 3 ../29_07_2018_00_58_47.jpg
