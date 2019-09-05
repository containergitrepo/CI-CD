FROM openjdk:8
EXPOSE 8080
ADD target/todoApp.war todoApp.war
ENTRYPOINT ["java","-jar","/todoApp.war"]