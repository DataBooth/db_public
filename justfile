# List the available just recipes (https://just.systems)
default:
    @just --list


# Export the Python project requirements from pyproject.toml to requirements.txt
reqs:
    pdm export --o requirements.txt --without-hashes --prod


# View/edit DuckDB database with Harlequin CLI (optional db_name else in memory database)
duck db_name="":
    harlequin --theme github-dark {{db_name}}


# Quarto render notebook with execution (https://quarto.org)
qrender notebook:
    quarto render {{notebook}} --execute

# View rendered notebook with execution (https://quarto.org)
qopen notebook:
    open {{notebook}}


# List the brew installs (both casks and non-casks)
brew-list:
    brew list --versions --casks 
    echo
    brew list --versions --formula
    echo

# Show the tree representation (default depth of 4) for the specified directory
show-tree directory level="4":
    cd {{directory}} && tree -d -L {{level}}

# Get local code repo list
local-code-repo-list:
    cd /Users/mjboothaus/code && tree -d -L 3
    echo

# Get local code repo list
local-data-repo-list:
    cd /Users/mjboothaus/data && tree -d -L 3   
    echo
    cd /Users/mjboothaus/icloud/Data && tree -d -L 3   
    echo

# Get macOS simple version info
macos-info:
    date
    sw_vers  # Could use following for more info: system_profiler SPSoftwareDataType
    echo

# macOS info and installed applications
macos-installs: macos-info
    tree /Applications -d -L 1
    echo

# Get a list of VS Code extensions
vscode-extensions:
    code --list-extensions --show-versions
    echo

# Get the serial number of the MacBook
get-macbook-serial-number2:
    system_profiler SPHardwareDataType | awk '/Serial Number/{print $4}'
    echo

# Get the serial number of the MacBook
# get-macbook-serial-number:
#     ioreg -c IOPlatformExpertDevice -d 2 | awk -F\" '/IOPlatformSerialNumber/{print $(NF-1)}'
#     echo

# Create a zip archive as a backup of all dotfiles in home directory
backup-dotfiles:
    #!/bin/bash

    # Define the backup directory and the backup file name
    backup_dir="$HOME/icloud/backup"
    backup_file="dotfiles_backup_$(date +%Y%m%d_%H%M%S).zip"

    # Create the backup directory if it doesnt exist
    mkdir -p "$backup_dir"

    # Find all dot files in the home directory and zip them
    find $HOME -maxdepth 1 -name ".*" -type f -not -name ".DS_Store" | zip "$backup_dir/$backup_file" -@ -x "*.DS_Store"

    # Echo the location of the backup file
    echo "Backup created at $backup_dir/$backup_file"


# Recipe for creating a (minimal) set of backup info
backup-info: get-macbook-serial-number2 macos-installs brew-list local-code-repo-list vscode-extensions list-hidden

# Output the backup info to iCloud drive
output-backup-info backup_info_file="backup-info.txt": 
    #!/usr/bin/env bash
    set -euo pipefail
    output_file="/Users/mjboothaus/icloud/backup/{{backup_info_file}}"
    echo "Generating backup info..."
    just backup-info > "$output_file"
    echo "Backup info written to $output_file"


# List hidden directories and their contents, sorted alphabetically (see also backup-dotfiles)
list-hidden:
    #!/usr/bin/env bash
    echo "Generating list of hidden (dot) directories..."
    echo
    for dir in $(ls -d ~/.* | sort | grep -v '\.Trash$'); do
        if [ -d "$dir" ]; then
            echo "$dir:"
            ls -lta "$dir" | sort -k9
            echo
        fi
    done