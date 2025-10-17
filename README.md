<br>
<h1 align="center">
    Bash Shell Script DBMS 🐚
    <br>
    <img src="https://media.giphy.com/media/QssGEmpkyEOhBCb7e1/giphy.gif?cid=ecf05e47a0n3gi1bfqntqmob8g9aid1oyj2wr3ds3mg700bl&rid=giphy.gif" width="35px" height="35px">
    <strong>Simple File-Based Database Management System</strong>
</h1>
<div align="center">
  <img src="https://readme-typing-svg.herokuapp.com?font=Fira+Code&weight=490&pause=1000&color=007ACC&center=true&vCenter=true&width=550&lines=A+complete+DBMS+built+with+Bash;Create%2C+List%2C+Connect%2C+Drop+Databases;Manage+Tables%3A+CRUD+Operations;" alt="Typing SVG" />
</div>

---

## 🚀 Project Overview

This is a **File-Based Database Management System (DBMS)** meticulously crafted entirely using **Bash Shell Script**. It offers a robust and interactive Command Line Interface (CLI) for performing fundamental database and table operations (CRUD).

This project demonstrates the power of Bash scripting to create complex, functional applications, utilizing core Linux utilities like `awk`, `sed`, `grep`, and `column` for data manipulation and presentation.

### ✨ Key Features

* **Database Management:** Create, List, Connect to, and Drop databases. Databases are stored as directories under the `Databases` root folder.
* **Table Management (DDL):** Create new tables by defining columns, List all tables, and Drop existing tables.
* **Data Manipulation (DML - CRUD):**
    * **Insert:** Insert new records into a table.
    * **Select:** Display all data from a table in a clean, formatted manner using the `column -t` utility.
    * **Delete:** Delete records based on a specified column value (WHERE condition).
    * **Update:** Update specific fields in records based on a condition (SET/WHERE logic).
* **CLI Interface:** User-friendly menus for seamless navigation.


---

## 🛠️ Getting Started

### Prerequisites

You need a Linux or Unix-like environment (e.g., Ubuntu, macOS, WSL) with **Bash** installed. The project relies on standard utilities like `awk`, `column`, `ls`, and `mktemp`.

### Installation and Execution

1.  **Clone the Repository:**
    ```bash
    git clone [https://github.com/ahmed-hashim2024/bash-dbms.git](https://github.com/ahmed-hashim2024/bash-dbms.git) # Replace with the actual link
    cd bash-dbms
    ```

2.  **Make the script Executable:**
    ```bash
    chmod +x dbms.sh # Assuming the script file is named dbms.sh
    ```

3.  **Run the DBMS:**
    ```bash
    ./dbms.sh
    ```

### 📂 Project Structure (File-Based Storage)

Databases are stored as directories, and tables are stored as plain files within them.

```bash
.
├── Databases/
│   ├── UserDB/
│   │   ├── Profiles      # Table file (Data stored with '|' delimiter)
│   │   └── Orders        # Table file
│   └── MarketingDB/
│       └── Campaigns     # Table file
├── dbms.sh               # The main Bash script
└── README.md
