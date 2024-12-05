source functions.sh

info "ACTUALIZANDO CONFIGURACIÓN SSH PUERTO: $NEW_SSH_PORT"

# Deshabilitar la autenticación por contraseña en SSH
disable_root_ssh() {
    info "Deshabilitando el acceso SSH con contraseña para root..."
    sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
    sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
    sudo systemctl restart ssh || exit_on_error "No se pudo reiniciar el servicio SSH"
    success "Acceso SSH con contraseña para root deshabilitado."
}

disable_root_ssh

# Comprobación final
SSH_CONFIG_CHECK=$(grep -E '^PasswordAuthentication no' /etc/ssh/sshd_config)
SSH_ROOT_LOGIN_CHECK=$(grep -E '^PermitRootLogin no' /etc/ssh/sshd_config)
ROOT_STATUS=$(sudo passwd -S root | awk '{print $2}')

if [[ "$SSH_CONFIG_CHECK" == "PasswordAuthentication no" ]] && [[ "$SSH_ROOT_LOGIN_CHECK" == "PermitRootLogin no" ]]; then
   
    PARAM=""
    if [ "$NEW_SSH_PORT" != "22" ]; then
        PARAM=" -p $NEW_SSH_PORT"
        info "cambiando puerto ssh 22 a NEW_SSH_PORT"
        # sudo sed -i 's/^#Port 22$/Port NEW_SSH_PORT/' /etc/ssh/sshd_config || exit_on_error "No se pudo cambiar el puerto SSH"
    
        # Verificar si el nuevo puerto ya está en uso
        if ss -tulpn | grep ":$NEW_SSH_PORT" > /dev/null; then
        error "El puerto $NEW_SSH_PORT ya está en uso. Elige otro puerto."
        exit 1
        fi

        # Detener el servicio SSH
        systemctl stop ssh

        # Editar el archivo de configuración de SSH
        sed -i "s/Port 22/Port $NEW_SSH_PORT/g" /etc/ssh/sshd_config || exit_on_error "No se pudo editar el archivo de configuración de SSH"
    
        # Reiniciar el servicio SSH para aplicar los cambios
        info "Reiniciando el servicio SSH"
        sudo systemctl restart ssh || exit_on_error "No se pudo reiniciar el servicio SSH"
    fi
   
   
    
    success "El acceso SSH para root ha sido deshabilitado y la autenticación por contraseña ha sido desactivada."
    success "Configuración SSH completada exitosamente."


    info "Recuerda para conectarte a SSH ahora es:" 
    echo -e "ssh$PARAM $NEW_USER@$(hostname -I)"
 
    
    exit 0
else
    exit_on_error "Hubo un problema durante la configuración. Por favor, revisa los pasos manualmente."
fi