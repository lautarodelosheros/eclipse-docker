# Docker container with Eclipse for Photran

## Installation type

To change the installation type edit the "ECLIPSE_TYPE" field on the environment file.

| Installation type | ECLIPSE_TYPE |
| ------------- | ------------- |
| Eclipse Committers | committers |
| Scientific Computing | parallel |

## Build and Run

### Linux

To build the image:

```bash
docker-compose build
```

To run the container:

```bash
docker-compose up -d
```

#### Common issues on Linux
Most errors during setting up the container can often be fixed by setting:
* The correct date, time and time zone on host machine
* The mirror server for distribution updates to a 'Main server' because your default server may not be up-to-date with packages needed by this image
* The `network_mode` to `host`


### MacOS

* Install [XQuartz](https://www.xquartz.org/) on your Mac.
* Start XQuartz, go to Preferences -> Security, and make sure "Allow connections from network clients" is enabled.
* Restart XQuartz.

Run on the terminal:

```bash
xhost +
```

*XQuartz needs to be running everytime you want to run the container.*

To build the image:

```bash
docker-compose build
```

To run the container:

```bash
DISPLAY=${HOSTNAME}:0.0 docker-compose up -d
```
### Windows

* Install [VcXsrv](https://sourceforge.net/projects/vcxsrv/) on your Windows.
* Run `Xlaunch`, let all defaults in the configuration wizard but check `Disable access control`.
* Save the configuration and finish.
* VcXsrv X Server will start.

To build the image:

```bash
docker-compose build
```

To run the container find your IP address (for example 192.168.0.101), launch an elevated PowerShell prompt and :

```bash
docker run -ti --rm -e DISPLAY=192.168.0.101:0.0 --name photran-eclipse photran-eclipse-image
```

## Eclipse Indigo

To run the Eclipse Indigo version included in the container follow the next steps:

* While the container is running:
    * Linux / MacOS => run on the terminal:
        ```bash
        docker exec -it photran-eclipse bash
        ```

    * Windows => Launch an new elevated PowerShell prompt and run:
    
        ```bash
        docker exec -it photran-eclipse bash
        ``` 
 * Now in the terminal inside the container run:
 ```bash
cd /opt/eclipse-indigo-rcp-64/
./eclipse
 ```

## Photran 7 workspace compilation

* Select `/opt/photran7` as workspace and clic `Ok`

* Disable automatic build by going to Project -> Build Automatically

* Go to Windows -> Preferences -> Plug-in Development -> API Baselines
    * Clic on `Add Baseline...` button
    * Clic on `Reset` button
    * Type `Default` in name field
    * Clic on `Finish` button
    * Answer `Yes` to rebuild all projects
    * For each project that has errors right clic on it an Build Project
