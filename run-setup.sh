#!/bin/bash

# Lista de scripts a ejecutar
scripts=("update.sh")

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


# Función para mostrar un mensaje de éxito
success() {
  echo -e "\033[0;32m$1\033[0m" # color verde
}

# Función para mostrar un mensaje de advertencia
warning() {
  echo -e "\033[0;33m$1\033[0m" # color amarillo
}

# Función para mostrar un mensaje de error
error() {
  echo -e "\033[0;31mError: $1 $2\033[0m" #color rojo
}