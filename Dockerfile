########### STAGE 1 : BUILD MAVEN ###########
FROM maven:3.9.6-eclipse-temurin-21 AS builder

WORKDIR /app

# Copier uniquement le pom.xml d'abord (pour cache)
COPY pom.xml .

# Télécharger les dépendances Maven AVANT d'ajouter le code
RUN mvn dependency:resolve

# Ensuite copier le reste du code
COPY . .

# Builder l'application
RUN mvn clean package -DskipTests



########### STAGE 2 : IMAGE FINALE LÉGÈRE ###########
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# Copier uniquement le JAR depuis le stage de build
COPY --from=builder /app/target/*.jar app.jar

# Exposer le port (modifie-le selon ton app: 8080 pour Spring Boot)
EXPOSE 8080

# Commande de démarrage
CMD ["java", "-jar", "app.jar"]
