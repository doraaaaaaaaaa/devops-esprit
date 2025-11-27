# Étape 1 : Choisir l'image de base
FROM alpine:latest

# Étape 2 : Installer OpenJDK 21 et Maven
RUN apk add --no-cache openjdk21 maven bash

# Étape 3 : Créer un dossier pour ton application
WORKDIR /app

# Étape 4 : Copier les fichiers de ton projet dans l'image
COPY . /app

# Étape 5 : Builder l'application avec Maven
RUN mvn clean package -DskipTests

# Étape 6 : Exposer un port (80 ici, si ton app l'utilise)
EXPOSE 80

# Étape 7 : Lancer l'application
# Remplace 'monapp.jar' par le nom réel de ton jar généré
CMD ["java", "-jar", "target/monapp.jar"]
