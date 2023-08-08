#!/usr/bin/bash
clear
chmod u+x -R .
export PATH=$PATH:$(pwd):$(pwd)/shared_scripts/:$(pwd)/table_scripts/:$(pwd)/db_scripts/
echo "Welcome to 'DBash', Happy hacking!"
PS3="What do you want? (For example [press 1]): "
select choice in "Create new database" "List databases" "Connect to database" "Drop database" "Quit"
do
    if [[ $REPLY =~ ^[\\]$ ]]
    then
        echo "Invalid choice. '\\' is not allowed."
    fi
    case $REPLY in
        1)
            create_db.sh
        ;;
        2)
            list_dbs.sh
        ;;
        3)
            connect_to_db.sh
        ;;
        4)
            drop_db.sh
        ;;
        5)
            echo "Bye!"
            exit
        ;;
        *) echo "Please enter a valid choice"
        ;;
    esac
done