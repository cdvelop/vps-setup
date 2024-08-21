#!/bin/bash
# Ejemplo de Script Bash para Automatizar Tareas en VirtualBox

# Nombre de la máquina virtual
VM_NAME="Debian12"

# Nombre de la instantánea a restaurar
SNAPSHOT_NAME="update-sh"

# Nombre de la Instantánea a eliminar
SNAPSHOT_NAME_DELETE="config-user"

# Función para comprobar el estado de la máquina virtual y apagarla si está encendida
check_and_shutdown_vm() {
    if VBoxManage list runningvms | grep -q "$VM_NAME"; then
        echo "La máquina virtual $VM_NAME está encendida. Apagando..."
        VBoxManage controlvm "$VM_NAME" acpipowerbutton

        # Bucle para verificar el estado de la VM hasta que se apague
        while VBoxManage list runningvms | grep -q "$VM_NAME"; do
            echo "Esperando apagado de la VM..."
            sleep 1  # Esperar 2 segundos antes de verificar nuevamente
        done

        echo "La máquina virtual $VM_NAME se ha apagado correctamente."
    else
        echo "La máquina virtual $VM_NAME ya está apagada."
    fi
}

# Llamar a la función
check_and_shutdown_vm

# Función para eliminar una instantánea si existe
delete_snapshot_if_exists() {
    local vm_name="$1"
    local snapshot_name="$2"
    
    if VBoxManage snapshot "$vm_name" list | grep -q "$snapshot_name"; then
        echo "Eliminando instantánea $snapshot_name..."
        VBoxManage snapshot "$vm_name" delete "$snapshot_name"
    else
        echo "La instantánea $snapshot_name no existe. No se requiere eliminación."
    fi
}

# Llamar a la función para eliminar la instantánea
delete_snapshot_if_exists "$VM_NAME" "$SNAPSHOT_NAME_DELETE"

# Restaurar la instantánea
echo "Restaurando a la instantánea $SNAPSHOT_NAME..."
VBoxManage snapshot "$VM_NAME" restore "$SNAPSHOT_NAME"
           
           
sleep 1  # Esperar 2 segundos antes de iniciar la máquina virtual

# Iniciar la máquina virtual
echo "Iniciando $VM_NAME..."
VBoxManage startvm "$VM_NAME" --type gui

echo "Operaciones completadas."

exit 0
