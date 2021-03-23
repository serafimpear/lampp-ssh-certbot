# Simple docker based on Ubuntu 20.04 with LAMPP and SSH&amp;SFTP
> Works with Ubuntu 20.04 LTS

#### This LAMPP stack contains:
* PHP 7.14.16
* Apache
* MariaDB (MySQL)
* Perl
* phpMyAdmin
## Installation:
1. Modify `Dockerfile` and change username and password for SSH
```dockerfile
ARG username=user
ARG userpaswd=1234
```
2. Build docker:
```
$ docker build -t serafimpear/lampp-ssh .
```
3. And run it:
```
$ docker run -d -p 2222:22 -p 8080:80 --name lampp-ssh serafimpear/lampp-ssh
```
4. Once all is ready, there schould be this at `http://localhost:8080/`:

![Result](https://github.com/serafimpear/lampp-ssh/blob/main/result.jpg?raw=true)

## SSH:
```
$ ssh -p 2222 user@localhost
```

## Web Server:
### Location
* The webserver is located at `/opt/lampp`
* Website files `/opt/lampp/htdocs`

### Start, restart & stop
```
$ sudo /opt/lampp/lampp start
$ sudo /opt/lampp/lampp restart
$ sudo /opt/lampp/lampp stop
```

### Configure:

#### Apache config
`/opt/lampp/etc/httpd.conf`

#### Virtual hosts
`/opt/lampp/etc/extra/httpd-vhosts.conf`

> More you can find at `http://localhost/dashboard/faq.html`
