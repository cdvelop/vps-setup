#!/bin/bash
# Ejemplo de Script Bash para Automatizar Tareas en VirtualBox
source functions.sh
source env.sh



# Función para comprobar el estado de la máquina virtual y apagarla si está encendida
check_shutdown_vm() {
    if VBoxManage list runningvms | grep -q "$VM_NAME"; then
        info "La máquina virtual $VM_NAME está encendida. apagando..."
        VBoxManage controlvm "$VM_NAME" acpipowerbutton

        # Bucle para verificar el estado de la VM hasta que se apague
        echo "Esperando apagado de la VM..."
        while VBoxManage list runningvms | grep -q "$VM_NAME"; do
            sleep 1  # Esperar n segundos antes de verificar nuevamente
        done

        success "La máquina virtual $VM_NAME apagada."
    # else
    fi
}

check_shutdown_vm

# Función para restaurar la instantánea sin apagar la máquina virtual
restore_snapshot() {
    
    # if VBoxManage snapshot "$VM_NAME" list | grep -q "$SNAPSHOT_NAME_DELETE"; then
        # info "Eliminando instantánea $SNAPSHOT_NAME_DELETE..."
        # VBoxManage snapshot "$VM_NAME" delete "$SNAPSHOT_NAME_DELETE"
    # else
        # echo "La instantánea $SNAPSHOT_NAME_DELETE no existe. No se requiere eliminación."
    # fi

    # Restaurar la instantánea
    info "Restaurando a la instantánea $SNAPSHOT_NAME..."
    VBoxManage snapshot "$VM_NAME" restore "$SNAPSHOT_NAME"
}

# sleep 1  # Esperar n segundos después de apagar   
restore_snapshot       
sleep 1  # Esperar n segundos después de restaurar    
           
# Iniciar la máquina virtual sin interfaz gráfica
info "Iniciando $VM_NAME en modo headless..."
VBoxManage startvm "$VM_NAME" --type headless

# VBoxManage startvm "$VM_NAME" --type gui

success "maquina virtual $VM_NAME Iniciada."
echo -e "------------------------------------------------\n"
exit 0
