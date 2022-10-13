# Yocto Benchmark

The objective of this project is to benchmark hardware for Yocto Build
Machines.

The intent is to provide a base for comparison and information to allow
more robust choices when choosing hardware for a build machine.

For now, the main focus is to grasp the impact that the number of CPU
cores and the amount of RAM available have in the build time.

To achieve that we gather hardware and system information and time the
builds of the default core-image-minimal and its SDK from the kirkstone
release.

## Step 1 - Clone the repository

```console
$ git clone https://github.com/djboni/yocto-benchmark
```

## Step 2 - Install the dependencies

Installer for Ubuntu:

```console
$ ./install
```

## Step 3 - Restart and run the benchmark

Restart the computer before running the benchmark, specially if you are
rerunning it for any reason. Restarting the computer will make sure
there is the most RAM available for the build and, at the same time,
there will be no previous file system caching at the start of the build.

```console
$ ./run
```

## Step 4 - Commit and share your results

Commit the result file and share it with a merge request or opening an
issue in our [GitHub page](https://github.com/djboni/yocto-benchmark).

```console
$ git add --all
$ git commit -m "Result description"
```

## Step 5 - Clean

Clean the build to save disk space.

```console
$ ./clean
```

## References

- [Yocto Project Quick Build](https://docs.yoctoproject.org/brief-yoctoprojectqs/index.html)
