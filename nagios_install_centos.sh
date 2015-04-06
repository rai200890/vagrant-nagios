#Instala as dependências do Nagios 
yum install -y wget make httpd php php-cli gcc glibc glibc-common gd gd-devel net-snmp
service httpd start
#Cria o usuário nagios e grupo nagcmd 
sudo useradd nagios
sudo groupadd nagcmd 
#Adiciona o usuário nagios ao grupo nagcmd 
usermod -a -G nagcmd nagios
usermod -a -G nagcmd apache 
#Cria o diretório para armazenar os fontes para a instalação 
mkdir downloads
cd downloads
#Download dos fontes
#verificar se é possivel clonar repositório do git nesse scripts
wget http://prdownloads.sourceforge.net/sourceforge/nagios/nagios-4.0.8.tar.gz
wget https://www.nagios-plugins.org/download/nagios-plugins-2.0.3.tar.gz
# Extração dos fontes
tar -xzvf nagios-4.0.8.tar.gz
tar -xzvf nagios-plugins-2.0.3.tar.gz
#Instalação do nagios-core
cd nagios-4.0.8
./configure --with-command-group=nagcmd
make all
make install
make install-init
make install-config
make install-commandmode
make install-webconf
cp -R contrib/eventhandlers/ /usr/local/nagios/libexec/
chown -R nagios:nagios /usr/local/nagios/libexec/eventhandlers
/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
/etc/init.d/nagios start
/etc/init.d/httpd start 
#Cria usuário para acesso WEB no Nagios
htpasswd -b -c /usr/local/nagios/etc/htpasswd.users nagiosadmin nagiosadmin
#Inicia o Apache
service httpd start 
#Instalação dos plugins do Nagios 
cd nagios-plugins-2.0.3
./configure --with-nagios-user=nagios --with-nagios-group=nagios
make
make install 
#Adicionando o Nagios e Apache, para iniciar junto com o sistema 
chkconfig --add nagios
chkconfig --level 35 nagios on
chkconfig --add httpd
chkconfig --level 35 httpd on
chkconfig --add nagios
chkconfig nagios on
sudo chmod 755 /var/www/html/index.html
#Inicia o Nagios
service nagios start 
