#
# Build stage
#
FROM maven:3.6.0-jdk-11-slim AS build
COPY src/foo /home/app/src/foo
COPY resources /home/app/resources
COPY pom.xml /home/app
RUN mvn -f /home/app/pom.xml clean package assembly:assembly -DdescriptorId=jar-with-dependencies

#
# Package stage
#
FROM openjdk:11-jre-slim
COPY --from=build /home/app/target/app-1.0-SNAPSHOT-jar-with-dependencies.jar /usr/local/lib/app.jar
EXPOSE 8080
ENTRYPOINT ["java","-cp","/usr/local/lib/app.jar", "foo.Foo"]