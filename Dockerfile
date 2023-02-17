# Use a minimalistic version of the OpenJDK 11 JRE as the base image
FROM openjdk:11-jre-slim

# Set the working directory to /app
WORKDIR /app

# Copy the JAR file to the container
ARG JAR_FILE

COPY target/${JAR_FILE} app.jar

EXPOSE 8089

# Run the JAR file when the container starts
CMD ["java","-jar", "app.jar"]
