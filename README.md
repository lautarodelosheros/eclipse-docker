# Docker container with Eclipse Parallel version and Photran

## Build and Run

### Linux

To build the image:

```bash
$ docker-compose build
```

To run the container:

```bash
$ docker-compose up -d
```

### MacOS

* Install [XQuartz](https://www.xquartz.org/) on your Mac.
* Start XQuartz, go to Preferences -> Security, and make sure "Allow connections from network clients" is enabled.
* Restart XQuartz.

Run on the terminal:

```bash
$ xhost +localhost
```

*XQuartz needs to be running everytime you want to run the container.*

To build the image

```bash
$ docker-compose build
```

To run the container:

```bash
$ DISPLAY=${HOSTNAME}:0.0 docker-compose up -d
```
