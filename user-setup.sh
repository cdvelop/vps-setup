#!/bin/bash
source functions.sh

info "ACTUALIZANDO CONFIGURACIÓN A USUARIO $NEW_USER"

# Crear un nuevo usuario no privilegiado en modo desatendido sin contraseña
sudo useradd -m -s /bin/bash $NEW_USER || exit_on_error "No se pudo crear el usuario $NEW_USER"
# -m: Crea el directorio home del usuario
# -s /bin/bash: Establece la shell por defecto del usuario como bash

# Establecer la contraseña del nuevo usuario
echo "$NEW_USER:$NEW_USER_PASSWORD" | sudo chpasswd || exit_on_error "No se pudo establecer la contraseña para $NEW_USER"
# eliminar la variable de entorno NEW_USER_PASSWORD
unset NEW_USER_PASSWORD

# Agregar el nuevo usuario al grupo sudo para permisos de administrador
info "Agregando $NEW_USER al grupo sudo"
sudo usermod -aG sudo $NEW_USER || exit_on_error "No se pudo agregar $NEW_USER al grupo sudo"


# antes de deshabilitar root ssh hay que copiar las llaves publicas de root al usuario nuevo
info "Copiando llaves publicas de root a $NEW_USER"
sudo cp -r ~/.ssh /home/$NEW_USER/ || exit_on_error "No se pudo copiar las llaves publicas de root a $NEW_USER"
chown -R $NEW_USER:$NEW_USER /home/$NEW_USER/.ssh || exit_on_error "No se pudo cambiar los permisos de las llaves publicas de $NEW_USER"
chmod 700 /home/$NEW_USER/.ssh || exit_on_error "No se pudo cambiar los permisos de la carpeta ssh de $NEW_USER"
chmod 600 /home/$NEW_USER/.ssh/authorized_keys || exit_on_error "No se pudo cambiar los permisos de las llaves autorizadas de $NEW_USER"
# success "llaves ssh publicas copiada de root a $NEW_USER"


success "El usuario $NEW_USER se ha creado y agregado al grupo sudo."