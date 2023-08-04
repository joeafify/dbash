#!/bin/bash

# Function to drop an existing database
function drop_database {
    # Check if the "databases" directory exists
    if [ ! -d "databases" ]; then
        echo "Error: The 'databases' directory does not exist."
        return
    fi

    while true; do
        # Get a list of existing databases
        databases=$(ls databases/ 2>/dev/null)

        # Check if there are any databases to drop
        if [ -z "$databases" ]; then
            echo "Error: There are no databases to drop."
            return
        fi

        # Display the list of existing databases
        echo "Existing databases:"
        for db in $databases; do
            echo "- $db"
        done

        # Prompt the user to enter the name of the database to drop or choose the exit option
        read -p "Enter the name of the database you want to drop or type 'exit' to exit: " db_name

        # Check if the user wants to exit
        if [ "$db_name" == "exit" ]; then
            echo "Exiting drop_db.sh..."
            return
        fi

        # Check if the user entered a valid database name
        if [ -z "$db_name" ]; then
            echo "Error: Database name cannot be empty."
        elif [ ! -d "databases/$db_name" ]; then
            echo "Error: Database '$db_name' does not exist."
        else
            # Confirm the database deletion with the user
            read -p "Are you sure you want to drop the database '$db_name'? (y/n): " confirm
            case $confirm in
                [Yy]) rm -rf "databases/$db_name"
                      echo "Database '$db_name' has been dropped successfully."
                      ;;

                [Nn]) echo "Database '$db_name' has not been dropped."
                      ;;

                *)    echo "Invalid choice. Database '$db_name' has not been dropped."
                      ;;
            esac

            # Prompt the user to continue or exit
            while true; do
                read -p "Do you want to drop another database? (y/n): " continue_choice
                case $continue_choice in
                    [Yy]) break ;;  # Continue to drop another database
                    [Nn]) echo "Exiting drop_db.sh..."
                          return ;;  # Exit drop_db.sh
                    *)    echo "Invalid choice. Please enter 'y' to continue or 'n' to exit."
                          ;;
                esac
            done
        fi
    done
}

# Call the function to drop an existing database
drop_database
