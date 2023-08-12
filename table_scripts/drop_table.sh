#!/bin/bash

# Drop Table Script
# This script allows you to drop an existing table from the current database.
# You will be prompted to provide the name of the table to be dropped.
# The script will perform necessary validations before dropping the table.

# Function to drop a table
function drop_table {
    # Get the list of tables in the current database
    available_tables=$(ls | grep -E '^[^.]+$')
    
    # Check if there are tables available to drop
    if [ -z "$available_tables" ]; then
        echo "There are no tables in the database to drop."
        return
    fi

    while true; do
        echo "Available tables in the database: 
$available_tables"
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

        # Check if the table exists
        if ! [[ $available_tables =~ (^|[[:space:]])$table_name($|[[:space:]]) ]]; then
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
        rm -f $table_name

        # Remove the metadata file
        rm -f ".$table_name"_md
        echo "Table '$table_name' has been dropped from the database."
        break
    done
}

# Call the function to drop a table
drop_table
