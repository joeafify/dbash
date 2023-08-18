#!/bin/bash

select_table_name(){
    read -r -p "Select table name: " table_name
    if [ ! -f ${table_name} ]; then
        message.sh "Table does not exist" "error"
        select_table_name
    fi
}

get_condition_column(){
    message.sh "Select your prefered condition:\n" "blue"
    while true
    do
        read -r -p "Enter column name: " column_name
        if [ -z column_name ]
        then
            continue
        else
            break
        fi
    done
    while true
    do
        read -r -p "Enter value for '${column_name}': " column_value
        if [ -z column_value ]
        then
            continue
        else
            break
        fi
    done
}
select_table_name
get_condition_column

read -r metadata_line < "$table_name"
IFS=',' read -ra metadata_columns <<< "$metadata_line"

condition_col_num=0
for i in "${!metadata_columns[@]}"; do
    if [ "${metadata_columns[i]}" = "$column_name" ]; then
        condition_col_num=$((i + 1))
        break
    fi
done

if [ "$condition_col_num" -eq 0 ]; then
    message.sh "Condition column  '$column_name' not found" "error"
fi

temp_file=$(mktemp)
count=0
while IFS= read -r data_line; do
    IFS=',' read -ra data_values <<< "$data_line"
    if [ ! "${data_values[condition_col_num - 1]}" = "$column_value" ]; then
        echo $(IFS=','; echo "${data_values[*]}") >> "${temp_file}"
    else
        count=$((count+1))
    fi

done < "${table_name}"
mv "${temp_file}" "${table_name}"
message.sh "(${count}) rows deleted" "success"