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