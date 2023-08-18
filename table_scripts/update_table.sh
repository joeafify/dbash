#!/bin/bash

select_table_name(){
    read -r -p "Select table name: " table_name 
    if [ ! -f ${table_name} ]; then
    message.sh "Table does not exist" "error"
    select_table_name
    fi
}
get_update_column(){
  message.sh "What do you want to update:\n" "blue"
  while true
  do
    read -r -p "Enter column name: " update_column
        if [ -z update_column ]
        then
          continue
        else
          break  
        fi
  done
  while true
  do
    read -r -p "Enter value for '${update_column}': " updated_value
        if [ -z updated_value ]
        then
          continue
        else
          break  
        fi
  done
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
get_update_column
get_condition_column

# Read metadata file and extract column names
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

# Build the update command
update_command=""
for arg in "${update_column}=${update_value}"; do
    IFS='=' read -ra update_parts <<< "$arg"
    update_column="${update_parts[0]}"
    update_value="${update_parts[1]}"
    found=false

    # Find the column number of the update column
    for i in "${!metadata_columns[@]}"; do
        if [ "${metadata_columns[i]}" = "$update_column" ]; then
            col_num=$((i + 1))
            found=true
            break
        fi
    done

    if ! "$found"; then
        message.sh "Update column '$update_column' not found" "error"
    fi

    # Append the update command
    if [ -n "$update_command" ]; then
        update_command+=","  # Add a comma separator if needed
    fi
    update_command+="${col_num}=${update_value}"
done

temp_file=$(mktemp)
while IFS= read -r data_line; do
    IFS=',' read -ra data_values <<< "$data_line"
    if [ "${data_values[condition_col_num - 1]}" = "$column_value" ]; then
        # Perform the update for the matching row
        IFS=',' read -ra update_parts <<< "$update_command"
        for part in "${update_parts[@]}"; do
            IFS='=' read -ra update_info <<< "$part"
            update_col_num="${update_info[0]}"
            update_col_value="${update_info[1]}"
            data_values[update_col_num - 1]="$updated_value"
        done
    fi
    echo $(IFS=','; echo "${data_values[*]}") >> "${temp_file}"

done < "${table_name}"
mv "${temp_file}" "${table_name}"