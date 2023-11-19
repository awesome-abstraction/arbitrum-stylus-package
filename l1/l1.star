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
    network_info = ethereum.run(plan, l1_config)

    el_node = network_info.all_participants[0].el_client_context
    el_rpc_url = "{0}:{1}".format(el_node.ip_addr, el_node.rpc_port_num)
    el_ws_url = "{0}:{1}".format(el_node.ip_addr, el_node.ws_port_num)

    l1_info = struct(
        eth_rpc_url = el_node_url,
        eth_ws_url = el_ws_url,
        # ...
    )

    return l1_info