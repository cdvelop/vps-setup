source functions.sh

info "ACTUALIZANDO ZONA HORARIA A $TIME_ZONE"

sudo timedatectl set-timezone $TIME_ZONE || exit_on_error "No se pudo establecer la zona horaria a $TIME_ZONE"

verify_timezone() {
    local expected_timezone="$TIME_ZONE"
    local current_timezone=$(timedatectl show --property=Timezone --value)

    if [ "$current_timezone" = "$expected_timezone" ]; then
        success "La zona horaria se ha cambiado correctamente"
    else
        error "La zona horaria no se ha cambiado. Zona horaria actual: $current_timezone"
        return 1
    fi
}

# Llamar a la función para verificar la zona horaria
verify_timezone