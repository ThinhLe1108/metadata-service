FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copy project files and build without tests to keep image small and fast to build
COPY pom.xml ./
COPY src ./src
RUN mvn -B -DskipTests package

FROM eclipse-temurin:17-jre-jammy AS runtime
WORKDIR /app

COPY --from=build /app/target/*.jar /app/app.jar

ENV PORT=8763
EXPOSE 8763

# Render sets PORT; use it to bind the server
ENTRYPOINT ["sh", "-c", "java -jar /app/app.jar --server.port=${PORT:-8763}"]
