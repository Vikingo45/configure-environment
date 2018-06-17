# Notes

## Secure Shell

You can SSH into the server and mount the development directory into your local machine by running the following two commands.  

```
ssh victor@35.171.87.95
sshfs victor@35.171.87.95:/home/victor/sporta ~/Desktop/temp
```

## Location of config files

This is the location of the configuration files.  

>credentials.py        ---> sportabackend/src/sportsunited/settings/credentials.py  
>config.js             ---> sportafrontend/src/config.js  
>dev.config.js         ---> sportafrontend/webpack/dev.config.js  
>webpack-dev-server.js ---> sportafrontend/webpack/webpack-dev-server.js  
