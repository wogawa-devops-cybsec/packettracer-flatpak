#!/bin/bash

# Script de build automatizado para Packet Tracer Flatpak
# Uso: ./build.sh [opções]

set -e  # Para em caso de erro

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Função de ajuda
show_help() {
    cat << EOF
Uso: ./build.sh [OPÇÃO]

Opções:
  install       Constrói e instala localmente (padrão)
  bundle        Cria um arquivo .flatpak para distribuição
  repo          Cria um repositório OSTree
  clean         Limpa arquivos de build
  verify        Verifica se tudo está pronto para build
  help          Mostra esta mensagem

Exemplos:
  ./build.sh install    # Instala localmente
  ./build.sh bundle     # Cria PacketTracer.flatpak
  ./build.sh clean      # Limpa tudo

EOF
}

# Verifica pré-requisitos
check_prerequisites() {
    print_info "Verificando pré-requisitos..."
    
    # Verifica flatpak
    if ! command -v flatpak &> /dev/null; then
        print_error "flatpak não está instalado!"
        exit 1
    fi
    
    # Verifica flatpak-builder
    if ! command -v flatpak-builder &> /dev/null; then
        print_error "flatpak-builder não está instalado!"
        exit 1
    fi
    
    # Verifica runtime
    if ! flatpak info org.freedesktop.Platform//23.08 &> /dev/null; then
        print_warn "Runtime org.freedesktop.Platform//23.08 não encontrado"
        print_info "Instalando runtime..."
        flatpak install -y flathub org.freedesktop.Platform//23.08
        flatpak install -y flathub org.freedesktop.Sdk//23.08
    fi
    
    # Verifica arquivos do Packet Tracer
    if [ ! -f "packettracer/files/opt/pt/bin/PacketTracer" ]; then
        print_error "Arquivos do Packet Tracer não encontrados!"
        print_error "Por favor, extraia o Packet Tracer para: packettracer/files/"
        print_info "Estrutura esperada: packettracer/files/opt/pt/bin/PacketTracer"
        exit 1
    fi
    
    # Verifica arquivo ICU
    if [ ! -f "packettracer/files/opt/pt/bin/icudtl.dat" ]; then
        print_warn "Arquivo icudtl.dat não encontrado. Pode causar avisos."
    fi
    
    # Verifica arquivos de integração desktop
    if [ ! -f "com.cisco.PacketTracer.desktop" ]; then
        print_warn "Arquivo .desktop não encontrado. Atalho não será criado."
    fi
    
    if [ ! -f "com.cisco.PacketTracer.metainfo.xml" ]; then
        print_warn "Arquivo metainfo.xml não encontrado. Metadados não serão instalados."
    fi
    
    print_info "Todos os pré-requisitos OK!"
}

# Limpa arquivos de build
clean_build() {
    print_info "Limpando arquivos de build..."
    rm -rf build .flatpak-builder repo PacketTracer.flatpak
    print_info "Limpeza concluída!"
}

# Build e instalação local
build_install() {
    print_info "Construindo e instalando Packet Tracer Flatpak..."
    check_prerequisites
    
    flatpak-builder --user --install --force-clean build com.cisco.PacketTracer.json
    
    print_info "Instalação concluída!"
    print_info "Execute com: flatpak run com.cisco.PacketTracer"
}

# Cria bundle para distribuição
build_bundle() {
    print_info "Criando bundle de distribuição..."
    check_prerequisites
    
    # Cria repositório temporário
    flatpak-builder --repo=repo --force-clean build com.cisco.PacketTracer.json
    
    # Cria bundle
    flatpak build-bundle repo PacketTracer.flatpak com.cisco.PacketTracer
    
    BUNDLE_SIZE=$(du -h PacketTracer.flatpak | cut -f1)
    print_info "Bundle criado: PacketTracer.flatpak ($BUNDLE_SIZE)"
    print_info "Outros usuários podem instalar com:"
    print_info "  flatpak install PacketTracer.flatpak"
}

# Cria repositório OSTree
build_repo() {
    print_info "Criando repositório OSTree..."
    check_prerequisites
    
    flatpak-builder --repo=repo --force-clean build com.cisco.PacketTracer.json
    
    print_info "Repositório criado em: ./repo"
    print_info "Para adicionar o repositório:"
    print_info "  flatpak remote-add --user --no-gpg-verify pt-repo $(pwd)/repo"
    print_info "Para instalar:"
    print_info "  flatpak install pt-repo com.cisco.PacketTracer"
}

# Verifica configuração
verify_setup() {
    print_info "Verificando configuração..."
    check_prerequisites
    
    print_info "Estrutura de diretórios:"
    tree -L 4 packettracer/files/ 2>/dev/null || find packettracer/files/ -type f | head -20
    
    print_info "Arquivos importantes:"
    ls -lh packettracer/files/opt/pt/bin/PacketTracer
    ls -lh packettracer/files/opt/pt/bin/icudtl.dat 2>/dev/null || print_warn "icudtl.dat não encontrado"
    
    print_info "Configuração verificada!"
}

# Processa argumentos
case "${1:-install}" in
    install)
        build_install
        ;;
    bundle)
        build_bundle
        ;;
    repo)
        build_repo
        ;;
    clean)
        clean_build
        ;;
    verify)
        verify_setup
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        print_error "Opção inválida: $1"
        show_help
        exit 1
        ;;
esac
