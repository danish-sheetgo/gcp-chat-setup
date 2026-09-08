#!/usr/bin/env bash

set -euo pipefail

# ==============================================================================
# CONFIGURATION VARIABLES
# ==============================================================================
PROJECT_NAME="My Chat Bot"
PROJECT_ID="chat-bot-proj-$(date +%s)"
SA_NAME="chat-bot-sa"
SA_DISPLAY_NAME="Google Chat Bot Service Account"
KEY_FILE_PATH="./chat-sa-key.json"

# ==============================================================================
# STEP 1: CREATE GCP PROJECT & SET CONFIG
# ==============================================================================
echo "==> Creating GCP Project: ${PROJECT_ID}..."
gcloud projects create "${PROJECT_ID}" --name="${PROJECT_NAME}"
gcloud config set project "${PROJECT_ID}"

# ==============================================================================
# STEP 2: ENABLE REQUIRED APIS
# ==============================================================================
echo "==> Enabling Google Chat API and Service Usage API..."
gcloud services enable chat.googleapis.com serviceusage.googleapis.com

# ==============================================================================
# STEP 3: CREATE SERVICE ACCOUNT & GENERATE KEY
# ==============================================================================
echo "==> Creating Service Account: ${SA_NAME}..."
gcloud iam service-accounts create "${SA_NAME}" \
    --display-name="${SA_DISPLAY_NAME}" \
    --description="Used by Google Chat App"

SA_EMAIL="${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"

echo "==> Generating Service Account Key JSON at ${KEY_FILE_PATH}..."
gcloud iam service-accounts keys create "${KEY_FILE_PATH}" \
    --iam-account="${SA_EMAIL}"

# ==============================================================================
# STEP 4: TRIGGER AUTOMATIC BROWSER DOWNLOAD
# ==============================================================================
echo "=============================================================================="
echo "SUCCESS!"
echo "Project ID:            ${PROJECT_ID}"
echo "Service Account Email: ${SA_EMAIL}"
echo "Key File Saved To:     ${KEY_FILE_PATH}"
echo "=============================================================================="
echo "==> Downloading service account key to your local machine..."

# Triggers automatic browser download in Cloud Shell
if command -v cloudshell &> /dev/null; then
    cloudshell download "${KEY_FILE_PATH}"
fi
