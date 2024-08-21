#!/bin/bash
source functions.sh

# exigir 2 parámetros de los contrario mostrar mensaje de error
if [ -z "$1" ] || [ -z "$2" ]; then
    error "Se requieren 2 parámetros nombre de usuario y contraseña"
    exit 1
fi

source env.sh

# Lista de scripts a ejecutar
scripts=(
    "sudo-install.sh" 
    "time-setup.sh" 
    "user-setup.sh" 
    "update-sys.sh"
)

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
        echo -e "------------------------------------------------\n"
    fi
}

# Recorrer la lista de scripts y ejecutarlos en orden
for script in "${scripts[@]}"; do
    run_scripts "$script"
done

success "Todos los scripts se ejecutaron correctamente."


