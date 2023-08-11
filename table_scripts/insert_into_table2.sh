#!/bin/bash

echo "Insert New Row into Table...."
read -p "Enter the table name you want to insert into: " tableName

table_file="${tableName}.txt"

if [ ! -f "databases/$mydb/$table_file" ]; then
    echo "Table '$table_file' does not exist in database '$mydb'."
    exit 1
fi

metadata_file="databases/$mydb/.${tableName}_md.txt"
data_file="databases/$mydb/$table_file"

if [ ! -f "$metadata_file" ]; then
    echo "Metadata file '$metadata_file' does not exist."
    exit 1
fi

IFS=',' read -r -a headers < "$metadata_file"
IFS=',' read -r -a types < "$metadata_file" | sed -n '2p'

declare -A data_map

for i in "${!headers[@]}"; do
    header="${headers[i]}"
    data_type="${types[i]}"
    
    while true; do
        read -p "Enter value for '$header' ($data_type): " value
        
        # Data type validation
        case "$data_type" in
            i)  # Integer
                if [[ "$value" =~ ^[0-9]+$ ]]; then
                    break
                else
                    echo "Invalid input. Please enter an integer value."
                fi
                ;;
            f)  # Float
                if [[ "$value" =~ ^[0-9]*\.?[0-9]+$ ]]; then
                    break
                else
                    echo "Invalid input. Please enter a float value."
                fi
                ;;
            s)  # String
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
    
    data_map["$header"]="$value"
done

new_row=""
for header in "${headers[@]}"; do
    new_row+="$(printf "%s" "${data_map["$header"]}")"
    new_row+=","
done
new_row=${new_row::-1}

echo "$new_row" >> "$data_file"

echo "New row inserted into $table_file."
