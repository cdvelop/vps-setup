#!/bin/bash
source functions.sh

# Instalar sudo si no está instalado
if ! command -v sudo &> /dev/null
then
    warning "sudo no está instalado. Instalando sudo..."
    apt-get update
    apt-get install -y sudo
else
    success "sudo ya está instalado."
fi