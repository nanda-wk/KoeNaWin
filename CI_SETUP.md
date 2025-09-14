# CI/CD First-Time Setup Guide

This document outlines the one-time setup steps required to configure the Continuous Integration and Continuous Deployment (CI/CD) pipeline for this project. This guide is intended for the repository administrator or project owner.

---

## Step 1: Initialize Ruby Dependencies

1.  **Create the `Gemfile`**: Create a file named `Gemfile` in the root of the project with the following content:
    ```ruby
    source "https://rubygems.org"

    gem "fastlane"
    ```

2.  **Install Gems and Generate Lock File**: Run `bundle install`. This creates a `Gemfile.lock` file which is critical for ensuring the CI server and all developers use the exact same gem versions.
    ```bash
    bundle install
    ```

3.  **Commit the Files**: Commit both `Gemfile` and `Gemfile.lock` to the repository.

## Step 2: Configure Team and App Identifiers

At this point, the `fastlane` directory has been created. You need to configure the files inside it.

1.  **Fill out `Appfile` and `Matchfile`**: Open `fastlane/Appfile` and `fastlane/Matchfile` and fill in the placeholder values for your app identifier, Apple ID, etc.

2.  **Find Your App Store Connect Team ID (`itc_team_id`)**: If the Apple ID is associated with multiple App Store Connect teams, you must specify which one to use.
    -   The `team_id` is for the Apple Developer Portal (code signing).
    -   The `itc_team_id` is for App Store Connect (app management, TestFlight).
    -   **How to find it**: The easiest way is to have Fastlane tell you. Run any command that connects to App Store Connect, like `bundle exec fastlane produce`. If you are on multiple teams, the command will fail, but it will print a list of all available teams and their corresponding IDs. 
    -   Copy the correct ID and add it to your `fastlane/Appfile` like this:
        ```ruby
        itc_team_id "123456789"
        ```

## Step 3: Create the Private `match` Repository

Create a separate, **private** Git repository to store the encrypted code signing assets. Copy the repository's URL for the `fastlane/Matchfile`.

## Step 4: Generate and Upload Initial Signing Assets

This step must be performed by an admin with access to the Apple Developer Portal.

1.  Ensure the `fastlane/Matchfile` has the correct `git_url` from the previous step.
2.  Run the following commands to generate and upload the certificates. You will be prompted to create an encryption password for the repository.

    ```bash
    bundle exec fastlane match development
    bundle exec fastlane match appstore
    ```

## Step 5: Initialize App Store Metadata

To manage your app's description, release notes, etc., you need to initialize Fastlane's `deliver` tool. This will create a `metadata` directory.

```bash
bundle exec fastlane deliver init
```

After this, you should commit the new `fastlane/metadata` directory and `fastlane/Deliverfile` to your repository.

## Step 6: Set GitHub Actions Secrets

Navigate to your GitHub repository's **Settings > Secrets and variables > Actions** and add the following secrets:

| Secret Name                                  | Description                                                                                                                                      |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| `FASTLANE_USER`                              | The Apple ID of the dedicated service account for CI/CD.                                                                                         |
| `FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD` | The [app-specific password](https://support.apple.com/en-us/HT204397) generated for the `FASTLANE_USER` account.                                  |
| `MATCH_PASSWORD`                             | The password you created in Step 4 to encrypt the `match` repository.                                                                            |

## Step 7: Create Project Branches

Ensure these branches exist in your repository: `develop`, `UAT`, and `prod`.

## Setup Complete

Once these steps are completed, the CI/CD infrastructure is fully configured.
