### Conta
- aws.amazon.com
- cartão crédito internacional obrigatório
- 12 meses gratuitos: free-tier - t2.micro free-tier 750h (1 mes) ligada ou 12 meses
- sempre gratuito
- testes 

### Autenticação
- iam : ativar segundo fator de autenticação
	- Activate MFA on root account, escanear o qr code c/ o Google Autenticator: tokens (one time passwords)

### Definições
- alta disponibilidade
- e2: elastic computer
- escalabilidade:
- faas: function as a service (AWS Lambda) 
- instancias ec2 : máquinas virtuais q subimos na aws
- provisionar: colocar a maq virtual no ar na nuvem
- bilhetando
- redundancia
- região: datacenters - us-east-1 (contas novas) norte da Virginia, Ohio com 6 zonas de disponibilidade isoladas entre si (a, b, c,d,e) e c/ redundância
- segmentar: separar instancias de servidor web e servidor bd, por ex.

### ec2 dashboard
- aws.console
- excluir instancia: instance state: terminate 

#### launch instances
- aws marketplace: imagens predefinidas
- criar instancia customizada p/ser usada como imagem (template depois)
	- incluir script: lauch instace details, advanced details, user data
	- criar imagem: parar a instancia q vai ser usada p/ não criar uma imagem corrompida `action>image>create image: web-dev-template`
	- lançar instancia e criar a partir das minhas amis. Não esquece de asscoiar aos sec-group
	- atenção: na hora de conectar numa instancia criada a partir de uma imagem, o comando q aparece em Connect to Your Instance é c/ usuário root .Usar usuario ec2-user 
- linux-free tier 1cpu, 1gb de ram, 8gb storage (o serviço de storage é cobrado separadamente)
- sec group: usar ssh p/ gerenciar maq linux na porta 22, MyIP: só eu uso mas cuidado q esse ip muda toda hora
- autenticação feita com chaves		


#### Actions
- desabilita o terminate : actions/	instance settings/change termination protection
- monitor and troubleshoot:	get system log

### gerenciamento remoto da instancia 
- Conexão c/ SSH 
	- selecionar a estância lançada e clicar em connect
	- no mesmo diretório da chave
`ssh -i "aws-jeffrm.pem" ec2-user@ec2-52-14-243-227.us-east-2.compute.amazonaws.com`

	- no primeiro acesso, o aws vai reclamar pois a sua chave esta com muito acesso. Configurar leitura só p/ o dono `chmod 400 aws-jeffrm.pem`

	- atualizar os pacotes da máquina `sudo yum update` 

	- copia os arquivos localmente p/ a maquina remota `scp -i "aws-jeffrm.pem" volume-exemplo.zip ec2-user@ec2-52-14-225-19.us-east-2.compute.amazonaws.com:~/.`

	- copia os arquivos da maq remota p/ a local `scp -i "aws-jeffrm.pem" ec2-user@ec2-18-188-57-90.us-east-2.compute.amazonaws.com:/home/ec2-user/*.* "C:\Users\Jefferson\Desktop\arquivos_download_playlist\mp3"`

	- ping ip interno da outra máquina

	- para verificar se as portas 80 (web), 3306 (bd) estã no ar `netstat -ltun`

	- verifica as permissões (www) ec2-user `cd /var ls -l`

	- parar e desativar o mariadb criado anteriormente c/ script pois vai ser usado o rds 
`
sudo systemctl stop mariadb
sudo systemctl disable mariadb
`

	- para criar uma imagem, parar a maquina `sudo shutdown -h now`


## security groups
- qdo é criada uma instancia, ela é isolada automaticamente de outras máquinas da rede
- Para comunicação direta entre as suas instancias (máquinas dentro desse grupo consegue se comunicar entre si)
	- default vpc sec group: rede dentro da aws. todos os protocolos p/ todas as portas estão permitidos.
- inbound: regras de acesso (entrante)	
	- acesso-remoto inbound rules MyIp (vai mudar sempre)
	- acesso-web: inbound: http, https, ipv4, ipv6
- acesso ssh a uma maquina: porta 22
  
- acesso web - permitir o acesso http (apache)

## Serviços

### elastic ip: ip fixo
- aloca-lo à uma instancia associando o ip disponível
- vc é tarifado qdo a instancia c/ o ip associado estiver parada
- vc pode ter + de 1 ip associado a uma mesma instancia: esses outros ips vão ser tarifados
- ip publico: só consegui conectar com http e nao c/ https

### ebs: elastic block store (discos) 
- precificação ocorre mesmo c/ a maquina parada
- free tier: 30gb (somatoria dos discos usados)

### RDS : SERVIÇO BD
- não esqueça de selecionar uma com template free- tier
- as instancias ec2 e rds estão na mesma vpc (rede)
- copiar o endpoint `database-1.cmblgshfej2r.us-east-2.rds.amazonaws.com`
- comunicação ec2-rds : incluir o sec group da maquina ec2 usada p/ conectar no ssh na rede default (mesma vpc do bd)
- ja conectado no ssh: `mysql -u admin -h database-1.cmblgshfej2r.us-east-2.rds.amazonaws.com -p`
- login: admin H8NJJaUJkKm9Qv3

### Load balancer
- vai receber todo o tráfego e distribuira p/ todas as instancias (replicas ESCALADAS automaticamente)

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





