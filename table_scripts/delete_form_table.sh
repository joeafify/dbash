#!/bin/bash

# Delete From Table Script
# This script allows you to delete rows from an existing table in the current database.
# You will be prompted to provide the name of the table and conditions for deleting rows.
# The script will perform necessary validations before deleting the rows.

# Function to delete rows from a table
function delete_from_table {
    while true; do
        echo "Delete Rows from Table..."
        read -p "Enter the name of the table you want to delete rows from: " table_name
        table_file="$table_name"
        metadata_file=".${table_name}_md"
        data_file="$table_name"

        if [ ! -f "$data_file" ]; then
            echo "Table '$table_file' does not exist."
            return
        fi

        if [ ! -f "$metadata_file" ]; then
            echo "Metadata file '$metadata_file' does not exist."
            return
        fi

        IFS=',' read -r -a headers < "$table_file"
        IFS=',' read -r -a types < <(sed -n '1p' "$metadata_file")  # Read only the first line
        pk_column=$(tail -n 1 "$metadata_file" | sed 's/pk=//')

        # Display available columns for user's reference
        echo "Available columns in '$table_name':"
        for ((i = 0; i < ${#headers[@]}; i++)); do
            echo "$((i+1)): ${headers[i]} (${types[i]})"
        done

        # Prompt for primary key column
        read -p "Enter the number of the primary key column to filter by (or any other column): " pk_column_num
        if [[ "$pk_column_num" =~ ^[0-9]+$ ]] && [ "$pk_column_num" -ge 1 ] && [ "$pk_column_num" -le ${#headers[@]} ]; then
            pk_column_num=$((pk_column_num-1))
            pk_column_header="${headers[pk_column_num]}"
        else
            echo "Invalid input for primary key column number."
            continue
        fi

        # Prompt for value of primary key to filter by
        read -p "Enter the value of '$pk_column_header' to filter rows: " pk_value

        # Validate value based on primary key data type
        case "${types[pk_column_num]}" in
            int)  # Integer
                if ! [[ "$pk_value" =~ ^[0-9]+$ ]]; then
                    echo "Invalid input. Please enter an integer value."
                    continue
                fi
                ;;
            float)  # Float
                if ! [[ "$pk_value" =~ ^[0-9]*\.?[0-9]+$ ]]; then
                    echo "Invalid input. Please enter a float value."
                    continue
                fi
                ;;
            string)  # String
                if [ -z "$pk_value" ]; then
                    echo "Invalid input. Please enter a non-empty string."
                    continue
                fi
                ;;
            *)
                echo "Invalid data type found in metadata."
                return
                ;;
        esac

        # Perform deletion based on primary key condition
        grep -v "^$pk_value," "$data_file" > "${data_file}_temp"
        mv "${data_file}_temp" "$data_file"

        echo "Rows with '$pk_column_header' = '$pk_value' have been deleted from '$table_name'."
        break
    done
}

# Call the function to delete rows from a table
delete_from_table
