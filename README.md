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

The building process will download around 5.5 GB of source code and it
will use about 65 GB more to build the image and SDK.

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

# Results

![Build time vs Cores-GHz and RAM - 3D](images/figure1.svg)

![Build time vs Cores-GHz and RAM - 2D](images/figure2.svg)

| Machine | Cores | RAM GB | SSD/HD      | Time | Description                                                          |
| ------- | ----- | ------ | ----------- | ---- | -------------------------------------------------------------------- |
| 1       | 4     | 16     | HD          | 5h52 | Desktop, Intel(R) Core(TM) i5-3330 CPU @ 3.00GHz                     |
| 3.1     | 4     | 8      | USB-SSD (a) | 7h00 | Laptop Dell Vostro 5480, Intel(R) Core(TM) i5-5200U CPU @ 2.20GHz    |
| 2       | 4     | 16     | SSD         | 7h14 | Laptop Dell Inspiron 5140, Intel(R) Core(TM) i7-4510U CPU @ 2.00GHz  |
| 3.2     | 4     | 8      | USB-HD (b)  | 7h19 | Laptop Dell Vostro 5480, Intel(R) Core(TM) i5-5200U CPU @ 2.20GHz    |
| 4       | 4     | 8      | HD          | 7h24 | Laptop Dell Latitude E5440, Intel(R) Core(TM) i5-4200U CPU @ 1.60GHz |

Notes:

- (a) USB SSD.
- (b) USB HD (same adapter as (a)).
