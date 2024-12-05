#!/bin/bash
source functions.sh

# Comprobar parámetros $# que contiene el número de argumentos pasados al script
if [ $# -ne 3 ]; then
    echo "Error: Se requieren 3 parámetros: nombre de usuario y contraseña, puerto ssh."
    exit 1
fi

source env.sh

# Lista de scripts a ejecutar
scripts=(
    # "update-sys.sh"
    # "sudo-install.sh" 
    # "time-setup.sh" 
    # "user-setup.sh"
    # "ssh-setup.sh"
    # "root-setup.sh" 
    "firewall-setup.sh"
)

# Función para ejecutar un script y verificar su éxito
run_scripts() {
    local script=$1
    
    # Ejecutar el script
    bash "$script"
    
    # Comprobar si la ejecución fue exitosa
    if [ $? -ne 0 ]; then
        error "al ejecutar $script. Terminando ejecución."
        exit 1
    else
        echo "------------------------------------------------"
    fi
}

# Recorrer la lista de scripts y ejecutarlos en orden
for script in "${scripts[@]}"; do
    run_scripts "$script"
done

success "Todos los scripts se ejecutaron correctamente."


