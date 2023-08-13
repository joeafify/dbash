#!/bin/bash

select_table_name(){
    read -r -p "Select table name: " table_name 
    if [ ! -f ${table_name} ]; then
    message.sh "Table does not exist" "error"
    select_table_name
    fi
}
select_columns(){
    read -r -p "Select columns: (ex. <col_name1> [<col_name2> ...]): " column_names
    read -ra column_names_arr <<< "$column_names"
    if [ ${#column_names_arr[@]} -lt 1 ]; then
    echo "Usage: <col_name1> [<col_name2> ...]"
    select_columns
    fi
}
select_table_name
select_columns

awk -F, -v cols="${column_names_arr[*]}" '
  BEGIN {
    n = split(cols, col_names, " ")
    getline
    split($0, header, ",")
    
    for (i = 1; i <= n; i++) {
      for (j = 1; j <= NF; j++) {
        if (col_names[i] == header[j]) {
          col_index[i] = j
          break
        }
      }
    }
     for (i in col_names) {
       if(i%2==0){
            printf "\033[0;31m%s%s\033[0m", $(col_index[i]), (i < n ? " " : "\n")
            }
        else {
            printf "\033[0;32m%s%s\033[0m", $(col_index[i]), (i < n ? " " : "\n")
            }
    }
  }
  { 
    
    for (i = 1; i <= n; i++) {
        if(i%2==0){
            printf "\033[0;31m%s%s\033[0m", $(col_index[i]), (i < n ? " " : "\n")
            }
        else if(i%2==1) {
            printf "\033[0;32m%s%s\033[0m", $(col_index[i]), (i < n ? " " : "\n")
            }
      
    }
  }
' "$table_name"