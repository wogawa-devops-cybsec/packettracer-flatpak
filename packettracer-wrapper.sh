#!/bin/bash

# Define o diretório base do Packet Tracer
PT_DIR="/app/pt"
PT_BIN="$PT_DIR/bin"

# Configura variáveis de ambiente necessárias
export LD_LIBRARY_PATH="$PT_BIN:$LD_LIBRARY_PATH"
export QT_PLUGIN_PATH="$PT_BIN"
export QT_QPA_PLATFORM_PLUGIN_PATH="$PT_BIN/platforms"
export QTWEBENGINEPROCESS_PATH="$PT_BIN/QtWebEngineProcess"
export QTWEBENGINE_RESOURCES_PATH="$PT_BIN"
export QT_XKB_CONFIG_ROOT="/usr/share/X11/xkb"

# Desabilita sandbox do Chromium
export QTWEBENGINE_DISABLE_SANDBOX=1

# Verifica se o arquivo ICU existe
if [ -f "$PT_BIN/icudtl.dat" ]; then
    echo "ICU data file found: $PT_BIN/icudtl.dat"
else
    echo "WARNING: ICU data file not found at $PT_BIN/icudtl.dat"
    ls -la "$PT_BIN/" | grep -i icu
fi

# Muda para o diretório do Packet Tracer
cd "$PT_DIR" || exit 1

# Debug: mostra as variáveis configuradas
echo "=== Packet Tracer Debug Info ==="
echo "Working directory: $(pwd)"
echo "PT_BIN: $PT_BIN"
echo "LD_LIBRARY_PATH: $LD_LIBRARY_PATH"
echo "================================"

# Tenta executar o PacketTracer
if [ -x "$PT_BIN/PacketTracer" ]; then
    echo "Launching PacketTracer..."
    exec "$PT_BIN/PacketTracer" "$@"
else
    echo "ERROR: PacketTracer binary not found or not executable at $PT_BIN/PacketTracer"
    ls -la "$PT_BIN/PacketTracer"
    exit 1
fi
