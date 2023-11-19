l1 = import_module("github.com/kurtosis-tech/ethereum-package/main.star")
poster = import_module("./l2/poster/poster_launcher.star")
sequencer = import_module("./l2/sequencer/sequencer_launcher.star")
redis = import_module("github.com/kurtosis-tech/postgres-package/main.star")
token_bridge = import_module("./l2/token_bridge/token_bridge_launcher.star")


# high level json config
# - num sequencers
# - token bridge?? yes?
def run(plan, args={}):
    plan.print("Deploying L1 ethereum network...")
    l1_config = {
        "participants":[{
            "el_client_type": "geth",
            "cl_client_type": "prysm",
        }],
        "additional_services":[],
    }
    l1.run(plan, l1_config)

    # figure how to fund the sequencer
    # figure out where validator keys that are funded are
    plan.print("Funding validator and sequencer...")

    plan.print("Creating L2 traffic...")

    plan.print("Deploying L2 Arbitrum network...")
    poster.launch_poster(plan, args)

    plan.print("Funding L2 funnel...")
    for i in range(0, num_sequencers):
        plan.print("Initializing redis cache num {0}...".format(i))
        redis_context = redis.run(plan, args)

        # spin up sequencers
        sequencer = sequencer.launch_sequencer()
        
    plan.print("Deploying token bridge...")
    token_bridge.launch_token_bridge()


    plan.print("Funding L3 users...")

    plan.print("Create L2 traffic...")

    plan.print("Deploying L3...")

    plan.print("Funding L3 funnel...")