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
