def run_hello(plan, config_json):
    # https://docs.kurtosis.com/starlark-reference/plan#add_service
    plan.add_service(
        name = "hello",
        config = ServiceConfig(
            image = "hello-world",
            files = {
                # This is just an example showing how to mount files on a service
                "/config": config_json,
            }
        )
    )
