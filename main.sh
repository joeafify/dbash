#!/usr/bin/bash
chmod u+x -R .
export PATH=$PATH:$(pwd):$(pwd)/shared_scripts/:$(pwd)/table_scripts/:$(pwd)/db_scripts/
echo "Welcome to 'DBash', Happy hacking!"
PS3="What do you want? (For example [press 1]): "
select choice in "Create new database" "List databases" "Connect to database" "Drop database" "Quit"
do
    case $choice in
        "Create new database")
            create_db.sh
        ;;
        "List databases")
            list_dbs.sh
        ;;
        "Connect to database")
            connect_to_db.sh
        ;;
        "Drop database")
            drop_db.sh
        ;;
        "Quit")
            echo "Bye!"
            exit
        ;;
        *) echo "Please enter a valid choice"
        ;;
    esac
done