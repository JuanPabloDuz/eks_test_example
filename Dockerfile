FROM httpd
COPY apt update 
RUN apt install apache2 --yes
RUN apt install apache2-utils --yes
RUN apt clean 
EXPOSE 80
CMD [“apache2ctl”, “-D”, “FOREGROUND”]
