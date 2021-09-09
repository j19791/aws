#!/bin/bash
#Atualizando os pacotes confirmando as perguntas c/ yes
yum update -y
#adicionando os repositórios
amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
#Instalando o apache e o mysql
yum install -y httpd mariadb-server
#inicialização automática
systemctl start httpd
#carrega o servi�o automaticamente
systemctl enable httpd
systemctl start mariadb
systemctl enable mariadb
#Ajustando o permissionamento: ec2-user dentro do grupo apache
usermod -a -G apache ec2-user
#dentro do /var/www
chown -R ec2-user:apache /var/www