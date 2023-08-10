#!/usr/bin/bash
list_tables() {
    if [[ -z  $(ls) ]]
    then
        message.sh "There is no tables ... start by creating a new one"
        exit
    else
        tables=$(ls)
        num_tbs=0
        for tb in $tables
        do
            echo "$((num_tbs+1)). ${tb}"
            num_tbs=$(($num_tbs+1))
        done
        message.sh "There are ${num_tbs} table(s)." "success"
        exit
    fi
}


if [[ ! -r  $(pwd) ]]
then
    message.sh "The '${connected_db}' directory did not have read premision ... Do you want to add read permission?" "warn"
    select choice in "yes" "no"
    do
        case $choice in
            "yes")
                chmod +r $(pwd)
                message.sh "Changed permission" "success"
                list_tables
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
    list_tables
fi
