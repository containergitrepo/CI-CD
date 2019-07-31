FROM openjdk:8
EXPOSE 8080
ADD target/todoApp.jar todoApp.jar
ENTRYPOINT ["java","-jar","/todoApp.jar"]