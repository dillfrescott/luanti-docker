FROM ubuntu:24.04

RUN apt update && apt upgrade -y

RUN apt install -y sudo git g++ make libc6-dev cmake libpng-dev \
libjpeg-dev libgl1-mesa-dev libsqlite3-dev libogg-dev libvorbis-dev \
libopenal-dev libcurl4-gnutls-dev libfreetype6-dev zlib1g-dev \
libgmp-dev libjsoncpp-dev libzstd-dev libluajit-5.1-dev gettext libsdl2-dev

RUN git clone https://github.com/minetest/minetest /luanti

WORKDIR /luanti

# Version 5.10.0
RUN git checkout 568f7a8e8fb457c7b7bcfd3211c7f3f0481ed2e7

RUN cmake . -DRUN_IN_PLACE=TRUE

RUN make -j$(nproc)

RUN chmod +x /luanti/bin/luanti

RUN mkdir -p /luanti/games

WORKDIR /luanti/games

RUN git clone https://github.com/VoxeLibre/VoxeLibre

RUN echo "name = Dill" >> VoxeLibre/minetest.conf

RUN echo "default_password = <password>" >> VoxeLibre/minetest.conf

ENTRYPOINT ["sudo", "-u", "root", "/luanti/bin/luanti", "--server", "--gameid", "VoxeLibre", "--world", "/luanti/worlds/world"]
