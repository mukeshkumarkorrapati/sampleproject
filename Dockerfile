FROM maven:3.9.9-eclipse-temurin-17 AS build

RUN apt-get update 
WORKDIR /apps
COPY   pom.xml .
RUN mvn -B -q -DskipTests dependency:go-offline
COPY /src ./src
RUN mvn clean package -DskipTests

FROM eclipse-temurin:17-jre-alpine
WORKDIR /apps
COPY --from=build /apps/target/*.jar app.jar
EXPOSE 8080
CMD ["-jar","app.jar"]
ENTRYPOINT [ "java" ]