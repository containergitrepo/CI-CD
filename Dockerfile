FROM openjdk:8
EXPOSE 8080
COPY /var/lib/jenkins/workspace/CICD-DevSecOps-Pipeline/target/todoApp.jar /opt/containers/
WORKDIR /opt/containers/
ENTRYPOINT ["java","-jar","/todoApp.jar"]
