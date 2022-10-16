# Yocto Benchmark Server Test

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
$ apt update && apt upgrade -y && apt install git -y
$ adduser user
$ adduser user sudo
$ sudo -iu user
```

- Clone the repository
- Change directory
- Install the dependencies (use user's password)
- Run the benchmark
- Clean

```console
$ git clone https://github.com/djboni/yocto-benchmark
$ cd yocto-benchmark
$ ./install
$ clear
$ ./run
```

- Copy the result

```console
$ scp root@IP_ADDRESS:/home/user/yocto-benchmark/results/TIMESTAMP.txt OUTPUT.txt
```

- Destroy the server
- Repeat
