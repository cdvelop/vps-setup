#!/bin/bash

# restaurar maquina virtual
./vbox-setup.sh

# cambia la ip de la maquina virtual
IP_VM="192.168.0.21"

NEW_USER="juanito"

# copiar solo los script a tmp o una carpeta en la maquina remota 
find  ../vps-setup -name "*.sh" -exec scp {} root@$IP_VM:/tmp/ \;


# ejecutar script en la maquina remota a través de ssh
# ssh root@$IP_VM "cd /tmp && bash run-setup.sh"

ssh root@$IP_VM "cd /tmp && bash run-setup.sh $NEW_USER"


# iniciar session ssh con el servidor remoto
# ssh root@$IP_VM

# entrar a la carpeta tmp
# cd /tmp

# ejecutar script como root
# ./run-setup.sh