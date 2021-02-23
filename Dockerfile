# This Docker file builds a basic minecraft server
# directly from the default minecraft server from Mojang
#
FROM openjdk:11 AS build

#-------------------------------------
ENV SERVER_MESSAGE="Minecraft Paper"
ENV VERSION_ID=485
ENV VERSION_NAME=1.15.5
ENV MC_SERVER_URL=https://papermc.io/api/v2/projects/paper/versions/1.16.5/builds/485/downloads/paper-1.16.5-485.jar
ENV DATAPACK_ADVANCE=https://download851.mediafire.com/bcvtfcarjo8g/t4ayv8ku84mhbph/BlazeandCave%5C%27s+Advancements+Pack+1.11.5.zip
#-------------------------------------


ENV VERSION="${VERSION_NAME} (${VERSION_ID})"
MAINTAINER jhe
RUN apt-get update
RUN apt-get install -y default-jdk
RUN apt-get install -y wget unzip

#RUN addgroup --gid 1234 minecraft
#RUN adduser --disabled-password --home=/data --uid 1234 --gid 1234 --gecos "minecraft user" minecraft
#USER minecraft

#RUN mkdir minecraft
RUN mkdir /tmp/mc-paper 
RUN mkdir /tmp/mc-paper/world && mkdir /tmp/mc-paper/world/datapacks

# Download zip server file from https://www.curseforge.com/minecraft/modpacks/ftb-presents-skyfactory-3/files
#COPY FTB_Presents_SkyFactory_3_Server_${VERSION}.zip /tmp/mc-paper/FTBServer.zip

RUN cd /tmp/mc-paper &&\
  wget -c ${MC_SERVER_URL} -O ServerInstall-paper.jar &&\
  wget -c ${DATAPACK_ADVANCE} -O world/datapacks/dp_advance.zip &&\
  unzip world/datapacks/dp_advance.zip -d world/datapacks && rm world/datapacks/dp_advance.zip 
  #&& \

  #cp /FTB_Presents_SkyFactory_3_Server_3_0_21.zip FTBSkyfactoryServer.zip &&\
  #chmod +x ./ServerInstall-paper.jar && \
  #./ServerInstall-paper.jar --auto && \
  #rm ServerInstall-paper.jar  
  #bash -x Install.sh
# && \
#  chown -R minecraft /tmp/mc-paper

#USER minecraft

COPY Dynmap-3.1-beta7-spigot.jar /tmp/mc-paper/plugins/Dynmap-3.1-beta7-spigot.jar


EXPOSE 25565
EXPOSE 8123
EXPOSE 25577

ADD start.sh /start

#VOLUME /data
ADD server.properties /tmp/server.properties
#WORKDIR /data

CMD /start

ENV MOTD ${SERVER_MESSAGE} ${VERSION} Server Powered by (jhe) Docker
ENV LEVEL world
ENV JVM_OPTS -Xms2G -Xmx2G

ENV ENABLE_RCON=true RCON_PORT=25577 RCON_PASSWORD=jheminecraft
ENV SEED=572779209

RUN echo "eula=true" > eula.txt

#CMD java -Xms2048m -Xmx2048m -jar /tmp/mc-paper/FTBserver-*.jar nogui

#RUN cd /tmp/mc-paper && bash -x ServerStart.sh
