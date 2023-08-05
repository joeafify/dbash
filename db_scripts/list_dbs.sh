#!/usr/bin/bash

list_databases() {
    if [[ -z  $(ls databases/) ]]
    then
        bash shared_scripts/message.sh "There is no databases ... start by creating a new one"
        exit
    else
        databases=$(ls databases/)
        num_dbs=0
        for db in $databases
        do
            echo "$((num_dbs+1)). ${db}"
            num_dbs=$(($num_dbs+1))
        done
        bash shared_scripts/message.sh "There are ${num_dbs} database(s)." "success"
        exit
    fi
}

if [[ -d  databases/ ]]
then
    if [[ ! -r  databases/ ]]
    then
        bash shared_scripts/message.sh "The databases directory did not have read premision ... Do you want to add read permission?" "warn"
        select choice in "yes" "no"
        do
            case $choice in
                "yes")
                    chmod +r databases/
                    bash shared_scripts/message.sh "Changed permission" "success"
                    list_databases
                ;;
                "no")
                    bash shared_scripts/message.sh "Sorry but we are not able to change permission without your approval" "warn"
                    bash shared_scripts/message.sh "Come back when you are ready to change permission"
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
    bash shared_scripts/message.sh "There is no databases ... start by creating a new one"
    exit
fi