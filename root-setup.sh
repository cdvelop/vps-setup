source functions.sh

# Bloquear la cuenta root
info "CONFIGURACIÓN DE CUENTA ROOT"
sudo passwd -l root || exit_on_error "No se pudo bloquear la cuenta root"
    