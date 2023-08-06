#!/usr/bin/bash

connect_to_database() {
    read -p "Enter the name of the database: " db_name
    if [ -z "$db_name" ]; then
        message.sh "Database name cannot be empty" "warn"
        return
    fi
    if [ ! -d "databases/$db_name" ]; then
        message.sh "Database '${db_name}' not exists." "warn"
        return
    fi
    cd "databases/$db_name"
    export connected_db=$db_name
    menu_table.sh
}

if [[ -d  databases/ ]]
then
    if [[ ! -x  databases/ ]]
    then
        message.sh "The databases directory did not have execute premision ... Do you want to add execute permission?" "warn"
        select choice in "yes" "no"
        do
            case $choice in
                "yes")
                    chmod +x databases/
                    message.sh "Changied permission" "success"
                    connect_to_database
                ;;
                "no")
                    message.sh "Sorry but we are not able to change permission without your approval\nCome back when you are ready to change permission" "warn"
                    exit
                ;;
                *) echo "Please enter a valid choise"
                ;;
            esac
        done
    else
        connect_to_database
    fi
else
    message.sh "There is no databases ... start by creating a new one"
    exit
fi