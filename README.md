### Autenticação

- iam : ativar segundo fator de autenticação
	- Activate MFA on root account, escanear o qr code c/ o Google Autenticator: tokens (one time passwords)



### Definições
- e2: elastic computer
- provisionar: colocar a maq virtual no ar na nuvem
- bilhetando
- redundancia
- instancias ec2 : máquinas virtuais q subimos na aws




t2.micro free-tier 750h (1 mes) ligada ou 12 meses




região: us-east-1 (contas novas) norte da Virginia, Ohio com zonas de disponibilidade isoladas entre si (a, b, c,d,e)

ec2 dashboard

### security groups
- acesso web inbound rules type:http/https
- acesso-remoto inbound rules MyIp (vai mudar sempre)

### instances
actions
	instance settings
		change termination protection: desabilita o terminate 

	network
		change sec group: default - máquinas dentro desse grupo consegue se comunicar entre si
				  acesso web - permitir o acesso http (apache)

### launch instances
	aws marketplace: imagens predefinidas
	criar instancia customizada p/ser usada como imagem (template depois)
	lauch instace details - advanced details -user data - incluir script
		linux-free tier 1cpu, 1gb de ram, 8gb storage (o serviço de storage é cobrado separadamente)
		sec group: usar ssh p/ gerenciar maq linux na porta 22, MyIP: só eu uso mas cuidado q esse ip muda toda hora
		autenticação feita com chaves		


monitor
	get system log


instance state: terminate - exclui instancia

sec group
inbound: regras de acesso (entrante)
default vpc sec group: rede dentro da aws. todos os protocolos p/ todas as portas estão permitidos. Para comunicação direta entre as suas instancias
acesso-web: inbound: http, https, ipv4, ipv6

criar imagem: parar a instancia q vai ser usada p/ não criar uma imagem corrompida 
action>image>create image: web-dev-template
minhas amis
atenção: na hora de conectar numa instancia criada a partir de uma imagem, o comando q aparce p/ conectar é c/ usuário root . usar usuario ec2-user

elastic ip: ip fixo
alocar um ip 
associar o ip alocado à uma instancia
vc é tarifado qdo a instancia c/ o ip associado estiver parada
vc pode ter + de 1 ip associado a uma mesma instancia: esses outros ips vão ser tarifados

-----------------------
chmod 400 aws-jeffrm.pem
leitura só c/ o dono

scp -i "aws-jeffrm.pem" volume-exemplo.zip ec2-user@ec2-52-14-225-19.us-east-2.compute.amazonaws.com:~/.
copia os arquivos localmente p/ a maquina remota

scp -i "aws-jeffrm.pem" ec2-user@ec2-18-188-57-90.us-east-2.compute.amazonaws.com:/home/ec2-user/*.* "C:\Users\Jefferson\Desktop\arquivos_download_playlist\mp3"
copia os arquivos da maq remota p/ a local

gerenciamento remoto da instancia - no mesmo diretório da chave
ssh -i "aws-jeffrm.pem" ec2-user@ec2-52-14-243-227.us-east-2.compute.amazonaws.com

sudo yum update 
atualiza os pacotes da máquina


ping ip interno da outra máquina

netstat -ltun
para verificar se as portas 80 (web), 3306 (bco) estã no ar

cd /var
ls -l
verifica as permissões (www) ec2-user

parar e desativar o mariadb criado anteriormente c/ script pois vai ser usado o rds
sudo systemctl stop mariadb
sudo systemctl disable mariadb

para criar uma imagem, parar a maquina
sudo shutdown -h now

---------------------

ebs - elastic block store (discos) - precificação ocorre mesmo c/ a maquina parada
free tier - 30gb (somatoria dos discos usados)


-------------------
RDS - SERVIÇO BD
não esqueça de selecionar uma com template free- tier
admin
password que será usada p/ conectar com ssh H8NJJaUJkKm9Qv3

copiar o endpoint database-1.cmblgshfej2r.us-east-2.rds.amazonaws.com

comunicação ec2-rds
incluir o sec group da maquina ec2 usada p/ conectar no ssh na rede default (mesma vpc do bd)

ja conectado no ssh>> mysql -u admin -h database-1.cmblgshfej2r.us-east-2.rds.amazonaws.com -p

---------------
ip publico: só consegui conectar com http e nao c/ https

-----------------
Alta disponibilidade - escalar a aplicação

Load balancer: vai receber todo o tráfego e distribuira p/ todas as instancias (replicas ESCALADAS automaticamente)
CRIAR:
usar o http/https
nome: LB-webCadastro
vpc: para ter redundancia utilizar pelo menos 2 sub-redes a e b
sec group: usar http - usar sec group specifico  para o lb : LB-acesso-web
TARGET GROUP: p/ onde o lb olha- nas instancias agrupadas - associa-las ao tg
nome: TG-cadastro-web
associar no tg um grupo de auto-scaling

AUTO SCALING:
criar a config: usar a imagem criada anteriormente ( a base)
AS-config-webcastro
sec group: acesso da porta 80 (acesso-web), acesso remoto e default

auto scaling group: 
Create Auto Scaling group
Switch to launch configuration: selecionar a AS-config-webcastro

nome AS-Group-cadastroWeb
rde vpc default sub net .Tem que ser aqui as mesmas subnets, A e B.
group size: pelo menos 2 maquinas. se eu precisar, vou subindo
associar a um load balance target group : TG-cadastro-web
Health Check: elb

IP de chegada não é mais o da instância,e sim do Load Balance





