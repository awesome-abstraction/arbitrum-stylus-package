
HTTP_PORT=9642
WS_PORT_NUM=8548

# DOCKER COMPOSE CMD
# --conf.file /config/sequencer_config.json --node.feed.output.enable 
# --node.feed.output.port 9642  --http.api net,web3,eth,txpool,debug 
# --node.seq-coordinator.my-url  ws://sequencer:8548 --graphql.enable 
# --graphql.vhosts * 
# --graphql.corsdomain *

def launch_sequencer(plan, args={}):
    seq_config = ServiceConfig(
        image="nitro-node-dev-testnode",
        ports={
            "portone":PortSpec(number=8547, transport_protocol="tcp"),
            "ws":PortSpec(number=WS_PORT_NUM, transport_protocol="ws"),
            "http":PortSpec(number=HTTP_PORT, transport_protocol="http"),
        },
        cmd=[
            "--conf.file",
            "/config/sequencer_config.json", # assuming this comes from the config step before but need ot get this one
            "--node.feed.output.enable",
            "--node.feed.output.port",
            FEED_OUTPUT_PORT,
            "--http.api",
            "net,web3,eth,txpool,debug",
            "--node.seq-coordinator.my-url",
            "ws://sequencer:{0}".format(PORT_ONE),
            "--graphql.enable",
            "--graphql.vhosts",
            "*",
            "--graphql.corsdomain",
            "*",
        ]
    )

    