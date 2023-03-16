#!/bin/bash


##
# This bash script to show system memory and system metric,system load. This script 
# can be integrated with observability stack like nagios and promethius.
##

#printf "Filename: $0\n";
#printf "Argument 1: $1\n";

ENVIRONMENT_NAME="production"; #static variable
METRIC_TYPE=$1;#  Dynamic variable getting value from positional argument.
SYSTEM_USER=$(whoami); # Dynamic variable getting value from output of a program.

#printf "this environment is: $ENVIRONMENT_NAME\n";
#printf "metric type=$METRIC_TYPE\n";
#printf "who is the user executing script systemuser=$SYSTEM_USER\n";

#ACCess control logic
if [[ $SYSTEM_USER == 'root' ]]; then
  printf "you are exectuing as $SYSTEM_USER  user.\n";
  printf "You are allowed to run this script.\n";
else
  printf "You are executing as $SYSTEM_USER user.\n";
  printf "You are denied to run this script.\n";
  exit 1;
fi

#printf "You are here..\n";

# function definition to calculate system load

function cal_system_load(){
  printf  "calculating system load.\n";
  read -p "please specify the time for load average on the system {last 1min, 5min, and 15min}:" user_input;
  if [[ $user_input == '1min' ]]; then
    sys_output=$(uptime | awk '{print $7}' | sed 's/,//');
  elif [[ $user_input == '5min' ]]; then
    sys_output=$(uptime | awk '{print $8}' | sed 's/,//');
  elif [[ $user_input == '15min' ]]; then
    sys_output=$(uptime | awk '{print $9}' | sed 's/,//');
  else
     printf "OOPS! Invalid input.\n";
     exit 1;
  fi

     printf "The system load for last $user_input is $sys_output .\n"

}

# function definition to calculate system memory

function cal_system_memory(){
  printf  "calculating system memory.\n";
  read -p "which memory u want to calculate {used|free|total|swap}:" user_input;

  #printf  "$type\n"

  if [[ $user_input == 'total' ]]; then
    sys_output=$(free -m | grep 'Mem' | awk '{print $2}');
  elif [[ $user_input == 'used' ]]; then
    sys_output=$(free -m | grep 'Mem' | awk '{print $3}');
  elif [[ $user_input == 'free' ]]; then
    sys_output=$(free -m | grep 'Mem' | awk '{print $4}');
  elif [[ $user_input == 'swap' ]]; then
    sys_output=$(free -m | grep 'Swap' | awk '{print $2}');
  else
    printf "OOPS! Invalid input.\n";
    exit 1;
  fi
    printf " The $user_input memory is $sys_output MB\n"
}

# function definition to calculate system storage
function cal_system_storage(){
  printf  "calculating system storage.\n";
  read -p "Please select storage from the options {total, used, and free}" user_input;

  case $user_input in
    total)
    sys_output=$(df -Th | grep '/dev/sda1' |  awk '{print $3}' | sed 's/G//');
      ;;
    used)
    sys_output=$(df -Th | grep '/dev/sda1' |  awk '{print $4}' | sed 's/G//');
      ;;
    free)
    sys_output=$(df -Th | grep '/dev/sda1' |  awk '{print $5}' | sed 's/G//');
      ;;
    *)
    printf "OOPS! Invalid input.\n";
    exit 1;
  esac
    printf "The $user_input storage is $sys_output Gb\n"
}

# calling system load fucntion
#cal_system_load;
# calling system memory fucntion
#cal_system_memory;
# calling system storage fucntion
#cal_system_storage;

#trigger proper fumction based on positonal argument

case $METRIC_TYPE in
  load)
    printf 'calling system load based on position argument\n';
    cal_system_load;
    ;;
  memory)
    printf 'calling system memory based on position argument\n';
    cal_system_memory;
    ;; 
  storage)
    printf 'calling system storage based on position argument\n';
    cal_system_storage;
    ;; 
  *)
    printf 'execute the scrtipt : sudo ./system-metric-new.sh memory/load/storage\n';
    ;;
esac



# # Defining an array variable.
# Param[0]='memory';
# Param[1]='load';
# Param[2]='storage';

# printf "${Param[0]}\n";
# printf "${Param[1]}\n";
# printf "${Param[2]}\n";
# John Sundarraj2:05 PM
# for (( i = 0; i < 2; i++ )); do
#   printf "${Param[i]}\n";
# done

# for i in ${Param[*]}; do
#   printf "${Param[i]}\n";
# done

# # Iterative looping of an array populated by CLI arguments.
# for i in $*; do
#   printf "$i\n";
# done