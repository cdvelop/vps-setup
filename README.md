# vps-setup


scripts para configurar un VPS

- descargar repositorio y entrar a la carpeta
```bash
git clone https://github.com/cdvelop/vps-setup && cd vps-setup
```

```bash
#!/bin/bash

# preparar maquina virtual
# ./vbox-setup.sh

IP_VM="192.168.0.21"


# copiar solo los script a tmp o una carpeta en la maquina remota 
find  ../vps-setup -name "*.sh" -exec scp {} root@$IP_VM:/tmp/ \;

# iniciar session ssh con el servidor remoto
# ssh root@$IP_VM

# entrar a la carpeta tmp
# cd /tmp

# ejecutar script como root
# ./run-setup.sh
```

# probado en maquina virtual con debian 12