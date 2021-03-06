FROM maven:3-jdk-8-slim AS builder

WORKDIR /usr/src/app

COPY . .

RUN set -ex; \
	mvn \
		clean \
		package \
		-DskipTests=true \
		-Dmaven.javadoc.skip=true \
		-B \
		-V \
	; \
	ls -al target; \
	mv target/*.jar target/app.jar; \
	ls -al target

FROM openjdk:8-jre-alpine

# Expected JAR file path as argument
ARG JAR_FILE=/usr/src/app/target/app.jar

# Setup application folders and tools
# install dependencies
RUN set -ex; \
	mkdir -p /srv/app; \
	chmod 755 /srv/app; \
	mkdir -p /srv/app/data; \
	mkdir -p /srv/app/logs; \
	mkdir -p /srv/app/keys; \
	mkdir -p /srv/app/config; \
	apk add --update \
		libpq \
		mariadb-common \
		openssh-keygen \
		openssl \
		zlib \
	; \
	rm -rf /var/cache/apk/*

VOLUME /srv/app/config /srv/app/keys /srv/app/logs /srv/app/data

WORKDIR /srv/app/

EXPOSE 8080 8443

ENV \
	# Application configuration
	APP_TITLE=App \
	APP_CONFIG=/srv/app/config/application.properties \
	APP_SERVER_CONTEXT_PATH=/api \
	APP_SERVER_PORT=8080 \
	APP_MAX_FILE_SIZE=20MB \
	APP_MAX_REQUEST_SIZE=20MB \
	APP_DOMAIN_NAME=example.com \
	APP_ADMIN_PASSWORD=youshouldoverwritethiswithsomethingelse \
	APP_SIGNING_KEY=youshouldoverwritethiswithsomethingelse \
	APP_SIGNING_KEYPAIR_PASS='' \
	APP_SIGNING_KEYPAIR_ALIAS=spring_rest_api_starter_key \
	APP_DEMO_DATA=false \
	# Database configuration
	DB_DIALECT='' \
	DB_STORAGE='' \
	DB_DRIVER='' \
	DB_PLATFORM='h2' \
	DB_HOST='' \
	DB_PORT='' \
	DB_NAME='spring_rest_api_starter' \
	DB_USER='spring_rest_api_starter' \
	DB_PASSWORD='spring_rest_api_starter_password' \
	# Mail configuration
	MAIL_HOST= \
	MAIL_PORT= \
	MAIL_PROTOCOL= \
	MAIL_USER= \
	MAIL_PASSWORD= \
	MAIL_SSL=false \
	MAIL_STARTTLS=false

# Copy entrypoint and expected JAR file in container
COPY docker-entrypoint.sh /entrypoint.sh

COPY --from=builder ${JAR_FILE} /srv/app/app.jar

RUN set -ex; \
	chmod 755 /entrypoint.sh /srv/app/app.jar

ENTRYPOINT ["sh", "/entrypoint.sh"]
CMD ["java", "-jar", "app.jar"]

