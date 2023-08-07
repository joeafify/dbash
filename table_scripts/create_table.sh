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

            # Check the user's response
        if [ "$permission_response" = "y" ]; then
            chmod +rw "databases/$db_name"
            echo "Permissions granted to the 'databases/$db_name' directory."
        else
            echo "Warning: Without the necessary permissions, we cannot continue, returning to the table menu...."
            exit 0
        fi

        # Create the table file in the databases/$db_name directory
        touch "databases/$db_name/$table_name.txt"

        # Set permissions for the file (table_name.txt)
        chmod 644 "databases/$db_name/$table_name.txt"

        # Inform the user that the table is created successfully
        echo "Table '$table_name' created successfully in the 'databases/$db_name' directory."

        # Prompt the user to specify column names and data types
        echo "Please specify the column names and data types for the table."

        read -r -p "Please specify the column names and data types for the table (e.g., column_1_name:i, column_2_name:s, column_3_name:d): " column_data_input

        # Convert user input to uppercase and remove spaces
        column_data_input=$(echo "$column_data_input" | tr '[:upper:]' '[:lower:]' | tr -d ' ')

        # Split the input into an array
        IFS=',' read -r -a columns_and_types <<< "$column_data_input"

        # Store column names and data types in separate arrays
        declare -a column_names
        declare -a data_types

for column_and_type in "${columns_and_types[@]}"; do
    # Extract column name and data type from input
    column_name=$(echo "$column_and_type" | cut -d ":" -f 1)
    data_type=$(echo "$column_and_type" | cut -d ":" -f 2)

    # Validate data type shortcuts
    case "$data_type" in
        i) data_type="int" ;;
        l) data_type="long" ;;
        d) data_type="double" ;;
        s) data_type="string" ;;
        b) data_type="boolean" ;;
        *) echo "Error: Invalid data type shortcut '$data_type'." ; exit 1 ;;
    esac

    # Add column name and data type to respective arrays
    column_names+=("$column_name")
    data_types+=("$data_type")
done

# Prompt for the primary key column
echo "Please choose the primary key column from the list below:"
for i in "${!column_names[@]}"; do
    echo "$((i+1)): ${column_names[i]}"
done

while true; do
    read -r -p "Enter the number or name of the primary key column (Type 'exit' to delete the table and return to the main menu): " primary_key_input

    # Check if the user wants to exit and delete the table
    if [ "$primary_key_input" = "exit" ]; then
        echo "Deleting the table and returning to the main menu..."
        # Remove the table file if it exists
        rm -f "$table_file"
        exit 0
    fi

    # Check if the input is a valid column number
    if [[ $primary_key_input =~ ^[0-9]+$ && $primary_key_input -ge 1 && $primary_key_input -le ${#column_names[@]} ]]; then
        # Subtract 1 from the input to get the index in the arrays
        primary_key_index=$((primary_key_input-1))
        break
    elif [[ " ${column_names[@]} " =~ " $primary_key_input " ]]; then
        # Check if the input is a valid column name
        primary_key_index=$(echo "${column_names[@]}" | tr ' ' '\n' | grep -n "^$primary_key_input$" | cut -d ":" -f 1)
        break
    else
        echo "Error: Invalid input. Please choose a valid column number or name."
    fi


        break
    done

    
# Get the selected primary key column and data type
primary_key_column=${column_names[primary_key_index]}
primary_key_data_type=${data_types[primary_key_index]}


}

# Call the function to create a new table
create_table