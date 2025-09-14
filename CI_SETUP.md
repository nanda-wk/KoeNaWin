# CI/CD First-Time Setup Guide

This document outlines the one-time setup steps required to configure the Continuous Integration and Continuous Deployment (CI/CD) pipeline for this project. This guide is intended for the repository administrator or project owner.

---

## Step 1: Create the Private `match` Repository

Our CI/CD process uses Fastlane `match` to manage code signing. You must create a separate, **private** Git repository to store the encrypted certificates and provisioning profiles.

1.  On GitHub (or your preferred Git provider), create a new **private** repository. For example, `KoeNaWin-certificates`.
2.  Copy the SSH or HTTPS URL for this new repository. You will need it in the next steps.

## Step 2: Generate and Upload Initial Signing Assets

This step must be performed by a user with **Admin access** to the company's Apple Developer Portal account.

1.  On your local machine (which should already be set up per `INSTALL.md`), ensure the `fastlane/Matchfile` has the correct `git_url` pointing to the repository you just created.
2.  Run the following commands to generate the development and distribution certificates. `match` will automatically create them in the Developer Portal and upload the encrypted files to your private repository.

    ```bash
    # This will prompt you to create a password (passphrase) for the repository.
    # Choose a strong password and save it securely. You will need it for the next step.
    bundle exec fastlane match development

    # Use the same password when prompted here.
    bundle exec fastlane match appstore
    ```

## Step 3: Set GitHub Actions Secrets

The CI/CD workflows need credentials to communicate with App Store Connect and decrypt the `match` repository. You must add these as secrets to this GitHub repository.

1.  Navigate to your GitHub repository's main page.
2.  Go to **Settings > Secrets and variables > Actions**.
3.  Click **New repository secret** for each of the following secrets:

| Secret Name                                  | Description                                                                                                                                      |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| `FASTLANE_USER`                              | The Apple ID of the dedicated service account used for CI/CD (e.g., `cicd@yourcompany.com`).                                                      |
| `FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD` | The [app-specific password](https://support.apple.com/en-us/HT204397) generated for the `FASTLANE_USER` account.                                  |
| `MATCH_PASSWORD`                             | The password you created in Step 2 to encrypt and decrypt the `match` repository.                                                                |

## Step 4: Create Project Branches

Our CI/CD pipeline is configured to run on specific branches. Ensure these branches exist in your repository:

-   `develop`
-   `UAT`
-   `prod`

## Setup Complete

Once these steps are completed, the CI/CD infrastructure is fully configured. The workflows will now run automatically when code is pushed to the designated branches. Other developers on the team can now follow the instructions in `INSTALL.md` to set up their local machines.
