#!/bin/bash

# ANSI escape codes for colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
RESET='\033[0m'

message=$1

if [[ $2 == 'error' ]]
then
    echo -e "\n${RED}Error: ${message} ${RESET}\n"
elif [[ $2 == 'success' ]]
then
    echo -e "\n${GREEN}Success: ${message} ${RESET}\n"
elif [[ $2 == 'warn' ]]
then
    echo -e "\n${YELLOW}Warning: ${message} ${RESET}\n"
elif [[ $2 == '' ]]
then
    echo -e "\n${BLUE}${message} ${RESET}\n"
fi

