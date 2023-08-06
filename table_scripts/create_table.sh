#!/bin/bash

# Create Table Script
# This script allows you to create a new table in the current database.
# You will be prompted to provide the table name and its columns with data types.
# The script will perform necessary validations to ensure the table is created correctly.

#!/bin/bash

# Function to create a new table
function create_table {
    while true; do
        read -r -p "Enter the name of the new table 
      Rules:
        (Avoid spaces and special characters except '-' or '_')
        (You can't start with a number or a hyphen/underscore)
        (You can't end with a hyphen or underscore)
        (Type 'exit' to return to tables menu)
        New table name: " create_table

        # Check if the table name is empty
        if [ -z "$table_name" ]; then
            echo "Error: Table name cannot be empty."
            continue
        fi

           
            # File path for the table
        table_file="databases/$db_name/$table_name"

            # Check if the table file already exists
        if [ -e "$table_file" ]; then
            echo "Error: Table '$table_name' already exists."
            continue
        fi


           # Check if the user wants to exit the program
        if [ "$table_name" = "exit" ]; then
            echo "returning to table menu..."
            exit 0
        fi

        # Check if the table name starts with a number, hyphen, or underscore
        if [[ $table_name =~ ^[0-9_-] ]]; then
            echo "Error: Table name cannot start with a number, hyphen, or underscore."
            continue
        fi

        # Check if the table name ends with a hyphen or underscore
        if [[ $table_name =~ [_-]$ ]]; then
            echo "Error: Table name cannot end with a hyphen or underscore."
            continue
        fi

        # Check if the table name contains only allowed characters
        if [[ ! $table_name =~ ^[A-Za-z0-9_-]+$ ]]; then
            echo "Error: Invalid characters in the table name. Please follow the naming rules."
            echo "Allowed characters are: A-Z, a-z, 0-9, hyphen (-), underscore (_)."
            echo "Name cannot be just numbers, hyphens -, or underscores _."
            continue
        fi

        # File path for the table
        table_file="databases/$db_name/$table_name.table"

        # Check if the table file already exists
        if [ -e "$table_file" ]; then
            echo "Error: Table file '$table_file' already exists."
            continue
        fi

                # Check if the directory is readable and writable
        if [ ! -r "databases/$db_name" ] || [ ! -w "databases/$db_name" ]; then
            echo "Warning: The 'databases/$db_name' directory doesn't have the read/write permisstions."
        fi

        # Prompt the user if they want to grant the needed permissions
        read -p "Do you want to grant the necessary permissions to the directory? (y/n): " permission_response

        # Convert the user's response to lowercase for case-insensitive comparison
        permission_response="${permission_response,,}"


        # Create the table file in the databases/$db_name directory
        touch "databases/$db_name/$table_name.txt"

        # Set permissions for the directory (databases/$db_name) and the file (table_name.txt)
        chmod 755 "databases/$db_name"
        chmod 644 "databases/$db_name/$table_name.txt"

        # Inform the user that the table is created successfully
        echo "Table '$table_name' created successfully in the 'databases/$db_name' directory."

        # Prompt the user to specify column names and data types
        echo "Please specify the column names and data types for the table."
        # (You can use a loop to repeatedly ask for column names and data types)
        # ...

        # Prompt the user to specify the primary key column
        read -r -p "Please specify the primary key column for the table: " primary_key_column

        # Check if the primary key column is empty
        if [ -z "$primary_key_column" ]; then
            echo "Error: You must specify a primary key column for the table. The table will not be created."
            # Delete the table file as no primary key is provided
            rm "databases/$db_name/$table_name.txt"
        else
            # Implementation of code to create the table here with the specified primary key
            # ...
            echo "Table '$table_name' with primary key '$primary_key_column' created successfully."
        fi
        break
    done
}

# Call the function to create a new table
create_table
