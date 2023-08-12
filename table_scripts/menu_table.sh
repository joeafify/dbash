#!/usr/bin/bash
clear
PS3="(${connected_db})> "
select choice in "Create new table" "List tables" "Drop table" "Insert into table" "Select From Table" "Delete From Table" "Update Table" "Go back" "Quit"
do
    case $REPLY in
        1)
            create_table.sh
        ;;
        2)
            list_tables.sh
        ;;
        3)
            drop_table.sh
        ;;
        4)
            insert_into_table2.sh
        ;;
        5)
            exit
        ;;
        6)
            delete_form_table.sh
        ;;
        7)
            exit
        ;;
        8)
            exit
        ;;
        9)
            clear
            echo "Bye!"
            pkill -SIGTERM main.sh
        ;;
        *) echo "Please enter a valid choice"
        ;;
    esac
done