#!/bin/bash

source env.sh

# setear la variable de entorno NEW_USER="testing" si $1 es distinto de ""
if [ -n "$1" ]; then
    NEW_USER="$1"
fi

# Lista de scripts a ejecutar
scripts=("sudo-install.sh" "user-setup.sh" "update-sys.sh")

# Función para ejecutar un script y verificar su éxito
run_scripts() {
    local script=$1
    warning "Ejecutando $script..."
    
    # Ejecutar el script
    bash "$script"
    
    # Comprobar si la ejecución fue exitosa
    if [ $? -ne 0 ]; then
        error "al ejecutar $script. Terminando ejecución."
        exit 1
    else
        success "$script ejecutado exitosamente."
    fi
}

# Recorrer la lista de scripts y ejecutarlos en orden
for script in "${scripts[@]}"; do
    run_scripts "$script"
done

success "Todos los scripts se ejecutaron correctamente."


