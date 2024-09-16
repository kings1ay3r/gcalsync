# CalendarSyncApp

A Ruby on Rails application that syncs events with Google Calendar and manages calendar watch requests to keep track of changes.

---

### Table of Contents

- [Overview](#overview)
- [Setup](#setup)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Configuration](#configuration)
- [Usage](#usage)
- [Google Calendar Integration](#google-calendar-integration)
  - [Setting Up Google API Credentials](#setting-up-google-api-credentials)
  - [Google OAuth Setup](#google-oauth-setup)
- [Contributing](#contributing)
- [License](#license)

---

### Overview

CalendarSyncApp is a Ruby on Rails application that allows users to connect their Google Calendar accounts, sync events to the app, and set up watch requests to monitor changes in their calendars.

---

### Setup

#### Prerequisites

Ensure you have the following installed:

- Ruby 3.1.0
- Rails 7.0.0
- PostgreSQL 14.x
- Google API credentials

#### Installation

Follow these steps to install and set up the application:

# Clone the repository

```
    git clone https://github.com/yourusername/calendar_sync_app.git
    cd calendar_sync_app
```

# Install dependencies

```
    bundle install
```

# Set up the database

```
    rails db:create
    rails db:migrate

```

Configuration
Set up environment variables in a .env file or your server’s environment configuration:

```

    # Google API credentials

    GOOGLE_CLIENT_ID=your-client-id.apps.googleusercontent.com
    GOOGLE_CLIENT_SECRET=your-client-secret
    GOOGLE_CALLBACK_URL=http://yourdomain.com/google_calendars/callback
    WEBHOOK_URL=http://yourdomain.com/webhooks/google_calendar
    GOOGLE_APP_NAME=CalendarSyncApp

```

Make sure to use actual values for GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET, and WEBHOOK_URL.

Usage
Start the Rails server with the following command:

    `rails server`

Navigate to http://localhost:3000 in your browser to use the application.

### Google Calendar Integration

Integrating with Google Calendar involves setting up Google API credentials and configuring OAuth for authentication.

#### Setting Up Google API Credentials

1. **Create a Google Cloud Project**

   - Go to the [Google Cloud Console](https://console.cloud.google.com/).
   - Create a new project or select an existing one.

2. **Enable the Google Calendar API**

   - Navigate to **APIs & Services** > **Library**.
   - Search for "Google Calendar API" and enable it for your project.

3. **Create OAuth 2.0 Credentials**
   - Navigate to **APIs & Services** > **Credentials**.
   - Click on **Create Credentials** and select **OAuth 2.0 Client ID**.
   - Set the application type to **Web application**.
   - Under **Authorized redirect URIs**, add your callback URL, e.g., `http://localhost:3000/google_calendars/callback`.
   - Save the credentials and note your **Client ID** and **Client Secret**.

#### Google OAuth Setup

1. **Set Environment Variables**

   Create a `.env` file in the root of your project or configure environment variables in your deployment environment. Add the following lines, replacing the placeholder values with actual credentials:

```

    GOOGLE_CLIENT_ID=your-client-id.apps.googleusercontent.com
    GOOGLE_CLIENT_SECRET=your-client-secret
    GOOGLE_CALLBACK_URL=http://localhost:3000/google_calendars/callback
    WEBHOOK_URL=http://yourdomain.com/webhooks/google_calendar
    GOOGLE_APP_NAME=CalendarSyncApp

```
