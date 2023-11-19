l1 = import_module("./l1/l1.star")
l2 = import_module("./l2/l2.star")

# - num sequencers num
# - token bridge bool
def run(plan, args={}):
    plan.print("Deploying L1 ethereum network...")
    l1_info = l1.launch_l1(plan)

    plan.print("Deploying L2 arbitrum network...")
    l2.launch_l2(plan, l1_info.eth_rpc_url, l1_info.eth_ws_url)