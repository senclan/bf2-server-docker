# BF2 server docker builder

This is a simple script to build a contained docker image of the linux bf2
server files.

## Prerequisites

You must obtained the bf2 server install script first. By default the script
looks for `bf2-linuxded-1.5.3153.0-installer.sh` within the script directory.

You can point to a different file by using the `-i PATH` flag

## Usage

```
$ ./build.sh -h
USAGE: ./build.sh [OPTION]...

Options:
  -h        Prints this message
  -i PATH   Path to installer [default: bf2-linuxded-1.5.3153.0-installer.sh]
  -t tag    Tag for docker image [default: bf2/server:latest]
```

## Ports

The bf2 server docs specify all the ports below should be forwarded

```
TCP     80
TCP     4711
UDP/TCP 1024-1124
UDP     1500-4999
UDP     17567
UDP/TCP 18000
UDP/TCP 18300
UDP/TCP 27900
UDP     27901
UDP/TCP 29900
UDP     55123-55125
```

However starting up a fresh server, netstat reports the following ports

```
tcp        0      0 0.0.0.0:4711            0.0.0.0:*               LISTEN      1/bf2
udp        0      0 0.0.0.0:55124           0.0.0.0:*                           1/bf2
udp        0      0 0.0.0.0:55125           0.0.0.0:*                           1/bf2
udp        0      0 0.0.0.0:16567           0.0.0.0:*                           1/bf2
udp        0      0 0.0.0.0:29900           0.0.0.0:*                           1/bf2
```

## Example

For the most basic setup, you only need to expose 2 ports `16567` and `29900`.

* `16567` Is needed for game play. (Required)
* `29900` Is needed to see the game in the server browser. (Optional)

```
docker run -p 16567:16567/udp -p 29900:29900/udp --rm -it bf2/server
```
