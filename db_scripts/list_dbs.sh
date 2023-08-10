#!/usr/bin/bash

list_databases() {
    if [[ -z  $(ls databases/) ]]
    then
       message.sh "There is no databases ... start by creating a new one"
        exit
    else
        databases=$(ls databases/)
        num_dbs=0
        for db in $databases
        do
            echo "$((num_dbs+1)). ${db}"
            num_dbs=$(($num_dbs+1))
        done
       message.sh "There are ${num_dbs} database(s)." "success"
        exit
    fi
}

if [[ -d  databases/ ]]
then
    if [[ ! -r  databases/ ]]
    then
       message.sh "The databases directory did not have read premision ... Do you want to add read permission?" "warn"
        select choice in "yes" "no"
        do
            case $choice in
                "yes")
                    chmod +r databases/
                   message.sh "Changed permission" "success"
                    list_databases
                ;;
                "no")
                   message.sh "Sorry but we are not able to change permission without your approval" "warn"
                   message.sh "Come back when you are ready to change permission"
                    exit
                ;;
                *) echo "Please enter a valid choice"
                ;;
            esac
        done
    else
        list_databases
    fi
else
   message.sh "There is no databases ... start by creating a new one"
    exit
fi