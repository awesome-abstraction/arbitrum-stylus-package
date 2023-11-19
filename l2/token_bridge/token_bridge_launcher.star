consts = import_module("../constants.star")


def launch_token_bridge(
    plan, 
    sequencer_url="",
    eth_url=""):
    tb_config = ServiceConfig(
        image="tedim52/arb-token-bridge:latest",
        env_vars={
            "ARB_URL": sequencer_url, 
            "ETH_URL": eth_url,
            "ARB_KEY": consts.DEV_PRIV_KEY,
            "ETH_KEY": consts.DEV_PRIV_KEY, 
        }
    )

    plan.add_service("token-bridge", tb_config)

    plan.exec("token-bridge", ExecRecipe(
        command=["-c", "cat", "localNetwork.json"]
    ))