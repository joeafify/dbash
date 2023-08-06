#!/usr/bin/bash
echo "\
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~    Welcome to 'DBash Database Manager'    ~~~~~~~~~
~~~~~~~~~~~~~    Empowering Your Data Journey!    ~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~     Developed by:     ~~~~~~~~~~~~~~~~~~~
~~~~~  Mostafa Mohamed Eid    &   Youssef Mohamed Afify  ~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"

PS3="What do you want? (For example [press 1]): "
select choice in "Create new database" "List databases" "Connect to database" "Drop database" "Quit"
do
    case $choice in
        "Create new database")
            bash ./db_scripts/create_db.sh
        ;;
        "List databases")
            bash ./db_scripts/list_dbs.sh
        ;;
        "Connect to database")
            bash ./db_scripts/connect_to_db.sh
        ;;
        "Drop database")
            bash ./db_scripts/drop_db.sh
        ;;
        "Quit")
            echo "Bye!"
            exit
        ;;
        *) echo "Please enter a valid choice"
        ;;
    esac
done