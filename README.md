# LightDock baseline

A Rust implementation of the [LightDock](https://lightdock.org) macromolecular software with the DFIRE and DNA scoring functions. Used for AD/AE evaluations


## Installation

1. Declare Variable

```shell
cd ./lightdock_CPU_baseline
export dock_base=`pwd`
```

2. Build Lightdock-Rust implementation (you may install Rust using [rustup](https://rustup.rs/)). More instruction refer to [Lightdock-Rust doc](./lightdock-rust-master/README.md)

```shell
cd ${dock_base}/lightdock-rust-master/
cargo build --release
```


3. Build Lightdock-py. More instruction refer to [Lightdockpy doc](./lightdockpy/README.md)

Dependencies
LightDock has the following dependencies:

* numpy>=1.17.1
* scipy>=1.3.1
* cython>=0.29.13
* prody>=1.10.11
* freesasa>=2.0.3
* Python>=3.7

```shell
cd ${dock_base}/lightdockpy/
virtualenv dock
source dock/bin/activate 
pip install nose
pip install .
```


## Execution 


the `bm` directory consists of the benchmark dataset 

```shell
cd ${dock_base}/lightdockpy/bm
bash measure_times_rust.sh
```


The final results will be shown in the `measure_rust.txt` file.