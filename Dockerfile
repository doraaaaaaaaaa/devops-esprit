# Utiliser une image légère Java JRE 21
FROM eclipse-temurin:21-jre-alpine

# Définir le répertoire de travail dans le conteneur
WORKDIR /app

# Copier le JAR compilé
COPY target/*.jar app.jar

# Exposer le port de l'application
EXPOSE 8080

# Démarrer l'application
ENTRYPOINT ["java", "-jar", "app.jar"]
