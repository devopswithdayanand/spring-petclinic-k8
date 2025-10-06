# Select base image
FROM maven:3.8.5-openjdk-17
# Create folder /app
WORKDIR /app
# Copy src folder to /app/src
COPY ./src /app/src
# Copy pom.xml to container
COPY ./pom.xml /app/pom.xml
# RUN maven command to create package
RUN mvn clean package
# Rename jar file
RUN mv /app/target/*jar /app/spring.jar
# RUN jar file
CMD java -jar /app/spring.jar
# to expose port number
EXPOSE 8080