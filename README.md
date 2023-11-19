Arbitrum Stylus Package
=======================
This is a [Kurtosis](https://github.com/kurtosis-tech/kurtosis/) package that brings up full, Dencun-ready Ethereum node (default EL/CL pair is Geth and Lighthouse) and connects it to an Arbitrum node, alongside a sequencer, batch poster, and token bridge.

Run this package
----------------
If you have [Kurtosis installed][install-kurtosis], run:

```bash
kurtosis run github.com/awesome-abstraction/arbitrum-stylus-package
```

If you don't have Kurtosis installed, [click here to run this package on the Kurtosis playground](https://gitpod.io/?autoStart=true&editor=code#https://github.com/kurtosis-tech/playground-gitpod).

To blow away the created [enclave][enclaves-reference], run `kurtosis clean -a`.

Use this package in your package
--------------------------------
Kurtosis packages can be composed inside other Kurtosis packages. To use this package in your package:

First, import this package by adding the following to the top of your Starlark file:

```python
# For remote packages: 
this_package = import_module("github.com/awesome-abstraction/arbitrum-stylus-package/main.star") 

# For local packages:
this_package = import_module("./main.star")
```

If you want to use a fork or specific version of this package in your own package, you can replace the dependencies in your `kurtosis.yml` file using the [replace](https://docs.kurtosis.com/concepts-reference/kurtosis-yml/#replace) primitive. 
Within your `kurtosis.yml` file:
```python
name: github.com/example-org/example-repo
replace:
    github.com/awesome-abstraction/arbitrum-stylus-package: github.com/YOURUSER/THISREPO@YOURBRANCH
```

Then, call the this package's `run` function somewhere in your Starlark script:

```python
this_package_output = this_package.run(plan, args)
```

Develop on this package
-----------------------
1. [Install Kurtosis][install-kurtosis]
1. Clone this repo
1. For your dev loop, run `kurtosis clean -a && kurtosis run .` inside the repo directory


<!-------------------------------- LINKS ------------------------------->
[install-kurtosis]: https://docs.kurtosis.com/install
[enclaves-reference]: https://docs.kurtosis.com/concepts-reference/enclaves
