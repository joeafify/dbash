#!/usr/bin/bash

# ANSI escape codes for colors
BG_RED='\033[41m'
BG_GREEN='\033[42m'
BG_YELLOW='\033[43m'
BG_BLUE='\033[44m'
FG_RED='\033[0;31m'
FG_GREEN='\033[0;32m'
FG_YELLOW='\033[1;33m'
FG_BLUE='\033[1;34m'
RESET='\033[0m'

message=$1

if [[ $2 == 'error' ]]
then
    echo -e "${BG_RED}Error: ${message}${RESET}"
elif [[ $2 == 'success' ]]
then
    echo -e "${BG_GREEN}Success: ${message}${RESET}"
elif [[ $2 == 'warn' ]]
then
    echo -e "${BG_YELLOW}Warning: ${message}${RESET}"
elif [[ $2 == '' ]]
then
    echo -e "${BG_BLUE}${message}${RESET}"
if [[ $2 == 'red' ]]
then
    echo -e "${FG_RED}${message}${RESET}"
elif [[ $2 == 'green' ]]
then
    echo -e "${FG_GREEN}${message}${RESET}"
elif [[ $2 == 'yellow' ]]
then
    echo -e "${FG_YELLOW}${message}${RESET}"
elif [[ $2 == 'blue' ]]
then
    echo -e "${FG_BLUE}${message}${RESET}"    
fi

