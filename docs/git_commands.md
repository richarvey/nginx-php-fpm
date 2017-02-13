## Git Commands
Specify the ```GIT_EMAIL``` and ```GIT_NAME``` variables for this to work. They are used to set up git correctly and allow the following commands to work.

### Push code to Git
To push code changes made within the container back to git run:
```
sudo docker exec -t -i <CONTAINER_NAME> /usr/bin/push
```
### Pull code from Git (Refresh)
In order to refresh the code in a container and pull newer code from git run:
```
sudo docker exec -t -i <CONTAINER_NAME> /usr/bin/pull
```
