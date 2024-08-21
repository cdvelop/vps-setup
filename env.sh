

# crear variable de entorno NEW_USER
export NEW_USER="devuser"
# setear la variable de entorno NEW_USER si $1 es distinto de ""
if [ -n "$1" ]; then
    export NEW_USER="$1"
fi


# *** VARIABLES USO LOCAL DE DESARROLLO **

# Nombre de la máquina virtual
export VM_NAME="Debian12"
# Nombre de la instantánea a restaurar
export SNAPSHOT_NAME="update-sh"
# Nombre de la Instantánea a eliminar
export SNAPSHOT_NAME_DELETE="config-user"



