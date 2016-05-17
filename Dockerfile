FROM debian:latest
MAINTAINER Francis Chuang <francis.chuang@boostport.com>

ENV HBASE_VERSION=1.1.5 HBASE_MINOR_VERSION=1.1 PHOENIX_VERSION=4.7.0 JAVA_HOME=/usr/lib/jvm/java-8-oracle

RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections \
 && echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee /etc/apt/sources.list.d/webupd8team-java.list \
 && echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list \
 && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 \
 && apt-get update \
 && apt-get install xmlstarlet python oracle-java8-installer -y \
 && mkdir -p /opt/hbase \
 && mkdir -p /opt/phoenix \
 && mkdir -p /opt/phoenix-server \
 && wget -q -O - http://apache.mirror.digitalpacific.com.au/hbase/$HBASE_VERSION/hbase-$HBASE_VERSION-bin.tar.gz | tar -xzf - -C /opt/hbase  --strip-components 1 \
 && wget -q -O - http://apache.uberglobalmirror.com/phoenix/phoenix-$PHOENIX_VERSION-HBase-$HBASE_MINOR_VERSION/bin/phoenix-$PHOENIX_VERSION-HBase-$HBASE_MINOR_VERSION-bin.tar.gz | tar -xzf - -C /opt/phoenix --strip-components 1 \
 && mv /opt/phoenix/phoenix-$PHOENIX_VERSION-HBase-$HBASE_MINOR_VERSION-server.jar /opt/hbase/lib/ \
 && cp /opt/phoenix/phoenix-$PHOENIX_VERSION-HBase-$HBASE_MINOR_VERSION-client.jar /opt/hbase/lib/ \
 && mv /opt/phoenix/bin/tephra /opt/hbase/bin/tephra \
 && mv /opt/phoenix/bin/tephra-env.sh /opt/hbase/bin/tephra-env.sh \
 && mv /opt/phoenix/phoenix-server-$PHOENIX_VERSION-HBase-$HBASE_MINOR_VERSION-runnable.jar /opt/phoenix-server/ \
 && mv /opt/phoenix/phoenix-$PHOENIX_VERSION-HBase-$HBASE_MINOR_VERSION-client.jar /opt/phoenix-server/ \
 && mv /opt/phoenix/bin /opt/phoenix-server/bin \
 && rm -rf /opt/phoenix

EXPOSE 8765

ADD start-hbase-phoenix.sh /start-hbase-phoenix.sh

CMD ["./start-hbase-phoenix.sh"]