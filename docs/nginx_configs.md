## Custom Nginx Config files
Sometimes you need a custom config file for nginx to do rewrites or password protection, etc. For this reason we've included the ability to have custom nginx configs pulled directly from your git source. Please have a read of the [repo layout guidelines](repo_layout.md) for more information. Its pretty simple to enable this, all you need to do is include a folder in the root of your repository called ```conf/nginx/``` within this folder you need to include a file called ```nginx-site.conf``` which will contain your default nginx site config. If you wish to have a custom file for SSL you simply include a file called ```nginx-site-ssl.conf``` in the same directory. These files will then be swapped in after you code is cloned.

## REAL IP / X-Forwarded-For Headers
If you operate your container behind a load balancer, an ELB on AWS for example, you need to configure nginx to get the real IP and not the load balancer IP in the logs by using the X-Forwarded-For. We've provided some handy flags to let you do this. You need to set both of these to get this to work:
```
-e "REAL_IP_HEADER=1"
-e "REAL_IP_FROM=Your_CIDR"
```
For example:
```
docker run -d -e "REAL_IP_HEADER=1" -e "REAL_IP_FROM=10.1.0.0/16" richarvey/nginx-php-fpm:latest
```
