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
        read -p "Enter the name of the new database (Avoid spaces and special characters except '_' or '-'): " db_name

        if [[ ! $db_name =~ ^[0-9] && ! $db_name =~ ^[^A-Za-z0-9_-] && ! $db_name =~ [\ ] ]]; then
            if [ -z "$db_name" ]; then
                echo "Database name cannot be empty."
            else
                if [ -d "databases/$db_name" ]; then
                    echo "Database '$db_name' already exists."
                else
                    mkdir "databases/$db_name"
                    echo "Database '$db_name' created successfully in the 'databases' directory."
                    break
                fi
            fi
        else
            echo "Invalid database name. Please follow the naming rules."
        fi
    done
}

# Call the function to create a new database
create_database
