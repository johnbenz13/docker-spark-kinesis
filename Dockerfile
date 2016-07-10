### Based on official java openjdk-8-jdk
FROM java:openjdk-8-jdk
MAINTAINER Jonathan Bensaid <john@bensaidj.com>

ENV SCALA_VERSION 2.10.4
ENV SBT_VERSION 0.13.9
ENV SPARK_VERSION 1.6.0

### Install Scala
RUN \
  cd /root && \
  curl -o scala-$SCALA_VERSION.tgz http://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz && \
  tar -xf scala-$SCALA_VERSION.tgz && \
  rm scala-$SCALA_VERSION.tgz && \
  echo >> /root/.bashrc && \
  echo 'export PATH=~/scala-$SCALA_VERSION/bin:$PATH' >> /root/.bashrc

### Install sbt
RUN \
  curl -L -o sbt-$SBT_VERSION.deb https://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
  dpkg -i sbt-$SBT_VERSION.deb && \
  rm sbt-$SBT_VERSION.deb && \
  apt-get update && \
  apt-get install sbt

### Install Spark
RUN \
    curl -o spark-$SPARK_VERSION.tgz http://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION.tgz && \
    tar -xf spark-$SPARK_VERSION.tgz && \
    rm spark-$SPARK_VERSION.tgz && \
    cd spark-$SPARK_VERSION && \
    ./dev/change-scala-version.sh 2.10

RUN cd spark-$SPARK_VERSION && \
  ./build/mvn -Pkinesis-asl -Pyarn -Phadoop-2.6 -Dscala-2.10 -DskipTests clean install

RUN echo 'export PATH=/spark-$SPARK_VERSION/bin:$PATH' >> /root/.bashrc

### Set working directory to root
WORKDIR /root

### Command
CMD bash
