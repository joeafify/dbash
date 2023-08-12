#!/bin/bash

# Create Table Script
# This script allows you to create a new table in the current database.
# You will be prompted to provide the table name and its columns with data types.
# The script will perform necessary validations to ensure the table is created correctly.
# The script will perform necessary validations to ensure the database has encessary permissions. 



# Function to create a new table
function create_table {
    while true; do
        read -r -p "Enter the name of the new table 
      Rules:
        (Avoid spaces and special characters except '-' or '_')
        (You can't start with a number or a hyphen/underscore)
        (You can't end with a hyphen or underscore)
        (Type 'exit' to return to the tables menu)
        New table name: " table_name

        # Check if the table name is empty
        if [ -z "$table_name" ]; then
            echo "Error: Table name cannot be empty."
            continue
        fi

        # Check if the table file already exists
        if [ -e "$table_name" ]; then
            echo "Table file '$table_name' already exists."
            echo "Aborting table creation."
        # Ask the user if they want to view the contents of the existing table
            read -r -p "Do you want to view the contents of this table? (y/n): " view_contents_response
        # Check the user's response
            if [ "$view_contents_response" = "y" ]; then
                echo "Displaying contents of table '$table_name'..."
                cat "$table_name"
            else
            continue   
            fi
            continue
        fi


                # Check if the table file already exists and ask to overwrite
#         if [ -e "$table_name" ]; then
#            read -r -p "Table file '$table_name' already exists. Do you want to overwrite it? (y/n): " overwrite_response
#            if [[ "$overwrite_response" != "y" ]]; then
#                echo "Aborting table creation."
#                continue
#            fi
#        fi


        # Check if the table file already exists
        if [ -e "$table_name" ]; then
            echo "Error: Table '$table_name' already exists."
            continue
        fi

        # Check if the user wants to exit the program
        if [ "$table_name" = "exit" ]; then
            echo "Returning to the tables menu..."
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


        chmod +w $(pwd)

        # Check if the directory is  writable
#        if [ ! -w "$db_name" ]; then
#            echo "Warning: The '$db_name' database doesn't have write permissions."
#            # Prompt the user if they want to grant the needed permissions
#            read -p "Do you want to grant the necessary permission to the database? (y/n): " permission_response
#            if [[ "$permission_response" != "y" && "$permission_response" != "Y" ]]; then
#                echo "Warning: Without the necessary permissions, we cannot continue. Returning to the tables menu..."
#                exit 0
#            else
#                chmod +w "$db_name"
#                echo "Permissions granted to the '$db_name' database."
#            fi
#        fi

            # Validate and store column names and data types
            declare -a column_names
            declare -a data_types
        
       # Function to prompt the user for column names and data types
    function prompt_column_data {
        while true; do
            read -r -p "Please specify the column names and data types for the table (e.g., column_1_name:i, column_2_name:f, column_3_name:s):
        Valid data type shortcuts: i (int), f (float), s (string)            note: don't use brackets
        Enter here: " column_data_input

            # Convert user input to lowercase and remove spaces
            column_data_input=$(echo "$column_data_input" | tr '[:upper:]' '[:lower:]' | tr -d ' ')

            # Split the input into an array
            IFS=',' read -r -a columns_and_types <<< "$column_data_input"

            # Define an associative array to map data type shortcuts to full data type names
            declare -A data_type_map
            data_type_map["i"]="int"
            data_type_map["f"]="float"
            data_type_map["s"]="string"

        for column_and_type in "${columns_and_types[@]}"; do
            # Extract column name and data type from input
            column_name=$(echo "$column_and_type" | cut -d ":" -f 1)
            data_type_shortcut=$(echo "$column_and_type" | cut -d ":" -f 2)

            # Map the data type shortcut to its full data type name
            data_type="${data_type_map[$data_type_shortcut]}"

            # Check if the data type is valid
            if [ -z "$data_type" ]; then
                echo "Error: Invalid data type shortcut '$data_type_shortcut'."
                echo "Valid data type shortcuts: i (int), f (float), s (string)"
            else
                # Valid data type, add column name and data type to respective arrays
                column_names+=("$column_name")
                data_types+=("$data_type")
            fi
        done

        # Check if all inputs were valid, if so, exit the loop
        if [ "${#columns_and_types[@]}" -eq "${#column_names[@]}" ]; then
            break
        else
            echo "Invalid input. Please provide the correct format for each column (e.g., column_name:data_type)."
        fi
    done

            # Display the column names and their mapped data types to the user
            echo "You've entered the following columns and their data types:"
            for ((i = 0; i < ${#column_names[@]}; i++)); do
                echo "$((i+1)): Column ${column_names[i]}: ${data_types[i]}"
            done
        }

        # Call the prompt_column_data function
        prompt_column_data


            # Prompt for the primary key column
        echo "Please choose the primary key column from the list above:"

        while true; do
            read -r -p "Enter the number or name of the primary key column (Type 'exit' to delete the table and return to the main menu): " primary_key_input

            # Check if the user wants to exit and delete the table
            if [ "$primary_key_input" = "exit" ]; then
                echo "Deleting the table and returning to the main menu..."
                # Remove the table file if it exists
                rm -f "$table_name"
                exit 0
            fi

    # Check if the input is a valid column number
    if [[ $primary_key_input =~ ^[0-9]+$ ]]; then
        if [ "$primary_key_input" -ge 1 ] && [ "$primary_key_input" -le ${#column_names[@]} ]; then
            # Subtract 1 from the input to get the index in the arrays
            primary_key_index=$((primary_key_input-1))
            break
        fi
    fi

    # Check if the input is a valid column name
    if [[ "${column_names[@]}" =~ "$primary_key_input" ]]; then
        primary_key_index=-1
        for i in "${!column_names[@]}"; do
            if [ "${column_names[i]}" = "$primary_key_input" ]; then
                primary_key_index=$i
                break
            fi
        done
        if [ "$primary_key_index" -ge 0 ]; then
            break
        fi
    fi

    echo "Error: Invalid input. Please choose a valid column number or name."
done

echo "Success: Primary key selected for column ${column_names[primary_key_index]}"

#******************************************************
echo ${column_names[@]}
echo ${data_types[@]}
echo `pwd`
echo $(ls -l)

# Create the table file in the $db_name directory
        touch $table_name
        mkdir 123

        #create the metadata file
        touch .${table_name}_md 2>&1
        if [ $? -ne 0 ]; then
            echo "Error creating metadata file: $?"
        fi

        # Set permissions for the file (table_name) and metadata file
        sudo chmod 644 $table_name
        sudo chmod 644 .${table_name}_md

        # Inform the user that the table is created successfully
        echo "Table '$table_name' created successfully"

        break
    done

        echo "${column_names[@]}" > $table_name
        echo "${data_types[@]}" > .${table_name}_md
        echo "pk=$((primary_key_index+1))" >> .${table_name}_md

}

# Call the function to create a new table
create_table
