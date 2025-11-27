# Lightweight Java Runtime (JRE) only — ~110MB
FROM eclipse-temurin:21-jre-alpine

# Copy the compiled JAR
COPY target/*.jar /app.jar

# Expose the port used by your Spring Boot app
EXPOSE 8080

# Start the application
CMD ["java", "-jar", "/app.jar"]
