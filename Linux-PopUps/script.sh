#!/usr/bin/env bash
set -euo pipefail

cycles=3

msgs=(
"Im looking at you?"
"Bruuhhhh"
"MrBeast posted a new video: I payed top hackers to hack innocent people!"
"Linux > Windows"
)

title="GetPwned."

# Wybiera dostępne narzędzie do pokazywania okien dialogowych
detect_dialog_tool() {
  if command -v zenity >/dev/null 2>&1; then
    echo "zenity"
  elif command -v kdialog >/dev/null 2>&1; then
    echo "kdialog"
  elif command -v osascript >/dev/null 2>&1; then
    echo "osascript"
  elif command -v notify-send >/dev/null 2>&1; then
    # notify-send nie blokuje; użyjemy go jako fallback
    echo "notify-send"
  else
    echo "none"
  fi
}

tool=$(detect_dialog_tool)

show_message() {
  local msg="$1"
  case "$tool" in
    zenity)
      zenity --info --title="$title" --text="$msg" --no-wrap >/dev/null 2>&1 || true
      ;;
    kdialog)
      kdialog --title "$title" --msgbox "$msg" >/dev/null 2>&1 || true
      ;;
    osascript)
      osascript -e "display dialog \"${msg//\"/\\\"}\" with title \"${title//\"/\\\"}\" buttons {\"OK\"} default button 1" >/dev/null 2>&1 || true
      ;;
    notify-send)
      notify-send "$title" "$msg"
      sleep 2
      ;;
    none)
      printf '%s\n' "[$title] $msg"
      sleep 1
      ;;
  esac
}

# Główna pętla
for ((i=1;i<=cycles;i++)); do
  for msg in "${msgs[@]}"; do
    show_message "$msg"
  done
done

echo "Done."
