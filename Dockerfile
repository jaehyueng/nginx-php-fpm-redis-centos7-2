FROM centos:centos7
MAINTAINER ¡÷¿Á«¸<jaehyueng@wellbia.com>

RUN yum -y update; yum clean all

RUN yum -y install php-fpm php-gd php-cli php-xml php-devel git gcc-c++ make; yum clean all

RUN sed -i 's/;date.timezone =/date.timezone = Asia\/\Seoul/' /etc/php.ini
RUN sed -i 's/daemonize = yes/daemonize = no/' /etc/php-fpm.conf
RUN sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php.ini
RUN sed -i 's/listen = 127.0.0.1:9000/listen = 0.0.0.0:9000/' /etc/php-fpm.d/www.conf
RUN sed -i 's/listen.allowed_clients = 127.0.0.1/;listen.allowed_clients = 127.0.0.1/' /etc/php-fpm.d/www.conf
RUN sed -i 's/;catch_workers_output = yes/catch_workers_output = yes/' /etc/php-fpm.d/www.conf
RUN sed -i 's/php_admin_value\[error_log\]/;php_admin_value[error_log]/' /etc/php-fpm.d/www.conf
RUN sed -i 's/php_admin_flag\[log_errors\]/;php_admin_flag[log_errors]/' /etc/php-fpm.d/www.conf
RUN sed -i 's/;security.limit_extensions = .php .php3 .php4 .php5/security.limit_extensions = .cgi/' /etc/php-fpm.d/www.conf



RUN cd /usr/local/src && git clone https://github.com/phpredis/phpredis && cd phpredis && /usr/bin/phpize && ./configure --with-php-config=/usr/bin/php-config && make && make install
RUN echo "extension=/usr/lib64/php/modules/igbinary.so" > /etc/php.ini
RUN echo "extension=/usr/lib64/php/modules/redis.so" > /etc/php.ini

RUN mkdir -p /var/www/html
VOLUME ["/var/www/html"]

EXPOSE 9000

ENTRYPOINT ["/usr/sbin/php-fpm", "-F"]
