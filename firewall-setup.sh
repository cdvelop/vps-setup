source functions.sh

info "ACTUALIZANDO FIREWALL nftables"

# Verificar y desinstalar otros firewalls o usados en debian 12
firewalls=("ufw" "firewalld" "iptables")

for fw in "${firewalls[@]}"
do
  # Verificar si el firewall está instalado
  if command -v $fw &> /dev/null; then
    info "Se ha detectado $fw. Desinstalando..."

    # Deshabilitar y eliminar el firewall
    case $fw in
      "ufw")
        if ufw status | grep 'Status: active'; then
          ufw disable || exit_on_error "No se pudo deshabilitar ufw"
        fi
        ;;
      "firewalld")
        if systemctl status firewalld | grep 'active (running)'; then
          systemctl stop firewalld || exit_on_error "No se pudo detener firewalld"
          systemctl disable firewalld || exit_on_error "No se pudo deshabilitar firewalld"
        fi
        ;;
      "iptables")
        # Eliminar los paquetes iptables e ip6tables
        apt-get remove -y iptables ip6tables || exit_on_error "No se pudo desinstalar iptables e ip6tables"
        ;;
    esac

    # Eliminar el firewall
    apt-get remove -y $fw || exit_on_error "No se pudo desinstalar $fw"
    apt-get purge -y $fw || exit_on_error "No se pudo eliminar $fw"
    success "$fw ha sido desinstalado."
  else
    info "$fw no está instalado."
  fi
done

# Función para verificar e instalar nftables
install_nftables() {
    # Verificar si nftables está instalado
    if ! command -v nft &> /dev/null; then
        info "nftables no está instalado. Procediendo a la instalación..."

        # Instalar nftables
        sudo apt-get install -y nftables || exit_on_error "No se pudo instalar nftables"

        # Verificar si nftables está instalado correctamente
        command -v nft &> /dev/null || exit_on_error "No se pudo verificar la instalación de nftables"
    fi
}
# Llamar a la función para instalar nftables
install_nftables


# Eliminar dependencias no utilizadas
apt-get autoremove -y || exit_on_error "No se pudo eliminar dependencias no utilizadas"


# Función para crear tabla y cadena de nftables y hacerlas persistentes
setup_nftables() {
    # Nombre de la tabla y cadena
    local table="inet filter"
    local chain="input"
    
    # Verificar si la tabla 'filter' ya existe
    if ! sudo nft list table $table &>/dev/null; then
        echo "Creando tabla '$table'..."
        sudo nft create table $table || exit_on_error "al crear la tabla '$table'."
    else
        echo "La tabla '$table' ya existe."
    fi

    # Verificar si la cadena 'input' ya existe
    if ! sudo nft list chain $table $chain &>/dev/null; then
        echo "Creando cadena '$chain' en la tabla '$table'..."
        sudo nft create chain $table $chain { type filter hook input priority 0\; } || exit_on_error "al crear la cadena '$chain'."
    else
        echo "La cadena '$chain' ya existe."
    fi
 
}

setup_nftables

# Función para abrir un puerto con nftables
open_port() {
    local port="$1"
    local protocol="${2:-tcp}"
    
    if [ -z "$port" ]; then
        error "Por favor, especifica un puerto."
        return 1
    fi

    nft add rule inet filter input $protocol dport $port accept || exit_on_error "al abrir el puerto $port ($protocol)."
    
    success "Puerto $port ($protocol) abierto correctamente."
}


# Función para cerrar un puerto con nftables
close_port() {
    local port=$1
    local protocol=${2:-tcp}

    # Cerrar el puerto especificado
    sudo nft delete rule inet filter input tcp dport $port || exit_on_error "al cerrar el puerto $port ($protocol)."
    sudo nft delete rule inet filter input udp dport $port || exit_on_error "al cerrar el puerto $port ($protocol)."

    success "El puerto $port ($protocol) se ha cerrado correctamente."
}

# Función para cerrar todos los puertos excepto los permitidos
close_all_port_except() {
    # Recibir los puertos a mantener abiertos como argumentos
    local -a allowed_ports=("$@")

    # Obtener la lista de reglas actuales
    echo "Lista completa de reglas:"
    sudo nft list ruleset

    # Filtrar las reglas de la cadena 'input' en la tabla 'filter' usando un bucle para manejar la salida multilineal
    echo "Filtrando reglas de 'inet filter input'..."
    sudo nft list chain inet filter input | while read -r line; do
        # Verificar si la línea contiene una regla de puerto
        if echo "$line" | grep -q "dport"; then
            # Extraer el puerto de la regla
            port=$(echo "$line" | awk '{for(i=1;i<=NF;i++) if($i=="dport") print $(i+1)}')
            
            # Verificar si el puerto está en la lista de permitidos
            if ! [[ " ${allowed_ports[@]} " =~ " $port " ]]; then
                echo "Eliminando regla: $line"
                # Eliminar la regla completa
                sudo nft delete rule inet filter input handle $(echo "$line" | awk '{print $NF}') 
            fi
        fi
    done


    # Abrir los puertos permitidos
    for port in "${allowed_ports[@]}"; do
        open_port $port
    done
}


# Mantener abiertos los puertos 443, 2222, 8080 etc
close_all_port_except 443 $NEW_SSH_PORT


# Guardar la configuración actual en un archivo
info "Guardando configuración en /etc/nftables.conf..."
sudo nft list ruleset > /etc/nftables.conf || exit_on_error "al guardar la configuración."

# Mostrar la configuración actual
echo "Configuración actual archivo /etc/nftables.conf:"
cat /etc/nftables.conf

# sudo systemctl enable nftables.service || exit_on_error "al habilitar nftables."
# sudo systemctl restart nftables.service || exit_on_error "al reiniciar nftables."

success "Configuración de firewall nftables completada."

