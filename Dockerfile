FROM debian:12

# Configurar NGINX
#COPY nginx.conf /etc/nginx/nginx.conf


# Actualiza el índice de paquetes y actualiza todos los paquetes instalados como root
USER root
RUN apt-get update && apt-get upgrade

# Actualizar e instalar NGINX
RUN apt-get install -y nginx sudo nano  net-tools && \
    rm -rf /var/lib/apt/lists/*


# Crear un grupo y un usuario para NGINX
#RUN addgroup -S nginxgroup && adduser -S -G nginxgroup nginxuser
#RUN adduser --disabled-password nginxuser
#RUN usermod -aG nginxgroup nginxuser
RUN addgroup --system nginxgroup
RUN adduser --system --no-create-home --ingroup nginxgroup nginxuser
 



# Crear un archivo sudoers.d para el usuario nginxuser
RUN mkdir -p /etc/sudoers.d && \
    echo "nginxuser ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/nginxuser && \
    chmod 0440 /etc/sudoers.d/nginxuser

# Crear un archivo sudoers.d para el usuario nginxuser
RUN echo "nginxuser ALL=NOPASSWD: /usr/sbin/service nginx start, /usr/sbin/service nginx stop" > /etc/sudoers.d/nginxuser && \
    chmod 0440 /etc/sudoers.d/nginxuser


# Cambiar permisos de directorios necesarios para NGINX
RUN mkdir -p /var/www/html /var/log/nginx /var/run /var/cache/nginx /var/lib/nginx/tmp/client_body && \
    chown -R nginxuser:nginxgroup /var/www/html /var/log/nginx /var/run /var/cache/nginx /var/lib/nginx /var/log/nginx/ /run/ && \
    chmod -R 775 /var/lib/nginx/tmp /var/log/nginx/ /etc/nginx/
	
#RUN	 chown -R nginx:nginx /run/nginx/


# Modificar la configuración de NGINX para usar el nuevo usuario
RUN sed -i 's/user nginx;/user nginxuser;/g' /etc/nginx/nginx.conf

RUN chmod 777 /var/lib/nginx/

# Copiar la configuración predeterminada (opcional)
COPY default.conf /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/nginx.conf

RUN echo '<center><h5>MaAAAAAAAAAAA, estoy triunfando</center><h5>' > /var/www/html/index.html
 

# Exponer el puerto 8081
RUN sed -i 's/listen 8089;/listen 8081;/' /etc/nginx/conf.d/default.conf
 
EXPOSE 8081


# Cambiar al usuario no root
USER nginxuser

# Comando para iniciar NGINX
CMD ["nginx", "-g", "daemon off;"]