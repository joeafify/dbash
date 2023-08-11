#!/bin/bash

# Drop Table Script
# This script allows you to drop an existing table from the current database.
# You will be prompted to provide the name of the table to be dropped.
# The script will perform necessary validations before dropping the table.

# Function to drop a table
function drop_table {
    while true; do
        read -r -p "Enter the name of the table to drop (Type 'exit' to return to the tables menu): " table_name

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

        # Prompt the user for confirmation
        read -r -p "Are you sure you want to drop the table '$table_name'? (y/n): " confirmation
        if [ "$confirmation" != "y" ]; then
            echo "Table '$table_name' was not dropped."
            continue
        fi

        # Remove the table file
        rm -f "$table_file"

        # Remove the metadata file
        metadata_file="databases/$db_name/.$(echo "$table_name" | tr -d ' ' )_md.txt"
        rm -f "$metadata_file"

        echo "Table '$table_name' has been dropped from the database."
        break
    done
}

# Call the function to drop a table
drop_table
