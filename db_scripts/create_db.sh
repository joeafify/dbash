#!/bin/bash

# Function to create a new database
function create_database {
    # Check if the "databases" directory exists, and create it if it doesn't
    if [ ! -d "databases" ]; then
        echo "Warning: The 'databases' directory is missing."
        echo "Creating 'databases' directory..."
        mkdir "databases"
        echo "'databases' directory created successfully."
    fi

    while true; do
        read -r -p "Enter the name of the new database 
      Rules:
        (Avoid spaces and special characters except '-' or '_')
        (You can't start with a number or a hyphen/underscore)
        (You can't end with a hyphen or underscore)
        (Type 'exit' to exit the program)
        New Database name: " db_name

        # Check if the database name is empty
        if [ -z "$db_name" ]; then
            echo "Error: Database name cannot be empty."
            continue
        fi

               # Check if the database already exists
        if [ -d "databases/$db_name" ]; then
            echo "Error: Database '$db_name' already exists."
            continue
        fi

        # If all checks pass, create the new database directory
        if [ ! -d "databases" ]; then
            echo "Warning: The 'databases' directory is missing."
            echo "Creating 'databases' directory..."
            mkdir "databases"
            echo "'databases' directory created successfully."
        fi

        # Check if the user wants to exit the program
        if [ "$db_name" = "exit" ]; then
            echo "Exiting the program..."
            exit 0
        fi

        # Check if the database name starts with a number, hyphen, or underscore
        if [[ $db_name =~ ^[0-9_-] ]]; then
            echo "Error: Database name cannot start with a number, hyphen, or underscore."
            continue
        fi

        # Check if the database name ends with a hyphen or underscore
        if [[ $db_name =~ [_-]$ ]]; then
            echo "Error: Database name cannot end with a hyphen or underscore."
            continue
        fi

        # Check if the database name contains only allowed characters
        if [[ ! $db_name =~ ^[A-Za-z0-9_-]+$ ]]; then
            echo "Error: Invalid characters in the database name. Please follow the naming rules."
            echo "Allowed characters are: A-Z, a-z, 0-9, hyphen (-), underscore (_)."
            echo "Name cannot be just numbers, hyphens -, or underscores _."
            continue
        fi

        # Check if the database already exists
        if [ -d "databases/$db_name" ]; then
            echo "Error: Database '$db_name' already exists."
            continue
        fi

        # If all checks pass, create the new database directory
        if [ ! -d "databases" ]; then
            echo "Warning: The 'databases' directory is missing."
            echo "Creating 'databases' directory..."
            mkdir "databases"
            echo "'databases' directory created successfully."
        fi

        mkdir "databases/$db_name"
        echo "Database '$db_name' created successfully in the 'databases' directory."
        break
    done
 }

# Call the function to create a new database
create_database
