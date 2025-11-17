# ---------- Stage 1: build ----------
FROM maven:3.8.8-eclipse-temurin-17 AS builder

WORKDIR /app

COPY pom.xml .
COPY mvnw .
COPY .mvn .mvn

RUN mvn -B -ntp dependency:go-offline

COPY src ./src

RUN if [ -x "./mvnw" ]; then ./mvnw -B -DskipTests package; else mvn -B -DskipTests package; fi

# ---------- Stage 2: runtime ----------
FROM eclipse-temurin:17-jre

WORKDIR /opt/app

COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java","-jar","/opt/app/app.jar"]
