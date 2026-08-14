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

# Asociar una tecla directamente a una acción nativa de XFWM
add_xfwm_hotkey() {
  ACTION="$1"
  KEYS="$2"

  # Quitar un comando personalizado previo que use la misma combinación
  xfconf-query -c xfce4-keyboard-shortcuts -p "/commands/custom/$KEYS" --reset 2>/dev/null || true

  xfconf-query -c xfce4-keyboard-shortcuts -p "/xfwm4/custom/$KEYS" --create --type string --set "$ACTION"
}

# Alt+Shift+L → bloquear pantalla con slock
add_hotkey "LockWithSlock" "slock" "<Alt><Shift>l"

# Alt+Shift+Return → abrir xfce4-terminal
add_hotkey "Terminal" "xfce4-terminal" "<Alt><Shift>Return"

# Alt+Shift+M → maximizar o restaurar la ventana activa
add_xfwm_hotkey "maximize_window_key" "<Alt><Shift>m"

# Alt+Shift+P → abrir dmenu con el estilo del entorno
add_hotkey "DmenuRun" "sh -c 'PATH=\"\$HOME/bin:\$HOME/.local/bin:\$HOME/src/scripts:\$PATH\"; export PATH; exec dmenu_run -fn \"Monospace:size=16\" -nb \"#000000\" -nf \"#ff00f0\" -sb \"#8f00ff\" -sf \"#eeeeee\"'" "<Alt><Shift>p"

# Alt+Shift+F11 → tomar screenshot de la pantalla completa con scrot
add_hotkey "ScreenshotScrot" "scrot ~/Pictures/Screenshots/screenshot-%Y%m%d-%H%M%S.png" "<Alt><Shift>F11"

# Alt+Shift+F12 → seleccionar con el mouse el área a capturar
add_hotkey "ScreenshotScrotSelection" "sh -c 'mkdir -p \"\$HOME/Pictures/Screenshots\" && cd \"\$HOME/Pictures/Screenshots\" && exec scrot --freeze --select'" "<Alt><Shift>F12"

echo "Listo: hotkeys personalizadas configuradas"
