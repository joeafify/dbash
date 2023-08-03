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

    echo "Enter the name of the new database:"
    read db_name

    if [ -z "$db_name" ]; then
        echo "Database name cannot be empty."
        return
    fi

    if [ -d "databases/$db_name" ]; then
        echo "Database '$db_name' already exists."
        return
    fi

    mkdir "databases/$db_name"
    echo "Database '$db_name' created successfully in the 'databases' directory."
}

# Call the function to create a new database
create_database
