#Instala as dependências do Nagios
yum install -y epel-release gd gd-devel wget httpd php gcc make perl tar sendmail supervisors php-cli glibc glibc-common net-snmp openssl-devel bind-utils imake binutils cpp postgresql-devel mysql-libs mysql-devel openssl pkgconfig gd-progs libpng libpng-devel libjpeg libjpeg-devel perl-devel net-snmp-devel net-snmp-perl net-snmp-utils
sudo service httpd start
#Cria o usuário nagios e grupo nagcmd 
sudo useradd nagios
sudo groupadd nagcmd 
#Adiciona o usuário nagios ao grupo nagcmd
usermod -a -G nagcmd nagios
usermod -a -G nagcmd apache
#Download dos fontes
cd /tmp
wget http://prdownloads.sourceforge.net/sourceforge/nagios/nagios-4.0.8.tar.gz
wget https://www.nagios-plugins.org/download/nagios-plugins-2.0.3.tar.gz
# Extração dos fontes
tar -xzvf nagios-4.0.8.tar.gz
tar -xzvf nagios-plugins-2.0.3.tar.gz
#Instalação do nagios-core
cd /tmp/nagios-4.0.8
./configure --with-command-group=nagcmd
make all
make install
make install-init
make install-config
make install-commandmode
make install-webconf
sudo cp -R contrib/eventhandlers/ /usr/local/nagios/libexec/
sudo chown -R nagios:nagios /usr/local/nagios/libexec/eventhandlers
sudo /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
sudo /etc/init.d/nagios start
sudo /etc/init.d/httpd start
#Cria usuário para acesso WEB no Nagios
htpasswd -b -c /usr/local/nagios/etc/htpasswd.users nagiosadmin nagiosadmin
#Inicia o Apache
sudo service httpd start
#Instalação dos plugins do Nagios 
cd /tmp/nagios-plugins-2.0.3
./configure --with-nagios-user=nagios --with-nagios-group=nagios
make
make install
#Adicionando o Nagios e Apache, para iniciar junto com o sistema
chkconfig --add nagios
chkconfig --level 35 nagios on
chkconfig --add httpd
chkconfig --level 35 httpd on
touch /var/www/html/index.html
chmod 755 /var/www/html/index.html
#Inicia o Nagios
#cp /vagrant/conf_files/group /etc/group
#chown nagios.nagcmd /usr/local/nagios/var/rw
#chmod g+rwx /usr/local/nagios/var/rw
#chmod g+s /usr/local/nagios/var/rw
sudo service httpd restart
sudo service nagios restart
