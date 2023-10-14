# BF2 server docker builder

This is a simple script to build a contained docker image of the linux bf2 server files.

## Building container

You must obtained the bf2 server install script first and place it in the root directory.
You can override the default script name of `bf2-linuxded-1.5.3153.0-installer.sh` by setting the build argument `BF2_INSTALL_SCRIPT`.

By default it will install bf2hub as well which requires downloading bf2hub's server files from [bf2hub.com/home/serversetup.php](https://www.bf2hub.com/home/serversetup.php).
These files must also be plased in the root directory.
You can override the default filename of `BF2Hub-Unranked-Linux-R3.tar.gz` by setting the build argument `BF2HUB`.

Once the necessary dependencies are available, simply run

```shell
docker build -t bf2/server:latest .
```

To build without bf2hub run

```shell
docker build -t bf2/server:latest --build-arg BUILD=nobf2hub .
```

## Ports

The bf2 server docs specify all the ports below should be forwarded

| Protocol | Port(s)     | Details     |
|----------|-------------|-------------|
| TCP      | 80          |             | 
| TCP      | 4711        | RCON        | 
| UDP/TCP  | 1024-1124   |             | 
| UDP      | 1500-4999   |             |
| UDP      | 16567       | Server Port | 
| UDP/TCP  | 18000       |             | 
| UDP/TCP  | 18300       |             | 
| UDP/TCP  | 27900       |             | 
| UDP      | 27901       |             | 
| UDP/TCP  | 29900       | GameSpy     | 
| UDP      | 55123-55125 | VOIP        |


However starting up a fresh server, netstat reports the following ports

```
tcp        0      0 0.0.0.0:4711            0.0.0.0:*               LISTEN      1/bf2
udp        0      0 0.0.0.0:55124           0.0.0.0:*                           1/bf2
udp        0      0 0.0.0.0:55125           0.0.0.0:*                           1/bf2
udp        0      0 0.0.0.0:16567           0.0.0.0:*                           1/bf2
udp        0      0 0.0.0.0:29900           0.0.0.0:*                           1/bf2
```

## Running

For the most basic setup, you only need to expose 2 ports `16567` and `29900`.

* `16567` Is needed for game play.
* `29900` Is needed to see the game in the server browser.

```
docker run -p 16567:16567/udp -p 29900:29900/udp --rm -it bf2/server:latest
```

See the example [compose.yaml](./compose.yaml) for deploying with docker compose.

You can add additional arguments for the bf2 binary at the end of the docker command.
You can run `docker run --rm bf2/server:latest +help` to see configurable options.

```
docker run \
  --rm \
  --tty \
  -p 16567:16567/udp \
  -p 29900:29900/udp \
  -v ./examples/maplist_bf2.con:/maplist.con \
  -v ./examples/serversettings.con:/serversettings.con \
  bf2/server:latest +config /serversettings.con +mapList /maplist.con
```

Here I've added the [`maplist_bf2.con`](./examples/maplist_bf2.con) and [`serversettings.con`](./examples/serversettings.con) files and added the corresponding args at the end of the command.

Alternatively most options are configurable with environment variables with `BF2_$OPTION_NAME`.

For example `BF2_CONFIG=/serversettings.con` and `BF2_MAPLIST=/serversettings.con`.
