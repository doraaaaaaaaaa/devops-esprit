# Use an appropriate base image
FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    tar \
    curl \
    unzip

# Install OpenJDK 22
RUN wget https://download.java.net/java/early_access/jdk22/35/GPL/openjdk-22_linux-x64_bin.tar.gz && \
    tar -xzf openjdk-22_linux-x64_bin.tar.gz && \
    mv jdk-22 /opt/jdk && \
    ln -s /opt/jdk/bin/java /usr/bin/java && \
    ln -s /opt/jdk/bin/javac /usr/bin/javac

# Set JAVA_HOME environment variable
ENV JAVA_HOME=/opt/jdk

# Install Maven
RUN wget https://www.apache.org/dyn/closer.cgi?path=maven/maven-3/3.8.5/binaries/apache-maven-3.8.5-bin.tar.gz -O /tmp/maven.tar.gz && \
    tar -xzf /tmp/maven.tar.gz -C /opt && \
    ln -s /opt/apache-maven-3.8.5/bin/mvn /usr/bin/mvn

# Set Maven environment variables
ENV M2_HOME=/opt/apache-maven-3.8.5
ENV MAVEN_HOME=/opt/apache-maven-3.8.5
