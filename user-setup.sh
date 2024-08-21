#!/bin/bash
source env.sh

# Crear un nuevo usuario no privilegiado en modo desatendido sin contraseña
warning "Creando el nuevo usuario: $NEW_USER"
sudo useradd -m -s /bin/bash $NEW_USER || exit_on_error "No se pudo crear el usuario $NEW_USER"

# Explicación de las opciones:
# -m: Crea el directorio home del usuario
# -s /bin/bash: Establece la shell por defecto del usuario como bash

# Agregar el nuevo usuario al grupo sudo para permisos de administrador
warning "Agregando $NEW_USER al grupo sudo"
sudo usermod -aG sudo $NEW_USER || exit_on_error "No se pudo agregar $NEW_USER al grupo sudo"

# Deshabilitar la autenticación por contraseña en SSH
disable_root_ssh() {
    warning "Deshabilitando el acceso SSH con contraseña para root..."
    sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
    sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
    sudo systemctl restart ssh || exit_on_error "No se pudo reiniciar el servicio SSH"
    success "Acceso SSH con contraseña para root deshabilitado."
}

# antes de deshabilitar root ssh hay que copiar las llaves publicas de root al usuario nuevo
warning "Copiando las llaves publicas de root a $NEW_USER"
sudo cp -r ~/.ssh /home/$NEW_USER/ || exit_on_error "No se pudo copiar las llaves publicas de root a $NEW_USER"
chown -R $NEW_USER:$NEW_USER /home/$NEW_USER/.ssh || exit_on_error "No se pudo cambiar los permisos de las llaves publicas de $NEW_USER"
chmod 700 /home/$NEW_USER/.ssh || exit_on_error "No se pudo cambiar los permisos de la carpeta ssh de $NEW_USER"
chmod 600 /home/$NEW_USER/.ssh/authorized_keys || exit_on_error "No se pudo cambiar los permisos de las llaves autorizadas de $NEW_USER"
success "llaves ssh publicas copiada de root a $NEW_USER"


disable_root_ssh

# Comprobación final
warning "Comprobando la configuración..."
SSH_CONFIG_CHECK=$(grep -E '^PasswordAuthentication no' /etc/ssh/sshd_config)
SSH_ROOT_LOGIN_CHECK=$(grep -E '^PermitRootLogin no' /etc/ssh/sshd_config)
ROOT_STATUS=$(sudo passwd -S root | awk '{print $2}')

if [[ "$SSH_CONFIG_CHECK" == "PasswordAuthentication no" ]] && [[ "$SSH_ROOT_LOGIN_CHECK" == "PermitRootLogin no" ]]; then
    # Reiniciar el servicio SSH para aplicar los cambios
    warning "Reiniciando el servicio SSH"
    sudo systemctl restart ssh || exit_on_error "No se pudo reiniciar el servicio SSH"

    # Bloquear la cuenta root
    warning "Bloqueando la cuenta root"
    sudo passwd -l root || exit_on_error "No se pudo bloquear la cuenta root"
    
    success "El usuario $NEW_USER se ha creado y agregado al grupo sudo."
    success "El acceso SSH para root ha sido deshabilitado y la autenticación por contraseña ha sido desactivada."
    success "Configuración SSH completada exitosamente."
    warning "Recuerda para conectarte a SSH ahora es:" 
    echo -e "ssh $NEW_USER@$(hostname -I)"
    warning "CAMBIANDO AL NUEVO USUARIO"
    sudo -u $NEW_USER bash << EOF
    cd ~
    # Aquí puedes agregar comandos adicionales que se ejecutarán como el nuevo usuario
EOF
    
    exit 0
else
    exit_on_error "Hubo un problema durante la configuración. Por favor, revisa los pasos manualmente."
fi