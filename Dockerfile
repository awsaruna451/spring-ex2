# =========================
# Stage 1: Build Stage
# =========================
FROM maven:3.9.2-eclipse-temurin-17 AS build
WORKDIR /spring-ex

# Copy pom and download dependencies first (cached)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Build the JAR
RUN mvn clean package -DskipTests

# =========================
# Stage 2: Runtime Stage
# =========================
FROM eclipse-temurin:17-jdk-alpine AS runtime
WORKDIR /app

# Copy only the Spring Boot fat JAR from build stage
COPY --from=build /spring-ex/target/spring-ex2-0.0.1-SNAPSHOT.jar app.jar

# Expose default Spring Boot port
EXPOSE 8181

# Use non-root user
USER 1001:1001

# Run the application
ENTRYPOINT ["java", "-jar", "/app/app.jar"]