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

# Función para salir del script en caso de error
exit_on_error() {
    error "$1"
    exit 1
}