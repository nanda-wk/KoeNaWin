fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios tests

```sh
[bundle exec] fastlane ios tests
```

Run unit tests

### ios lint

```sh
[bundle exec] fastlane ios lint
```

Lint code using SwiftFormat

### ios sync_development_signing

```sh
[bundle exec] fastlane ios sync_development_signing
```

Sync development certificates and profiles

### ios build_and_upload_to_testflight

```sh
[bundle exec] fastlane ios build_and_upload_to_testflight
```

Build and upload to TestFlight for UAT

### ios deploy_to_app_store

```sh
[bundle exec] fastlane ios deploy_to_app_store
```

Deploy to the App Store

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
