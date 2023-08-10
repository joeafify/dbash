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