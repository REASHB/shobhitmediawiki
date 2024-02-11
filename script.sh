#!/bin/sh

echo "Starting Installing Mediawiki...."
yum install centos-release-scl

yum install httpd24-httpd rh-php73 rh-php73-php rh-php73-php-mbstring rh-php73-php-mysqlnd rh-php73-php-gd rh-php73-php-xml mariadb-server mariadb <<EOF
y
EOF

systemctl start mariadb

mysql_secure_installation <<EOF

n
y
y
y
y
EOF

echo "Now Configuring mysql database...."

mysql -h localhost -u root  -e "CREATE USER 'wiki'@'localhost' IDENTIFIED BY 'abc123';"
mysql -h localhost -u root  -e "CREATE DATABASE wikidatabase;"
mysql -h localhost -u root  -e "GRANT ALL PRIVILEGES ON wikidatabase.* TO 'wiki'@'localhost';FLUSH PRIVILEGES;"
mysql -h localhost -u root  -e "SHOW DATABASES;SHOW GRANTS FOR 'wiki'@'localhost';"

echo "Configuring mysql database Finished...."

systemctl enable mariadb
systemctl enable httpd24-httpd.service

systemctl start httpd24-httpd.service


echo "Configuring Mediawiki and downloading...."
cd /home/adminUser
wget https://releases.wikimedia.org/mediawiki/1.35/mediawiki-1.35.0.tar.gz
# Download the GPG signature for the tarball and verify the tarball's integrity:
wget https://releases.wikimedia.org/mediawiki/1.35/mediawiki-1.35.0.tar.gz.sig
gpg --verify mediawiki-1.35.0.tar.gz.sig mediawiki-1.35.0.tar.gz

#configuraing Mediawiki

cd /opt/rh/httpd24/root/var/www
tar -zxf /home/adminUser/mediawiki-1.35.0.tar.gz
cp -a /opt/rh/httpd24/root/var/www/mediawiki-1.35.0/. /opt/rh/httpd24/root/var/www/html/

echo "Done Configuring Mediawiki and downloading...."

echo "Restart Apache and firwalld setting up...."

systemctl restart httpd24-httpd.service


#firewall concgiguration
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https
systemctl restart firewalld


x=$(getenforce)

if [ "$x" = "Enforcing" ]; then
    restorecon -FR /opt/rh/httpd24/root/var/www/html
    ls -lZ /opt/rh/httpd24/root/var/www/html/
fi


echo "Finishing Installing Mediawiki...."