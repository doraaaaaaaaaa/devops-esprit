# Base image avec Java 21
FROM openjdk:21-jdk

# Répertoire de travail dans le conteneur
WORKDIR /app

# Copier le JAR compilé depuis target/
COPY target/*.jar app.jar

# Commande pour lancer l'application
CMD ["java", "-jar", "app.jar"]
