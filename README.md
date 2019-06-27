# Buildout Plone
### Introdução

A configuração proposta foi destinada a aumentar o desempenho de um ambiente de produção para o Plone. Busca atingir os seguintes objetivos:
* O navegador Web do usuário deve armazenar a maior quantidade de informações em cache possível.  
* O servidor de cache (Varnish) deve otimizar o armazenamento das informações do backend.
* Automatizar a atualização do conteúdo em cache (Varnish).
* Balanceamento de carga entre as instâncias, para evitar sobrecarga.
* Acesso diferenciado para usuários autenticados e anônimos.
* Os serviços serão gerenciados (start|stop|restart) pelo Supervisor.

### Arquitetura porposta
<img src="https://github.com/fernandoans/buildout.plone/blob/master/docs/ArquiteturaPlone.png"/>

* **Nginx -  servidor web frontend**: interface de comunicação entre o usuário e o Plone.
* **Varnish - cache**: recebe as solicitações do Nginx e decidi se elas serão servidas a partir do cache ou para ser processadas pelas ZEO-Clients/ZEO-Server.
* **HAProxy - load-balancer**: distribui todos as solicitações que vêm do Varnish para cada ZEO-Client.
* **ZEO-Client 1-7/ZEO-Server**: receber as solicitações do HAProxy e processa as requisições utilizando o ZEO-Server. Existe uma divisão entre os clientes, o primeiro grupo (em verde) é reservado aos usuários autenticados do portal que farão as edições das informações, enquanto que o segundo (em azul) é o público externo que entra no portal para realizar uma consulta.

## Preparação do ambiente

**Observação:** Antes de tudo, instalar os pacotes do sistema operacional necessários para o Plone. [Instruções](http://developer.plone.org/getstarted/installation.html#id6)

Montar seu ambiente python utilizando o virtualenv com python 2.7.

Utilizar o pacote [buildout.python](http://github.com/collective/buildout.python) é possível a montagem do ambiente necessário para a criação do virtualenv.

## Ativando o virtualenv
```bash
$ source /path/to/env/bin/activate
```
## ZEO-Server
Preparar as configurações:
```bash
$ cd /path/to/zeo
$ vim settings.cfg

No arquivo, alterar as variáveis:

[blobstorage]
directory = /path/to/blobstorage

[tmp]
directory = /path/to/tmpPortal
```
Executar o buildout:
```bash
$ cd /path/to/zeo
$ python bootstrap.py
$ bin/buildout -v
```
## ZEO-Clients - Instances
Preparar as configurações:
```bash
$ cd /path/to/app
$ vim settings.cfg

No arquivo, alterar as variáveis:

[users]
effective-user = user/local/machine

[blobstorage]
directory = /path/to/blobstorage

[tmp]
directory = /path/to/tmpPortal
```
Executar o buildout:
```bash
$ cd /path/to/app
$ python bootstrap.py
$ bin/buildout -v
```

## Frontend
Preparar as configurações:
```bash
$ cd /path/to/frontend
$ vim settings.cfg

No arquivo, alterar as variáveis:

[users]
os = user/local/machine

[hostname]
portal = hostname/machine/instance

[varnish-purge-hosts]
hosts =
"hostname/machine/instance";

```
Executar o buildout:
```bash
$ cd /path/to/frontend
$ python bootstrap.py
$ bin/buildout -v
```

## Iniciar os serviços

### ZEO-Server
```bash
$ cd /path/to/zeo
$ ./bin/supervisord
$ ./bin/supervisorctl status
```

### ZEO-Clients
```bash
$ cd /path/to/app
$ ./bin/supervisord
$ ./bin/supervisorctl status
```
### Frontend
```bash
$ cd /path/to/frontend
$ ./bin/supervisord
$ ./bin/supervisorctl status
```

[HowTo - Setting Plone infrastructure using buildout](http://www.youtube.com/watch?v=nF_2xJyBsXU)

<a href="http://www.youtube.com/watch?feature=player_embedded&v=nF_2xJyBsXU
" target="_blank"><img src="http://img.youtube.com/vi/nF_2xJyBsXU/0.jpg" 
alt="HowTo - Setting Plone infrastructure using buildout"  border="10" /></a>

Powered:
<img src="https://raw.github.com/andreclimaco/buildout.plone/master/docs/andreclimaco.png" width="250"  />

Sponsored by: http://www.lucasaquino.com.br

Referências:
* http://nginx.org
* http://www.varnish-cache.org
* http://haproxy.1wt.eu
* http://plone.org
* http://www.zope.org
* http://www.asconix.com/howtos/plone-cms/high-performance-plone-setup-howto
* http://github.com/collective/buildout.python
* http://github.com/intranett/intranett
* http://github.com/sebasgo/sbo-dresden.de
