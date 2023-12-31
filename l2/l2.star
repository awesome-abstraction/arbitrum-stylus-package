redis = import_module("github.com/kurtosis-tech/postgres-package/main.star")

poster = import_module("./poster/poster_launcher.star")
sequencer = import_module("./sequencer/sequencer_launcher.star")
token_bridge = import_module("./token_bridge/token_bridge_launcher.star")


def launch_l2(
    plan,
    eth_rpc_url,
    eth_ws_url):
    # figure how to fund the sequencer
    # figure out where validator keys that are funded are
    plan.print("Funding validator and sequencer...")

    plan.print("Creating L2 traffic...")

    plan.print("Deploying L2 Arbitrum network...")
    l1_keystore_path = ""
    sequencer_address = ""
    poster.launch_poster(plan, l1_keystore_path, sequencer_address, eth_ws_url)

    plan.print("Funding L2 funnel...")




    # for i in range(0, num_sequencers):
    plan.print("Initializing redis cache num {0}...".format(i))
    redis_context = redis.run(plan)

    # spin up sequencers
    sequencer = sequencer.launch_sequencer(plan)
        
    plan.print("Deploying token bridge...")
    sequencer_url="http://{0}:{1}".format(sequencer.ip_address, sequencer.ports["http"].number)
    token_bridge.launch_token_bridge(plan, sequencer_url, eth_rpc_url)