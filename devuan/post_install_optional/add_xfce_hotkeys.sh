#!/bin/sh
echo "Agregando atajos de teclado personalizados en XFCE..."

# Agregar función para evitar duplicados
add_hotkey() {
  NAME="$1"
  COMMAND="$2"
  KEYS="$3"

  # Establecer la acción (nombre y comando)
  xfconf-query -c xfce4-keyboard-shortcuts -p "/commands/custom/$NAME" --create --type string --set "$COMMAND"

  # Asociar las teclas al nombre anterior
  xfconf-query -c xfce4-keyboard-shortcuts -p "/commands/custom/$KEYS" --create --type string --set "$COMMAND"
}

# Alt+Shift+L → bloquear pantalla con slock
add_hotkey "LockWithSlock" "slock" "<Alt><Shift>l"

# Alt+Shift+Return → abrir xfce4-terminal
add_hotkey "Terminal" "xfce4-terminal" "<Alt><Shift>Return"

# Alt+Shift+F12 → tomar screenshot con scrot
add_hotkey "ScreenshotScrot" "scrot ~/Pictures/Screenshots/screenshot-%Y%m%d-%H%M%S.png" "<Alt><Shift>F12"

echo "Listo: hotkeys personalizadas configuradas"
