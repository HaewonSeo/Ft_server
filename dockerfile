FROM	debian:buster

LABEL	maintainer="haseo@student.42seoul.kr"

RUN		apt-get update && apt-get install -y \
		nginx \
		openssl \
		vim \
		php-fpm \
		mariadb-server \
		php-mysql \
		php-mbstring \
		wget

COPY	./srcs/default ./tmp
COPY	./srcs/wordpress-5.6.2.tar.gz ./tmp
COPY	./srcs/wp-config.php ./tmp
COPY	./srcs/phpMyAdmin-4.9.7-all-languages.tar.gz ./tmp
COPY	./srcs/config.inc.php ./tmp
COPY	./srcs/run.sh ./

EXPOSE	80 443

CMD		bash run.sh

