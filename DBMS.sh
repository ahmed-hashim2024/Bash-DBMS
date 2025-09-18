#!/bin/bash

####### variable #######

DBsRootDir="Databases"
dbName=""
DELIMITER="|"
CURRENT_DB_PATH=""

####### Colors #######

YELLOW='\033[1;33m'
CYAN='\033[0;36m'   
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

######### Main Functions ######### 
#start function check database root
function check_db_root() {
    if [ ! -d "$DBsRootDir" ]; then
        mkdir -p "$DBsRootDir"
    fi
}

# start function press enter to continue // To stop loop temporarily
function press_enter_to_continue() {
    echo ""
    read -p "Press Enter to continue..."
}

# Start Function to create a new database
function createDB()
{

    read -p "Enter Database Name: " dbName
    if [[ "$dbName" == "" ]]; then
        echo -e "$RED" "Database name cannot be empty.❌" "$NC"
        return
    elif [ -d "$DBsRootDir/$dbName" ];then
        echo -e "$RED" "Database name already exists.❌" "$NC"
        return 
    fi
        mkdir -p "Databases/$dbName"
    if [ $? -eq 0 ]; then
        echo -e "$GREEN""Database '$dbName' created successfully.✅""$NC"
    else
        echo "Failed to create database '$dbName'. It may already exist.❌"
    fi

}

