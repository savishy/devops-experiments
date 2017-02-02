# ref: https://github.com/spring-guides/gs-spring-boot-docker/blob/master/complete/src/main/docker/Dockerfile
FROM frolvlad/alpine-oraclejdk8:slim
VOLUME /app
ADD petclinic.jar /app/petclinic.jar
ENV JAVA_OPTS=""
ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -jar /app/petclinic.jar" ]
