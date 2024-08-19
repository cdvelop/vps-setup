# vps-setup


scripts para configurar un VPS

- descargar repositorio e entrar a la carpeta
```bash
git clone https://github.com/cdvelop/vps-setup && cd vps-setup
```

- iniciar session ssh con el servidor remoto
```bash
ssh user@ip-vps
```
- copiar solo los script a tmp o una carpeta local
```bash
find  ../vps-setup -name "*.sh" -exec scp {} user@ip-vps:/tmp/ \;
```
- ejecutar script como root
```bash
./run-setup.sh
```

# probado en maquina virtual con debian 12