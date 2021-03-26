# Simple docker based on Ubuntu 20.04 with LAMPP, SSH &amp; SFTP
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
4. Once all is ready, there should be this at `http://localhost:8080/`:

![Result](https://github.com/serafimpear/lampp-ssh/blob/main/result.jpg?raw=true)

## SSH:
```
$ ssh -p 2222 user@localhost
```

# Web Server:
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

# HTTPS using certbot

### Configure Virtual hosts

Before generating a new cerificate, configure `httpd-vhosts.conf`:
```
<VirtualHost *:80>
    ServerAdmin admin@example.com
    DocumentRoot "/opt/lampp/htdocs/"
    ServerName example.com
    ServerAlias www.example.com
    ErrorLog "logs/example.com-error_log"
    CustomLog "logs/example.com-access_log" common
</VirtualHost>
```

### Certbot

If ready, run:
```
$ sudo certbot --apache-ctl /opt/lampp/bin/apachectl
```
Enter your email adress:
```
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Plugins selected: Authenticator apache, Installer apache
Enter email address (used for urgent renewal and security notices) (Enter 'c' to
cancel): admin@example.com
```
Agree with the [_Terms of Service_](https://letsencrypt.org/documents/LE-SA-v1.2-November-15-2017.pdf):
```
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Please read the Terms of Service at
https://letsencrypt.org/documents/LE-SA-v1.2-November-15-2017.pdf. You must
agree in order to register with the ACME server at
https://acme-v02.api.letsencrypt.org/directory
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(A)gree/(C)ancel: A
```
Enter to select all options:
```
Which names would you like to activate HTTPS for?
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
1: example.com
2: www.example.com
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Select the appropriate numbers separated by commas and/or spaces, or leave input
blank to select all options shown (Enter 'c' to cancel):
```
Certbot will ask you, whether or not to redirect HTTP traffic to HTTPS, I use redirect (2):
```
Please choose whether or not to redirect HTTP traffic to HTTPS, removing HTTP access.
-------------------------------------------------------------------------------
1: No redirect - Make no further changes to the webserver configuration.
2: Redirect - Make all requests redirect to secure HTTPS access. Choose this for
new sites, or if you're confident your site works on HTTPS. You can undo this
change by editing your web server's configuration.
-------------------------------------------------------------------------------
Select the appropriate number [1-2] then [enter] (press 'c' to cancel): 2
```
Done!
```
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Congratulations! You have successfully enabled https://example.com and
https://www.example.com

You should test your configuration at:
https://www.ssllabs.com/ssltest/analyze.html?d=example.com
https://www.ssllabs.com/ssltest/analyze.html?d=www.example.com
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
```
### Include new vhosts file

A new file has been created at `/opt/lampp/etc/extra/httpd-vhosts-le-ssl.conf`, you must include it to `httpd.conf`:

Manually:
```
...

Include etc/extra/httpd-vhosts-le-ssl.conf
```
Or by command
```
$ printf "\nInclude etc/extra/httpd-vhosts-le-ssl.conf\n" | sudo tee -a /opt/lampp/etc/httpd.conf
```
### Restart LAMPP
Now, restart `lampp`:
```
$ sudo /opt/lampp/lampp restart
```
Congratulations! You just enabled HTTPS on your website!
