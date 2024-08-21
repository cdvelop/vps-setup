#!/bin/bash

# restaurar maquina virtual
./vbox-setup.sh

# cambia la ip de la maquina remota o local virtual
IP_VM="192.168.0.21"


NEW_USER="juanito"

# copiar solo los script a tmp o una carpeta en la maquina remota 
find  ../vps-setup -name "*.sh" -exec scp {} root@$IP_VM:/tmp/ \;


# ejecutar script en la maquina remota a través de ssh
# primer argumento es el nombre de usuario
ssh root@$IP_VM "cd /tmp && bash run-setup.sh $NEW_USER"


