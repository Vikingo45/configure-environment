# Getting Started

## Setting up the Sporta environment

> **Requirements**: A Linux server and a terminal emulator running Bash.  

> ### TL;DR
> This section explains in detail how to configure the development back and front ends of Sporta. If you are interested in manually doing this, you can read on. Otherwise, you can use ```sporta.sh``` to set up the environment. Refer to the ```Running the script``` section below for more details.  

The following instructions will walk you through setting up the back and front ends (from the development branches) of Sporta in a remote server. Start by connecting to the server through SSH (```ssh user@35.171.87.95```). Ask an administrator to set up a ```user``` in the server for you and make sure your public RSA key is saved in the server's ```authorized_keys``` file. Also, clone this repository in your account's home directory.  

First, let's start by setting up the back-end. In the server,  

```
mkdir ~/sporta
cd ./sporta
git clone git@bitbucket.org:clubsporta/sportabackend.git
cd ./sportabackend
git checkout development
cp ~/configure-environment/config-files/credentials.py ./src/sportsunited/settings
virtualenv env
source ./env/bin/activate
pip3 install -r ./src/requirements.txt
```

After this, you need to create a super user in the database. Run the script ```manage.py``` and use your email and ```sportaadmin``` as the username and password, respectively.  

```
python manage.py createsuperuser
```

At this point, we are ready to set up the front-end of the application. Do the following:  

```
cd ~/sporta
git clone git@bitbucket.org:clubsporta/sportafrontend.git
cd ./sportafrontend
git checkout develop
cp ~/configure-environment/config-files/config.js ./src
cp ~/configure-environment/config-files/dev.config.js ./webpack
cp ~/configure-environment/config-files/webpack-dev-server.js ./webpack
```

> **Warning**: Before proceeding, you must change a few lines in ```config.js```, ```dev.config.js```, and ```webpack-dev-server.js```. Choose a (unused) port for the application (9000, for instance) and replace 5000 in line 15 of ```config.js```. Also, choose a port for webpack (9001, for example) and replace 5001 in lines 9 and 10 in ```webpack-dev-server.js``` and ```dev.config.js```, respectively.  

Now, inside the ```sportafrontend``` directory, execute ```npm install```.  



## Running the script

Setting up the Sporta development environment can be done effortlessly by running ```sporta.sh```. However, there are two things you need to do before. First, change the ports used by the application and webpack. This can be done by changing variables ```port``` and ```wpport``` in the script file. Second, you have to copy ```sporta.sh``` into the server. You can do that with the secure copy command - with an account in the server named ```user```, you can do ```scp ./sporta.sh user@35.171.87.95:~``` in your local machine to copy the script into your account's home directory in the server. Note that you may need to add your public RSA key in the server's ```authorized_keys``` file before doing this -, or alternatively, you can also clone this repository. Then, in the server you can run the script (```~/.sporta.sh```).  



## Running the application

Running Sporta is a threefold procedure. You need to do each step in a separate tab/window of your preferred terminal emulator.  

1. For the back-end, SSH into the server (```ssh user@35.171.87.95```) and run ```cd ~/sporta/sportabackend/; source ./env/bin/activate; python ./src/manage.py runserver 0:8050```.  
2. For the front-end, SSH into the server and run ```cd ~/sporta/sportafrontend/; npm run dev```.  
3. In your local machine, run ```ssh -l $port:localhost:$port -l $wpport:localhost:$wpport -l 8050:localhost:8050 user@35.171.87.95 -n```. In this command note that you need to replace ```$port``` and ```$wpport``` for the port numbers you changed in the script.  

If everything went smoothly, you can now access the application through ```http://localhost/$port```. Don't forget to replace ```$port``` by the port number you specified in the script.  



## Accessing the database

When Sporta is running, you can access the database through ```http://localhost:8050/admin```.  