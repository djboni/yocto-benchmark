# Yocto Benchmark - Memory Usage Workflow

Tested on a Debian 11 server.

- Create a server
- SSH into the server

```console
$ ssh root@IP_ADDRESS
```

- Install updates and git
- Add user (set user's password)
- Add the user to the group sudo
- Login as the user

```console
$ apt update && apt upgrade -y && apt install git sysstat -y
$ adduser user
$ adduser user sudo
$ sudo -iu user
```

- Clone the repository NUM times

```sh
NUM=8
for COUNT in $(seq $NUM); do
    git clone https://github.com/djboni/yocto-benchmark yocto-benchmark$COUNT
done
```

- Change directory
- Install the dependencies (use user's password)

```console
$ cd yocto-benchmark1
$ ./install
```

- Download NUM times

```sh
for COUNT in $(seq $NUM); do
    cd yocto-benchmark$COUNT
    ./download
    cd ..
done
```

- In multiple consoles:
  - Start performance grph (in yocto-benchmark1)
  - Run the benchmark NUM times skipping the SDK (in yocto-benchmarkX)

```console
CONSOLE 0:      ./perfgraph
CONSOLE 1-NUM:  SKIP_SDK=1 ./run
```

- Copy the result

```console
$ mkdir test_results
$ scp root@P_ADDRESS:/home/user/yocto-benchmark*/results/*.txt test_results
```

- Repeat with more concurrent builds
- Destroy the server
