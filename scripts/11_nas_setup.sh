#!/bin/bash

# NAS Connection Setup Script

# Get parameters from parent script
REAL_USER="$1"
USER_HOME="$2"
SCRIPT_DIR="$3"

echo "===== Setting up NAS connection ====="

sudo -v

save_credentials() {
  local smb_url="$1"
  local username="$2"
  local password="$3"

  if command -v secret-tool &> /dev/null; then
    echo -n "$password" | secret-tool store \
    --label="$username@$smb_url" \
    server "$smb_url" \
    user "$username" \
    domain "WORKGROUP" \
    protocol "smb" \
    xdg:schema "org.gnome.keyring.NetworkPassword"
    echo "Credentials saved to keyring for $smb_url"
  else
    echo "secret-tool not found. Cannot store credentials in keyring."
    echo "Install libsecret-tools package for keyring support."
  fi
}

add_bookmark() {
  local smb_url="$1"
  local bookmark_file="$HOME/.config/gtk-3.0/bookmarks"
  local name="NAS_${smb_url##*/}"  # Extract last path component

  mkdir -p "$HOME/.config/gtk-3.0"

  if grep -q " $smb_url\$" "$bookmark_file" 2>/dev/null; then
    sed -i "\| $smb_url\$|d" "$bookmark_file"
  fi

  echo "$smb_url $name" >> "$bookmark_file"
  echo "Bookmark added for $smb_url as '$name'"
}

nas_link=""
username=""
password=""

if command -v zenity &> /dev/null; then
  nas_link=$(zenity --entry --title="NAS Connection" --text="Enter NAS link (e.g., xxxxx.synology.me):" --width=300)
  username=$(zenity --entry --title="Authentication Required" --text="Enter username for Synology NAS:" --width=300)
  password=$(zenity --password --title="Authentication Required" --text="Enter password for $username:")
else
  read -p "Enter username for Synology NAS: " username
  read -s -p "Enter password for $username: " password
  echo
fi

if ! dpkg -l | grep -q "ii  libsecret-tools "; then
  echo "Installing libsecret-tools"
  sudo apt update
  sudo apt install -y libsecret-tools
fi

save_credentials "$nas_link" "$username" "$password"
add_bookmark "smb://$nas_link/shared"
add_bookmark "smb://$nas_link/home"
echo "===== NAS connection setup completed ====="
