
FROM openjdk:22-jdk

RUN apt-get update && \
    apt-get install -y maven

WORKDIR /app

COPY . /app

RUN mvn clean install

CMD ["java", "-jar", "target/myapp.jar"]