# Start Function to list all databases
function listDBs()
{
    echo -e "${YELLOW}--- List All Databases ---${NC}"
    check_db_root
    local dbs=($(ls -d "$DBsRootDir"/*/ 2>/dev/null))

    if [ ${#dbs[@]} -eq 0 ]; then
        echo -e "${CYAN}No databases found.${NC}"
    else
        echo -e "${GREEN}Found ${#dbs[@]} database(s):${NC}"
        for db in "${dbs[@]}"; do
            dbName=$(basename "$db")
            echo "  - $dbName"
        done
    fi
}

# Start Function to drop a database
function dropDB()
{
    check_db_root
    listDBs
    read -p "Enter Database Name to Drop: " dbName
    for db in "$DBsRootDir"/*; do
        if [ "$(basename "$db")" == "$dbName" ]; then
            rm -r "$db"
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}Database '$dbName' deleted successfully.${NC}"
            else
                echo -e "${RED}Error: "Failed to drop database '$dbName'." ${NC}"
            fi
            return
        fi
    done
    echo "Database '$dbName' does not exist."
}

# Start Function to connect to a database
function connectDB()
{
    check_db_root
    listDBs
    read -p "Enter database name to connect: " dbName

    if [ -z "$dbName" ]; then
        echo -e "${RED}Error: Database name cannot be empty.${NC}"
        
        return
    fi

    local db_path="$DBsRootDir/$dbName"
    if [ -d "$db_path" ]; then
        CURRENT_DB_PATH="$db_path"
        echo -e "${GREEN}Connected to database '$dbName'.${NC}"
        connectedDBMenu
    else
        echo -e "${RED}Error: Database '$dbName' does not exist.${NC}"
    fi
}

# Start Function for connected database menu
function connectedDBMenu()
{
    while true; do
        clear
        echo -------------------------
        echo -e "${CYAN}Connected to: ${GREEN}$(basename "$CURRENT_DB_PATH")${NC}"
        echo -------------------------
        echo 1. Create Table
        echo 2. List Tables
        echo 3. Drop Table
        echo 4. Insert Into Table
        echo 5. Select from Table 
        echo 6. Delete from Table
        echo 7. Update Table
        echo 8. Back to Main Menu
        echo -------------------------

        read -p " Enter Your Choice :  " dbChoice

        case $dbChoice in
            1)
                createTable "$dbName"
                ;;
            2)
                listTables "$dbName"
                ;;
            3)
                dropTable "$dbName"
                ;;
            4)
                insertIntoTable "$dbName"
                ;;
            5)
                select_from_table "$dbName"
                ;;
            6)
                delete_from_table "$dbName"
                ;;
            7)
                update_table "$dbName"
                ;;
            8)
                main_menu
                ;;
            *)
                echo -e "${RED}Invalid choice. Please try again.${NC}"

                ;;
        esac
        press_enter_to_continue
    done
}

# start main function
function main_menu() {
    check_db_root
    while true; do
        clear
        echo "----------------------------------------------------"
        echo  -e "${GREEN}Bash Shell Script DBMS - Main Menu${NC}"
        echo "----------------------------------------------------"
        echo "1. Create Database"
        echo "2. List Databases"
        echo "3. Connect To Database"
        echo "4. Drop Database"
        echo "5. Exit"
        echo "----------------------------------------------------"
        read -p "Enter your choice: " choice

        case $choice in
            1) createDB ;;
            2) listDBs ;;
            3) connectDB ;;
            4) dropDB ;;
            5) exit ;;
            *) echo -e "${RED}Invalid choice. Please try again.${NC}❌" ;;
        esac
        press_enter_to_continue
    done
}

######### Sub Main Functions ######### 
# Start Function to create a new table in a database 
function createTable(){
    echo -e "${YELLOW}--- Create a New Table ---${NC}"
    read -p "Enter table name: " table_name

    if [[ ! "$table_name" =~ ^[a-zA-Z0-9_]+$ ]]; then
        echo -e "${RED}Error: Table name can only contain letters, numbers, and underscores.${NC}"
        return
    fi
    
    local table_path="$CURRENT_DB_PATH/$table_name"
    if [ -f "$table_path" ]; then
        echo -e "${RED}Error: Table '$table_name' already exists.${NC}"
        return
    fi
    touch "$table_path"
    local num_cols
    read -p "Enter number of columns: " num_cols
    if ! [[ "$num_cols" =~ ^[0-9]+$ ]] || [ "$num_cols" -le 0 ]; then
        echo -e "${RED}Error: Number of columns must be a positive integer.${NC}"
        return
    fi
    
    local header
    local cols=()
    for ((i=1; i<=num_cols; i++)); do
        read -p "Enter name for column $i: " col_name
        cols+=("$col_name")
    done
    
    # Use awk to format the header with the specified delimiter
    header=$(printf '%s\n' "${cols[@]}" | awk -v d="$DELIMITER" '{s=(NR==1?s:s d) $0} END{print s}')

    echo "$header" > "$table_path"

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Table '$table_name' created successfully.${NC}"
    else
        echo -e "${RED}Error: Failed to create table '$table_name'.${NC}"
    fi
}

# Start Function to list all tables in a database
function listTables() {
    echo -e "${YELLOW}--- List Tables in $(basename "$CURRENT_DB_PATH") ---${NC}"
    local tables=($(ls "$CURRENT_DB_PATH" 2>/dev/null))
    if [ ${#tables[@]} -eq 0 ]; then
        echo -e "${CYAN}No tables found in database '$(basename "$CURRENT_DB_PATH")'.${NC}"
    else
        echo -e "${GREEN}Found ${#tables[@]} table(s):${NC}"
        for table in "${tables[@]}"; do
            echo "  - $table"
        done
    fi
    
}

# Start Function to drop a table in a database
function dropTable() {
    echo -e "${RED}--- WARNING: Drop a Table ---${NC}"
    listTables
    read -p "Enter table name to delete (or 'q' to cancel): " table_name

    if [ "$table_name" == "q" ]; then
        echo -e "${YELLOW}Drop operation cancelled.${NC}"
        return
    fi
    
    local table_path="$CURRENT_DB_PATH/$table_name"
    if [ -f "$table_path" ]; then
        read -p "Are you sure you want to delete '$table_name'? (y/n): " confirm
        if [ "$confirm" == "y" ]; then
            rm -f "$table_path"
            echo -e "${GREEN}Table '$table_name' deleted successfully.${NC}"
        else
            echo -e "${YELLOW}Operation cancelled.${NC}"
        fi
    else
        echo -e "${RED}Error: Table '$table_name' does not exist.${NC}"
    fi
}

# Start Function to insert into a table in a database
function insertIntoTable() {
    echo -e "${CYAN}--- Insert Data into Table ---${NC}"
    listTables
    read -p "Enter table name: " table_name

    local table_path="$CURRENT_DB_PATH/$table_name"

    if [ ! -f "$table_path" ]; then
        echo -e "${RED}Error: Table '$table_name' does not exist.${NC}"
        return
    fi
    local header_line=$(head -n 1 "$table_path")
    local col_names=(${header_line//$DELIMITER/ })
    local new_row=()   

    for col in "${col_names[@]}"; do
        read -p "Enter value for '$col': " value
        new_row+=("$value")
    done
    local new_record=$(printf '%s\n' "${new_row[@]}" | awk -v d="$DELIMITER" '{s=(NR==1?s:s d) $0} END{print s}')
    echo "$new_record" >> "$table_path"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Record inserted successfully into '$table_name'.${NC}"
    else
        echo -e "${RED}Error: Failed to insert record into '$table_name'.${NC}"
    fi
}

# Start Function to select from a table in a database
function select_from_table() {
    echo -e "${CYAN}--- Select from Table ---${NC}"
    listTables
    read -p "Enter table name: " table_name

    local table_path="$CURRENT_DB_PATH/$table_name"
    
    if [ ! -f "$table_path" ]; then
        echo -e "${RED}Error: Table '$table_name' does not exist.${NC}"
        return
    fi

    echo -e "${YELLOW}Data in table '$table_name':${NC}"
    echo "----------------------------------------------------"
    cat "$table_path" | column -t -s"$DELIMITER"
    echo "----------------------------------------------------"
}

# Start Function to delete from a table in a database
function delete_from_table() {
    echo -e "${RED}--- Delete from Table ---${NC}"
    listTables
    read -p "Enter table name: " table_name

    local table_path="$CURRENT_DB_PATH/$table_name"
    if [ ! -f "$table_path" ]; then
        echo -e "${RED}Error: Table '$table_name' does not exist.${NC}"
        return
    fi
    local header_line=$(head -n 1 "$table_path")
    local col_names=(${header_line//$DELIMITER/ }) 
    echo -e "${YELLOW}Columns: ${col_names[*]}${NC}"
    read -p "Enter column name for condition : " condition_col
    read -p "Enter value for condition : " condition_val
    local col_index=-1
    for (( i=0; i<${#col_names[@]}; i++ )); do
        if [ "${col_names[$i]}" == "$condition_col" ]; then
            col_index=$i
            break
        fi
    done
    if [ "$col_index" -eq -1 ]; then
        echo -e "${RED}Error: Column '$condition_col' not found.${NC}"
        return
    fi

    local search_pattern="$(printf '%s' "$DELIMITER" | sed 's/[.[\*^$]/\\&/g')"
    local awk_script='BEGIN{FS=OFS="'"$search_pattern"'"}{if ($'"$(($col_index + 1))"' != "'"$condition_val"'") print}'
    
    awk "$awk_script" "$table_path" > temp.txt && mv temp.txt "$table_path"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Records deleted successfully from '$table_name'.${NC}"
    else
        echo -e "${RED}Error: Failed to delete records from '$table_name'.${NC}"
    fi
}

#start Function to update a table in a database

function update_table() {
    echo -e "${CYAN}--- Update Table ---${NC}"
    listTables
    read -p "Enter table name: " table_name
    
    local table_path="$CURRENT_DB_PATH/$table_name"
    if [ ! -f "$table_path" ]; then
        echo -e "${RED}Error: Table '$table_name' does not exist.${NC}"
        return
    fi

    local header_line=$(head -n 1 "$table_path")
    local col_names=(${header_line//$DELIMITER/ }) 

    # Get the column and value for the WHERE condition
    echo -e "${YELLOW}Columns: ${col_names[*]}${NC}"
    read -p "Enter column name for condition : " condition_col
    read -p "Enter value for condition : " condition_val

    # Get the column and value for the SET part
    read -p "Enter column name to update: " update_col
    read -p "Enter new value: " new_val

    local condition_col_idx=-1
    local update_col_idx=-1
    for (( i=0; i<${#col_names[@]}; i++ )); do
        if [ "${col_names[$i]}" == "$condition_col" ]; then
            condition_col_idx=$i
        fi
        if [ "${col_names[$i]}" == "$update_col" ]; then
            update_col_idx=$i
        fi
    done

    if [ "$condition_col_idx" -eq -1 ] || [ "$update_col_idx" -eq -1 ]; then
        echo -e "${RED}Error: One or both of the columns not found.${NC}"
        return
    fi

    local temp_file=$(mktemp)
    awk -F"$DELIMITER" -v cond_idx="$((condition_col_idx + 1))" -v update_idx="$((update_col_idx + 1))" -v cond_val="$condition_val" -v new_val="$new_val" 'BEGIN {OFS=FS} { if (NR > 1 && $cond_idx == cond_val) {$update_idx = new_val; print} else {print} }' "$table_path" > "$temp_file"
    mv "$temp_file" "$table_path"
    echo -e "${GREEN}Records updated successfully.${NC}"
}

# Start the application
main_menu
