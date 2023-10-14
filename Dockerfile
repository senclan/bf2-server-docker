ARG BUILD=bf2hub

FROM rockylinux:9 AS build_nobf2hub

ARG BF2_INSTALL_SCRIPT="bf2-linuxded-1.5.3153.0-installer.sh"

COPY ${BF2_INSTALL_SCRIPT} /tmp/installer.sh

RUN chmod +x /tmp/installer.sh \
    && mkdir /bf2 \
    && /tmp/installer.sh --noexec --nox11 --target /bf2 \
    && rm -f /tmp/installer.sh \
    && ln -s /usr/lib64/libncurses.so.6 /usr/lib64/libncurses.so.5

FROM build_nobf2hub AS build_bf2hub

ARG BF2HUB="BF2Hub-Unranked-Linux-R3.tar.gz"

ONBUILD COPY ${BF2HUB} /tmp/bf2hub.tar.gz

ONBUILD RUN cd /bf2 \
    && tar -zxvf /tmp/bf2hub.tar.gz \
    && chmod +x /bf2/start_bf2hub.sh \
    && mv /bf2/start.sh /bf2/start_nobf2hub.sh \
    && ln -s /bf2/start_bf2hub.sh /bf2/start.sh \
    && rm -f /tmp/bf2hub.tar.gz

FROM build_${BUILD}

EXPOSE 80/tcp
EXPOSE 4711/tcp
EXPOSE 1500-4999/udp
EXPOSE 1024-1124/udp
EXPOSE 1024-1124/tcp
EXPOSE 16567/udp
EXPOSE 18000/udp
EXPOSE 18000/tcp
EXPOSE 18300/udp
EXPOSE 18300/tcp
EXPOSE 27900/udp
EXPOSE 27900/tcp
EXPOSE 27901/udp
EXPOSE 29900/udp
EXPOSE 29900/tcp
EXPOSE 55123-55125/udp

RUN ln -s /bf2/start.sh /bin/bf2server

WORKDIR /bf2

ENTRYPOINT ["/bin/bf2server"]
