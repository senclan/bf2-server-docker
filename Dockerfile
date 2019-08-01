From centos:7
COPY ./files /bf2
WORKDIR /bf2
ENTRYPOINT /bf2/start.sh
