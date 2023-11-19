ethereum = import_module("github.com/kurtosis-tech/ethereum-package/main.star")


def launch_l1(plan, args={}):
    # launch l1 implementation that you want to launch!
    # eg. ethereum
    l1_config = {
        "participants":[{
            "el_client_type": "geth",
            "cl_client_type": "prysm",
        }],
        "additional_services":[],
    }
    ethereum.run(plan, l1_config)