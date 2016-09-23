## Lets Encrypt Guide
This container includes support for lets encrypt SSL certificates. The scripts includes allow you to easily setup and renew your certificates. **Please note** your container must be a fully resolvable (by dns), Internet facing server to allow this to work.
### Setup		
You can use Lets Encrypt to secure your container. Make sure you start the container with the ```DOMAIN, GIT_EMAIL``` and ```WEBROOT``` variables set to enable this functionality. Then run:		
```		
sudo docker exec -t <CONTAINER_NAME> /usr/bin/letsencrypt-setup		
```		
Ensure your container is accessible on the ```DOMAIN``` you supplied in order for this to work		
### Renewal		
Lets Encrypt certs expire every 90 days, to renew simply run:		
```		
sudo docker exec -t <CONTAINER_NAME> /usr/bin/letsencrypt-renew		
```
