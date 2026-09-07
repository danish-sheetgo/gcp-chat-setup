#!/usr/bin/env bash

set -euo pipefail

# ==============================================================================
# CONFIGURATION VARIABLES
# ==============================================================================
PROJECT_NAME="My Chat Bot"
# Project ID must be unique across Google Cloud (lowercase, numbers, hyphens only)
PROJECT_ID="chat-bot-proj-$(date +%s)"
ORGANIZATION_ID="" # Optional: e.g., "123456789012"
BILLING_ACCOUNT_ID="" # Optional: e.g., "012345-6789AB-CDEF01"

SA_NAME="chat-bot-sa"
SA_DISPLAY_NAME="Google Chat Bot Service Account"
KEY_FILE_PATH="./chat-sa-key.json"

APP_NAME="My automated Bot"
APP_DESCRIPTION="A bot created via automated GCP script"
AVATAR_URL="https://developers.google.com/workspace/chat/images/quickstart-app-avatar.png"
# HTTP endpoint URL receiving webhook payloads (or PubSub topic name)
ENDPOINT_URL="https://example.com/bot-webhook"

# ==============================================================================
# STEP 1: CREATE GCP PROJECT
# ==============================================================================
echo "==> Creating GCP Project: ${PROJECT_ID}..."
CREATE_FLAGS=()
if [ -n "${ORGANIZATION_ID}" ]; then
  CREATE_FLAGS+=(--organization="${ORGANIZATION_ID}")
fi

gcloud projects create "${PROJECT_ID}" --name="${PROJECT_NAME}" "${CREATE_FLAGS[@]}"

# Set current working project
gcloud config set project "${PROJECT_ID}"

# Link billing account (Required for some Workspace/Chat integrations)
if [ -n "${BILLING_ACCOUNT_ID}" ]; then
  echo "==> Linking Billing Account..."
  gcloud beta billing projects link "${PROJECT_ID}" --billing-account="${BILLING_ACCOUNT_ID}"
fi

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
# STEP 4: CONFIGURE GOOGLE CHAT APP SETTINGS
# ==============================================================================
echo "==> Configuring Google Chat Application..."
# Using gcloud workspace chat API configuration (v1 endpoint)
gcloud workspace chat app update \
    --name="${APP_NAME}" \
    --description="${APP_DESCRIPTION}" \
    --avatar-uri="${AVATAR_URL}" \
    --http-url="${ENDPOINT_URL}" \
    --interactive-enabled \
    --group-chat-enabled \
    --direct-messaging-enabled || {
      echo "Note: If 'gcloud workspace chat' component is missing, install/update via:"
      echo "gcloud components install alpha beta workspace"
    }

echo "=============================================================================="
echo "SUCCESS!"
echo "Project ID:           ${PROJECT_ID}"
echo "Service Account Email: ${SA_EMAIL}"
echo "Key File Saved To:     ${KEY_FILE_PATH}"
echo "=============================================================================="
