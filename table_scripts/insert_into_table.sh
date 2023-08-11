#!/bin/bash

# Insert Into Table Script
# This script allows you to insert rows into an existing table in the current database.
# You will be prompted to provide the values for each column in the table.
# The script will perform necessary validations before inserting the rows.

# Function to insert rows into a table
function insert_into_table {
    while true; do
        read -r -p "Enter the name of the table to insert into (Type 'exit' to return to the tables menu): " table_name

        # Check if the user wants to exit the program
        if [ "$table_name" = "exit" ]; then
            echo "Returning to the tables menu..."
            exit 0
        fi

        # Check if the table name is empty
        if [ -z "$table_name" ]; then
            echo "Error: Table name cannot be empty."
            continue
        fi

        # File path for the table
        table_file="databases/$db_name/$table_name.txt"

        # Check if the table file exists
        if [ ! -e "$table_file" ]; then
            echo "Error: Table '$table_name' does not exist in the database."
            continue
        fi

        # Read column names and data types from metadata file
        metadata_file="databases/$db_name/.$(echo "$table_name" | tr -d ' ' )_md.txt"
        if [ ! -e "$metadata_file" ]; then
            echo "Error: Metadata file for table '$table_name' not found."
            continue
        fi

        # Read column names and data types from metadata file
        IFS=',' read -r -a column_names <<< "$(awk -F':' '{print $1}' "$metadata_file")"
        IFS=',' read -r -a data_types <<< "$(awk -F':' '{print $2}' "$metadata_file")"

        # Prompt the user for insertion method
        read -r -p "Choose insertion method:
        1. Insert by columns
        2. Insert by rows
        Enter your choice: " insertion_method

        case "$insertion_method" in
            1)
                insert_by_columns
                ;;
            2)
                insert_by_rows
                ;;
            *)
                echo "Invalid choice. Please choose a valid insertion method."
                continue
                ;;
        esac

        break
    done
}

# Function to insert data by columns
function insert_by_columns {
    declare -A column_values

    # Prompt the user for column values
    for ((i = 0; i < ${#column_names[@]}; i++)); do
        while true; do
            read -r -p "Enter value for column '${column_names[i]}' (${data_types[i]}): " value
            case "${data_types[i]}" in
                "int")
                    if [[ "$value" =~ ^[0-9]+$ ]]; then
                        column_values["${column_names[i]}"]=$value
                        break
                    else
                        echo "Error: Invalid integer value."
                    fi
                    ;;
                "float")
                    if [[ "$value" =~ ^[0-9]*\.?[0-9]+$ ]]; then
                        column_values["${column_names[i]}"]=$value
                        break
                    else
                        echo "Error: Invalid float value."
                    fi
                    ;;
                "string")
                    column_values["${column_names[i]}"]=$value
                    break
                    ;;
                *)
                    echo "Error: Unsupported data type '${data_types[i]}' for column '${column_names[i]}'."
                    ;;
            esac
        done
    done

    # Construct the row to be inserted
    row=""
    for ((i = 0; i < ${#column_names[@]}; i++)); do
        row+="$(printf "%s" "${column_values[${column_names[i]}]}")"
        if [ $i -lt $(( ${#column_names[@]} - 1 )) ]; then
            row+=","
        fi
    done

    # Insert the row into the table file
    echo "$row" >> "$table_file"

    echo "Row inserted into table '$table_name'."
}

# Function to insert data by rows
function insert_by_rows {
    declare -A row_values

    # Prompt the user for row values
    for ((i = 0; i < ${#column_names[@]}; i++)); do
        while true; do
            read -r -p "Enter value for column '${column_names[i]}' (${data_types[i]}): " value
            case "${data_types[i]}" in
                "int")
                    if [[ "$value" =~ ^[0-9]+$ ]]; then
                        row_values["${column_names[i]}"]=$value
                        break
                    else
                        echo "Error: Invalid integer value."
                    fi
                    ;;
                "float")
                    if [[ "$value" =~ ^[0-9]*\.?[0-9]+$ ]]; then
                        row_values["${column_names[i]}"]=$value
                        break
                    else
                        echo "Error: Invalid float value."
                    fi
                    ;;
                "string")
                    row_values["${column_names[i]}"]=$value
                    break
                    ;;
                *)
                    echo "Error: Unsupported data type '${data_types[i]}' for column '${column_names[i]}'."
                    ;;
            esac
        done
    done

    # Construct the row to be inserted
    row=""
    for ((i = 0; i < ${#column_names[@]}; i++)); do
        row+="$(printf "%s" "${row_values[${column_names[i]}]}")"
        if [ $i -lt $(( ${#column_names[@]} - 1 )) ]; then
            row+=","
        fi
    done

    # Insert the row into the table file
    echo "$row" >> "$table_file"

    echo "Row inserted into table '$table_name'."
}

# Call the function to insert rows into a table
insert_into_table
