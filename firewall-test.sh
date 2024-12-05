#!/bin/bash
# enviar archivo firewall-setup por scp a la máquina virtual ala carpeta tmp y ejecutar el script
IP_VM=192.168.0.21
# copiar archivo a la máquina virtual
scp firewall-setup.sh firewall-nftables.sh root@$IP_VM:/tmp

# ejecutar script en la máquina virtual
# ssh root@$IP_VM "cd /tmp && bash firewall-setup.sh"
