#!/bin/bash

#Documentation
# This Bash Script is to automate nginx services.

#Defining the global variables

ENVIRONMENT_NAME='Nginx_production';
POSITIONAL_ARGUMENT=$1;
LOGIN_USER=$(whoami);
ERROR_HANDLER=$(echo $?);

# Access Control Logic

if [[ $LOGIN_USER == 'root' ]]; then
  printf 'You have access to execute the nginx-service script\n';

else
  printf "you are $LOGIN_USER user dont have the access to execute the script.Try login as root user\n";
    exit 1;
fi

# Function definitions

function start_nginx_service(){
  read -p "Welcome to nginx appserver!!! how can i help you with nginx services {start,status,stop,restart}" user_input;
if [[ $user_input == 'start' ]]; then
  system_output=$(sudo systemctl start nginx.service);
  printf "Nginx service started\n";

else 
  printf "Please enter a valid nginx service {start,status,stop,restart}";
  exit 1;
fi
}

function status_nginx_service(){
  read -p "Welcome to nginx appserver!!! how can i help you with nginx services {start,status,stop,restart}" user_input;
if [[ $user_input == 'status' ]]; then
  system_output=$(sudo systemctl status nginx.service);
  system_output2=$(systemctl status nginx.service | grep 'Active' | awk '{print $2}');
  printf "Nginx status is $system_output2\n";
else 
  printf "Please enter a valid nginx service {start,status,stop,restart}\n";
  exit 1; 
fi
}


# }

function stop_nginx_service(){
  read -p "Welcome to nginx appserver!!! how can i help you with nginx services {start,status,stop,restart}" user_input;
if [[ $user_input == 'stop' ]]; then
  system_output=$(sudo systemctl stop nginx.service);
  printf "Nginx service stopped\n";
else 
  printf "Please enter a valid nginx service {start,status,stop,restart}\n";
  exit 1; 
fi
}

function restart_nginx_service(){
  read -p "Welcome to nginx appserver!!! how can i help you with nginx services {start,status,stop,restart}" user_input;
if [[ $user_input == 'restart' ]]; then
  system_output=$(sudo systemctl restart nginx.service);
  printf "Nginx service stopped\n";
else 
  printf "Please enter a valid nginx service {start,status,stop,restart}\n";
  exit 1; 
fi
}


#calling function
case $POSITIONAL_ARGUMENT in
  start)
    start_nginx_service;
    ;;
  stop)
    stop_nginx_service;
    ;;
  restart)
    restart_nginx_service;
    ;;
  status)
    status_nginx_service;
    ;;
  *)
    printf 'execute the scrtipt : sudo ./nginx-service.sh start\n';
    ;;
esac