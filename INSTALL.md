# Fastlane and Signing Setup Guide

This guide provides step-by-step instructions for setting up your local environment to build, test, and deploy this project using Fastlane.

## 1. Prerequisites

Before you begin, ensure you have the following tools installed on your Mac.

### Homebrew
If you don't have it, open Terminal and run:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Xcode Command Line Tools
Install them by running:
```bash
xcode-select --install
```

### Bundler
Bundler manages our Ruby dependencies, including Fastlane. Install it with:
```bash
gem install bundler
```

## 2. Project Setup

1.  **Clone the Repository:**
    Clone the project to your local machine.
    ```bash
    git clone <your-project-git-url>
    cd <project-directory>
    ```

2.  **Install Dependencies:**
    Install the specific versions of Fastlane and other tools required by the project.
    ```bash
    bundle install
    ```

## 3. Code Signing Setup (`match`)

We use Fastlane's `match` tool to manage code signing certificates and provisioning profiles. This ensures everyone on the team uses the same signing identity. The assets are stored in a separate, private Git repository.

### A. Get Access Credentials

To access the signing assets, you will need two pieces of information from your team lead or the project administrator:
1.  The **URL of the private `match` Git repository**.
2.  The **`match` password** (the passphrase used to encrypt the repository).

### B. Sync Certificates to Your Machine

Run the following command in your terminal. This will clone the private `match` repository, decrypt the certificates and profiles using the password you provide, and install them on your machine.

```bash
bundle exec fastlane match development --readonly
```

- You will be prompted to enter the `match` password.
- The `--readonly` flag is important because it ensures you only download existing certificates and do not accidentally create new ones.

## 4. Xcode Project Configuration

The final step is to tell Xcode to use the profiles managed by `match`.

1.  Open the project in Xcode: `open KoeNaWin.xcodeproj`.
2.  Select the `KoeNaWin` project in the Project Navigator.
3.  Go to the **"Signing & Capabilities"** tab for the `KoeNaWin` target.
4.  **Turn off "Automatically manage signing"**.
5.  From the **"Provisioning Profile"** dropdown menu, select the profile that starts with `match Development...`. Do this for both `Debug` and `Release` configurations if necessary.

## 5. You're Ready!

Your local environment is now fully configured. You can run the app on a device and use the following Fastlane commands:

-   **Run unit tests:**
    ```bash
    bundle exec fastlane tests
    ```
-   **Check code style:** (Requires SwiftFormat: `brew install swiftformat`)
    ```bash
    bundle exec fastlane lint
    ```

---

## For Admins: Initial `match` Setup or Certificate Renewal

**Note:** These commands should only be run by a project administrator with access to the Apple Developer Portal. Running them will create or renew certificates.

-   **Create/Renew Development Assets:**
    ```bash
s
    bundle exec fastlane match development
    ```
-   **Create/Renew App Store Distribution Assets:**
    ```bash
    bundle exec fastlane match appstore
    ```
