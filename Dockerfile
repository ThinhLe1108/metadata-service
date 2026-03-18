# ---------- BUILD STAGE ----------
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# copy all project
COPY . .

# build jar
RUN mvn clean package -DskipTests

# ---------- RUNTIME STAGE ----------
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# copy jar from build stage
COPY --from=build /app/target/*.jar app.jar

# Render provides PORT env
ENV PORT=8763
EXPOSE 8763

ENTRYPOINT ["sh", "-c", "java -jar app.jar --server.port=${PORT}"]