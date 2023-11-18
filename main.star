l1 = import_module("github.com/kurtosis-tech/ethereum-package/main.star")

def run(plan, args={}):
    plan.print("Launching L1 ethereum network...")
    l1_config = {
        "participants":[{
            "el_client_type": "geth",
            "cl_client_type": "prysm",
        }],
        "additional_services":[],
    }
    l1.run(plan, l1_config)

    # figure how to fund the sequencer
    plan.print("Funding sequencer...")

    plan.print("Creating l1 traffic...")

    plan.print("Writing l2 chain config...")

    plan.print("Deploying config...")

    plan.print("Initializing redis...")

    plan.print("Funding l2 funnel...")

    plan.print("Deploying token bridge...")

    plan.print("Funding l3 users...")

    plan.print("Create l2 traffic...")

    plan.print("Writing l3 chain config...")

    plan.print("Deploying l3...")

    plan.print("Funding l3 funnel...")
    # ADD SEQUENCER
    #   sequencer:
        # image: nitro-node-dev-testnode
        # ports:
        #   - "127.0.0.1:8547:8547"
        #   - "127.0.0.1:8548:8548"
        #   - "127.0.0.1:9642:9642"
        # volumes:
        #   - "seqdata:/home/user/.arbitrum/local/nitro"
        #   - "config:/config"
        # command: --conf.file /config/sequencer_config.json --node.feed.output.enable --node.feed.output.port 9642  --http.api net,web3,eth,txpool,debug --node.seq-coordinator.my-url  ws://sequencer:8548 --graphql.enable --graphql.vhosts * --graphql.corsdomain *
        # depends_on:
        #   - geth
        #   - redis
    # sequencer_config = ServiceConfig(
    #     image=nitro-node-dev-testnode,
    #     ports={
    #         "ONE":"8547",
    #         "TWO":"8548",
    #         "THREE":"9642",
    #     },
    #     cmd:[
    #         "--conf.file", 
    #         "/config/sequencer_config.js",
    #         "--node.feed.output.enable",
    #         "--node.feed.output.port",
    #         SEQUENCER_PORT_THREE,
    #         "--http.api",
    #         "net,web3,eth,txpool,debug",
    #         "--node.feed.output.port",
    #         "ws://sequencer:8548",
    #         "--graphql.enable",
    #         "--graphql.vhosts",
    #         "*",
    #         "--graphql.corsdomain",
    #         "*",
    #         ]
