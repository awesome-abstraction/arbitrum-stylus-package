# NOTE: If you're a VSCode user, you might like our VSCode extension: https://marketplace.visualstudio.com/items?itemName=Kurtosis.kurtosis-extension

# Importing the Postgres package from the web using absolute import syntax
# See also: https://docs.kurtosis.com/starlark-reference/import-module
postgres = import_module("github.com/kurtosis-tech/postgres-package/main.star")

# Importing a file inside this package using relative import syntax
# See also: https://docs.kurtosis.com/starlark-reference/import-module
lib = import_module("./lib/lib.star")

# For more information on...
#  - the 'run' function:  https://docs.kurtosis.com/concepts-reference/packages#runnable-packages
#  - the 'plan' object:   https://docs.kurtosis.com/starlark-reference/plan
#  - arguments:           https://docs.kurtosis.com/run#arguments
def run(plan, name = "John Snow"):
    plan.print("Hello, " + name)

    # https://docs.kurtosis.com/starlark-reference/plan#upload_files
    config_json = plan.upload_files("./static-files/config.json")

    lib.run_hello(plan, config_json)

    postgres.run(plan)
