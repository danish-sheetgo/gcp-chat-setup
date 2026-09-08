# Set up a Google Chat app

Project creation, API enablement, and the service account are scripted. Chat app
configuration is console-only, so this ends with one page to fill in.

Click **Start**.

## Authorize gcloud

Sessions opened from a repo Google does not own start without your credentials:

```bash
gcloud auth login
```

## Run the setup

```bash
chmod +x setup_chat_app.sh && ./setup_chat_app.sh
```

Press Enter to accept each default. The only value with no default is your HTTPS
endpoint URL.

## Configure the Chat app

The script prints a link to the Chat API configuration page for your project,
plus the exact values to enter. Open it, fill it in, click Save.

## Done

<walkthrough-conclusion-trophy></walkthrough-conclusion-trophy>
