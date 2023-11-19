consts = import_module("../constants.star")

CONFIG_DIRPATH = "/config/"
L2_CHAIN_CONFIG_FILEPATH=CONFIG_DIRPATH + "l2_chain_config.json"

# figure out where these come from
DEPLOYMENT_FILEPATH=CONFIG_DIRPATH + "deployment.json"
DEPLOYED_CHAIN_INFO_FILEPATH=CONFIG_DIRPATH + "deployed_chain_info.json"

# DOCKER COMPOSE CMD
# /usr/local/bin/deploy poster --l1conn ws://geth:8546 
# --l1keystore /home/user/l1keystore --sequencerAddress $sequenceraddress 
# --ownerAddress $sequenceraddress --l1DeployAccount $sequenceraddress 
# --l1deployment /config/deployment.json --authorizevalidators 10 
# --wasmrootpath /home/user/target/machines --l1chainid=$l1chainid 
# --l2chainconfig /config/l2_chain_config.json --l2chainname arb-dev-test 
# --l2chaininfo /config/deployed_chain_info.json

# list of things to parameterize
# - l1 keystore location
# - sequencer address
# - geth ws endpoint
# - l1chain id

# list of files to get/figure out where they are generated
# - /config/deployment.json (l1 deployment info)
# - /config/deployed_chain_info.json (l2 chain info? vs. l2 chain config?)
def launch_poster(
    plan, 
    geth_ws_endpoint,
    sequencer_address, # figure out how to get sequencer address
    l1_keystore_path="", # figure out where to even get this
    args={}):

    l2_chain_config = {
        name="l2_chain_config",
        src = "../static_files/l2_chain_config.json",
    }

    poster_config = ServiceConfig(
        image="nitro-node-dev-testnode",
        ports={
                "portone": PortSpec(number=8547, transport_protocol="http"),
                "porttwo": PortSpec(number=8548, transport_protocol="http"),
        },
        files={
            L2_CHAIN_CONFIG_FILEPATH: l2_chain_config
        },
        entrypoint=[
            "/usr/local/bin/deploy",
            "poster",
            "--l1conn",
            geth_ws_endpoint,
            "--l1keystore", 
            l1_keystore_path, # how is it that the l1 keystore is getting put onto the poster
            "--sequencerAddress", 
            sequencer_address,
            "--ownerAddress",
            sequencer_address,
            "--l1DeployAccount",
            sequencer_address,
            "--l1deployment",
            "/config/deployment.json", # figure out how to get this from the ethereum package (and maybe what its used for)
            "--authorizevalidators",
            "10",
            "--wasmrootpath",
            "/home/user/target/machines",
            "--l1chainid",
            consts.L1_CHAIN_ID,
            "--l2chainconfig",
            L2_CHAIN_CONFIG_FILEPATH,
            "--l2chainname",
            "arb-dev-test",
            "--l2chaininfo",
            "/config/deployed_chain_info.json" # figure out how to get this as well
        ]
    )

    poster_context = plan.add_service("poster", poster_config)

    plan.exec("poster", ExecRecipe(
        command=["jq", "[.[]]", "/config/deployed_chain_info.json", ">","/config/l2_chain_info.json"]
    ))
    
    return poster_context
    