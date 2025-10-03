[![GitHub](https://img.shields.io/github/license/wogawa-devops-cybsec/packettracer-flatpak)](LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/wogawa-devops-cybsec/packettracer-flatpak)](https://github.com/wogawa-devops-cybsec/packettracer-flatpak/stargazers)

# Cisco Packet Tracer - Flatpak

Empacotamento Flatpak não-oficial do Cisco Packet Tracer para distribuições Linux.

## ⚠️ Aviso Legal

Este repositório **NÃO** distribui os binários do Cisco Packet Tracer. Você deve baixar o Packet Tracer diretamente do site oficial da Cisco. Este projeto apenas fornece os arquivos de configuração do Flatpak para facilitar a instalação em sistemas Linux.

## 📋 Pré-requisitos

1. **Flatpak** instalado no seu sistema
   ```bash
   # Debian/Ubuntu
   sudo apt install flatpak
   
   # Fedora
   sudo dnf install flatpak
   
   # Arch Linux
   sudo pacman -S flatpak
   ```

2. **Flatpak Builder**
   ```bash
   sudo apt install flatpak-builder  # Debian/Ubuntu
   sudo dnf install flatpak-builder  # Fedora
   sudo pacman -S flatpak-builder    # Arch Linux
   ```

3. **Runtime Freedesktop 23.08**
   ```bash
   flatpak install flathub org.freedesktop.Platform//23.08
   flatpak install flathub org.freedesktop.Sdk//23.08
   ```

4. **Cisco Packet Tracer** (baixe do site oficial da Cisco)
   - Acesse: https://www.netacad.com/courses/packet-tracer
   - Faça login (ou crie uma conta gratuita)
   - Baixe a versão Linux (.tar.gz)

## 🚀 Instalação

### Passo 1: Clone este repositório

```bash
git clone https://github.com/seu-usuario/packettracer-flatpak.git
cd packettracer-flatpak
```

### Passo 2: Extraia o Packet Tracer

```bash
# Crie a estrutura de diretórios
mkdir -p packettracer/files

# Extraia o arquivo baixado da Cisco para packettracer/files/
tar -xzf CiscoPacketTracer_*.tar.gz -C packettracer/files/

# Verifique se a estrutura está correta
ls packettracer/files/opt/pt/bin/PacketTracer
```

### Passo 3: Construa o Flatpak

```bash
# Instalação local
flatpak-builder --user --install --force-clean build com.cisco.PacketTracer.json

# OU crie um bundle para distribuir
flatpak-builder --repo=repo --force-clean build com.cisco.PacketTracer.json
flatpak build-bundle repo PacketTracer.flatpak com.cisco.PacketTracer
```

## 💻 Uso

```bash
# Execute o Packet Tracer pelo terminal
flatpak run com.cisco.PacketTracer

# Ou encontre "Cisco Packet Tracer" no menu de aplicativos do seu sistema
# O atalho será criado automaticamente na categoria Educação
```

### Atalhos e Integração Desktop

Após a instalação, o Packet Tracer estará disponível:
- **Menu de Aplicativos**: Procure por "Cisco Packet Tracer" na categoria Educação
- **Ícone**: Usa o ícone oficial do Packet Tracer
- **Associação de Arquivos**: Abre automaticamente arquivos `.pkt`, `.pka` e `.pkz`
- **Lançador**: Clique com botão direito em arquivos PT para abrir

## 🐛 Solução de Problemas

### Erro: "Couldn't mmap icu data file"
Este é um aviso comum e geralmente não impede o funcionamento. Se o app não abrir:

```bash
# Verifique os logs
flatpak run com.cisco.PacketTracer 2>&1

# Verifique se o arquivo ICU está presente
flatpak run --command=sh com.cisco.PacketTracer -c "ls -la /app/pt/bin/icudtl.dat"
```

### App não abre / Tela preta
1. Certifique-se de ter drivers gráficos atualizados
2. Tente executar com:
   ```bash
   flatpak run --nosocket=wayland com.cisco.PacketTracer
   ```

### Problemas de permissão
O Flatpak tem acesso a:
- Rede
- Documentos e Downloads
- Áudio
- Aceleração gráfica

Para dar acesso adicional:
```bash
flatpak override --user --filesystem=home com.cisco.PacketTracer
```

## 📁 Estrutura do Projeto

```
packettracer-flatpak/
├── com.cisco.PacketTracer.json         # Manifesto do Flatpak
├── com.cisco.PacketTracer.desktop      # Arquivo de atalho desktop
├── com.cisco.PacketTracer.metainfo.xml # Metadados AppStream
├── packettracer-wrapper.sh             # Script wrapper
├── build.sh                            # Script de build automatizado
├── README.md                           # Este arquivo
├── LICENSE                             # Licença
└── packettracer/
    └── files/                          # Extraia o PT aqui
        └── opt/
            └── pt/
                ├── bin/
                │   ├── PacketTracer
                │   ├── icudtl.dat
                │   └── ...
                └── art/
                    └── app.png         # Ícone usado automaticamente
```

## 🤝 Contribuindo

Contribuições são bem-vindas! Sinta-se à vontade para:
- Reportar bugs
- Sugerir melhorias
- Enviar pull requests

## 📝 Licença

Os arquivos de configuração deste repositório estão sob a licença MIT.

**IMPORTANTE**: O Cisco Packet Tracer é propriedade da Cisco Systems, Inc. e está sujeito aos seus próprios termos de licença.

## 🔗 Links Úteis

- [Site Oficial do Packet Tracer](https://www.netacad.com/courses/packet-tracer)
- [Documentação do Flatpak](https://docs.flatpak.org/)
- [Cisco Networking Academy](https://www.netacad.com/)

## ✨ Créditos
Idealizado por Wander Alves Ogawa

Mantido pela comunidade para facilitar o uso do Packet Tracer no Linux.

---
<div align="center">
  💚 Made with love in Brazil 💛 🇧🇷
</div>
**Nota**: Este é um projeto não-oficial e não é afiliado, endossado ou patrocinado pela Cisco Systems, Inc.
