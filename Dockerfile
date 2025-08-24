FROM openjdk:25-ea-21-jdk

WORKDIR /app

COPY target/*.jar app.jar

CMD java -jar app.jar

EXPOSE 8080
