#!/usr/bin/env bash

echo ""
echo "=================================================="
echo " GCP Google Chat App Setup - Automated Installer"
echo "=================================================="
echo ""
read -p "Would you like to start the setup now? (Y/n): " choice

case "$choice" in 
  y|Y|"" )
    echo "Starting setup..."
    chmod +x setup_chat_app.sh
    ./setup_chat_app.sh
    ;;
  * )
    echo "Setup cancelled."
    ;;
esac
