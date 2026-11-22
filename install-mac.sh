#!/bin/bash
# Fast Edit — instalação pelo Terminal (sem o aviso do Gatekeeper) · feito por @odalluz
set -e
URL="https://github.com/thauanfelippepro-ux/fast-edit/raw/main/download/Fast-Edit-Plugin.zip"
EXT="$HOME/Library/Application Support/Adobe/CEP/extensions"
DEST="$EXT/com.fastedit.suite"
echo "Fast Edit: baixando..."
TMP="$(mktemp -d)"
curl -fsSL "$URL" -o "$TMP/fe.zip"
unzip -q "$TMP/fe.zip" -d "$TMP"
if pgrep -f "Adobe Premiere Pro" >/dev/null 2>&1; then
  echo "Feche o Adobe Premiere Pro e rode o comando de novo."; exit 1
fi
mkdir -p "$EXT"
for d in "$EXT"/*/; do
  n="$(basename "$d")"; [ "$n" = "com.fastedit.suite" ] && continue
  if [ -f "$d/CSXS/manifest.xml" ] && grep -qiE "Fast ?Edit" "$d/CSXS/manifest.xml"; then rm -rf "$d"; fi
done
rm -rf "$DEST"; mkdir -p "$DEST"
cp -R "$TMP/com.fastedit.suite/." "$DEST/"
xattr -dr com.apple.quarantine "$DEST" 2>/dev/null || true
for v in 6 7 8 9 10 11 12 13 14 15 16; do defaults write "com.adobe.CSXS.$v" PlayerDebugMode 1; done
rm -rf "$TMP"
echo "Pronto! Abra o Premiere e vá em Janela > Extensões > Fast Edit."
