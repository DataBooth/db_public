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
get-macbook-serial-number:
    ioreg -l | awk '/IOPlatformSerialNumber/ { print $4;}'
    echo


# Recipe for creating a (minimal) set of backup info
backup-info: get-macbook-serial-number macos-installs brew-list local-code-repo-list vscode-extensions

# Output the backup info to iCloud drive
output-backup-info backup_info_file="backup-info.txt": 
    just backup-info > /Users/mjboothaus/icloud/backup/{{backup_info_file}}