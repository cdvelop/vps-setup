#!/bin/bash
source messages.sh

warning "ACTUALIZANDO SISTEMA"


sudo apt update -y && sudo apt upgrade -y
# Comentario en español: Este comando elimina los paquetes que ya no son necesarios
sudo apt-get autoremove -y

# Comentario en español: Este comando limpia la caché de paquetes descargados
sudo apt-get clean
exit 0