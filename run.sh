#!/bin/bash

#a2enmod rewrite

source /etc/apache2/envvars
exec apache2 -D FOREGROUND
