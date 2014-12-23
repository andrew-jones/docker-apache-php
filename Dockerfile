FROM ubuntu:trusty
MAINTAINER Andrew Jones <andrew.jones0@gmail.com>

# Install base packages
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get -yq install \
        curl \
        apache2 \
        libapache2-mod-php5 \
        php5-pgsql \
        php5-gd \
        php5-curl \
        php5-intl \
        php-pear \
        php-apc

RUN rm -rf /var/lib/apt/lists/*
RUN sed -i "s/variables_order.*/variables_order = \"EGPCS\"/g" /etc/php5/apache2/php.ini
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add image configuration and scripts
ADD run.sh /run.sh
RUN chmod 755 /*.sh

# Configure /app folder
RUN mkdir -p /app && rm -fr /var/www && ln -s /app /var/www
ADD index.php /app/index.php
ADD app.conf /src/app.conf

ADD ./app.conf /etc/apache2/sites-available/app.conf
RUN rm /etc/apache2/sites-enabled/*
RUN ln -s /etc/apache2/sites-available/app.conf /etc/apache2/sites-enabled/app.conf

EXPOSE 80
WORKDIR /app
CMD ["/run.sh"]
