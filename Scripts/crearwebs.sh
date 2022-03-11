#!/bin/bash

echo "CREANDO CARPETAS"

sleep 3

mkdir creardockerimagenweb
mkdir creardockerimagenweb/contenido
touch creardockerimagenweb/Dockerfile

echo "QUE NOMBRE DE IMAGEN QUIERES??"
read nombreimagen

sleep 2

echo "COPIANDO WEB"
cp -r web/* creardockerimagenweb/contenido/

cd creardockerimagenweb/

codigo_web () {
  echo 'FROM nginx' >> Dockerfile
  echo 'RUN rm -drf /usr/share/nginx/html/*' >> Dockerfile
  echo 'COPY contenido/ /usr/share/nginx/html/' >> Dockerfile
}

sleep 2

construir_imagen () {
  docker build -t $nombreimagen .
}

codigo_web
construir_imagen

while true; do
    read -p "¿QUIERES CORRER EL CONTENEDOR? [Y/N]   " yn
    case $yn in
        [Yy]* ) echo "¿QUE PUERTO QUIERES?"
		read puertoseleccionado
		docker run -it -d -p $puertoseleccionado:80 $nombreimagen
		echo "CORRIENDO CONTENEDOR..."
		docker ps -a | grep $nombreimagen 
		break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
