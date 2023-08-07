#!/usr/bin/bash

# ANSI escape codes for colors
RED='\033[41m'
GREEN='\033[42m'
YELLOW='\033[43m'
BLUE='\033[44m'
RESET='\033[0m'

message=$1

if [[ $2 == 'error' ]]
then
    echo -e "${RED}Error: ${message}${RESET}"
elif [[ $2 == 'success' ]]
then
    echo -e "${GREEN}Success: ${message}${RESET}"
elif [[ $2 == 'warn' ]]
then
    echo -e "${YELLOW}Warning: ${message}${RESET}"
elif [[ $2 == '' ]]
then
    echo -e "${BLUE}${message}${RESET}"
fi

