# Base image avec JDK 21
FROM eclipse-temurin:21-jdk

# Répertoire de travail dans le conteneur
WORKDIR /app

# Copier le projet dans le conteneur
COPY . /app

# Build Maven (sans exécuter les tests)
RUN ./mvnw clean package -DskipTests

# Lancer l'application
CMD ["java", "-jar", "target/myapp.jar"]
