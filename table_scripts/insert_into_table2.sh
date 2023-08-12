#!/bin/bash

while true; do
    echo "Insert New Row into Table...."
    read -p "Enter the table name you want to insert into: " table_name
    table_file="$table_name"
    metadata_file=".${table_name}_md"
    data_file="$table_name"

    if [ ! -f "$data_file" ]; then
        echo "Table '$table_file' does not exist."
        exit 1
    fi

    if [ ! -f "$metadata_file" ]; then
        echo "Metadata file '$metadata_file' does not exist."
        exit 1
    fi

    IFS=',' read -r -a headers < "$table_file"
    IFS=',' read -r -a types < <(sed -n '1p' "$metadata_file")  # Read only the first line
    pk_column=$(tail -n 1 "$metadata_file" | sed 's/pk=//')

    declare -A data_map


# Load existing primary key values
existing_pk_values=($(cut -d ',' -f $pk_column "$data_file"))

    # Load existing primary key values
    existing_pk_values=($(cut -d ',' -f $pk_column "$data_file"))

    for ((i = 0; i < ${#headers[@]}; i++)); do
        header="${headers[i]}"
        data_type="${types[i]}"

        while true; do
            read -p "Enter value for '$header' ($data_type): " value

            # Validate value based on data type
            case "$data_type" in
                int)  # Integer
                    if [[ "$value" =~ ^[0-9]+$ ]]; then
                        break
                    else
                        echo "Invalid input. Please enter an integer value."
                    fi
                    ;;
                float)  # Float
                    if [[ "$value" =~ ^[0-9]*\.?[0-9]+$ ]]; then
                        break
                    else
                        echo "Invalid input. Please enter a valid numeric value."
                    fi
                    ;;
                string)  # String
                    if [[ -n "$value" ]]; then
                        break
                    else
                        echo "Invalid input. Please enter a non-empty string."
                    fi
                    ;;
                *)
                    echo "Invalid data type found in metadata."
                    exit 1
                    ;;
            esac
        done
#**********************************************************************************
        # Validate primary key uniqueness
        if [ "$i" -eq "$pk_column" ]; then
            if [[ " ${existing_pk_values[@]} " =~ " ${value} " ]]; then
                echo "Primary key value already exists. Please enter a unique value."
                exit 1
            fi
        fi

        data_map["$header"]="$value"
    done

    new_row=""
    for header in "${headers[@]}"; do
        new_row+="$(printf "%s" "${data_map["$header"]}")"
        new_row+=","
    done
    new_row=${new_row::-1}
#**********************************************************************************
# Validate primary key uniqueness and non-empty values
if [ "$i" -eq "$pk_column" ]; then
    if [[ " ${existing_pk_values[@]} " =~ " ${value} " ]]; then
        echo "Error: Primary key value already exists. Please enter a unique value."
        exit 1
    elif [[ -z "$value" ]]; then
        echo "Error: Primary key value cannot be empty."
        exit 1
    fi
fi


    echo "$new_row" >> "$data_file"
    echo "New row inserted into $table_file."

    # Prompt to add another row
    read -p "Do you want to add another row? (y/n): " add_another
    if [ "$add_another" != "y" ]; then
        echo "Exiting..."
        break
    fi
done
