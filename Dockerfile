FROM --platform=linux/amd64 maven:3.9.2-eclipse-temurin-17 AS builder

WORKDIR /spring-ex

COPY pom.xml .

RUN mvn dependency:go-offline -B

COPY src ./src

RUN mvn clean package -DskipTests

FROM --platform=linux/amd64 eclipse-temurin:17-jre-jammy AS runner

WORKDIR /app

COPY --from=builder /spring-ex/target/spring-ex2-0.0.1-SNAPSHOT.jar ./app.jar

EXPOSE 8181

ENTRYPOINT ["java", "-jar", "app.jar"]