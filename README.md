# sonarqube-local: Utilities for local SonarQube instance(s)

This repository contains scripts and utilities for working with local instance(s) of SonarQube.
Scripts working only with specific versions of SonarQube are marked with the information required.

This project should be only used with JetBrains DataGrip. The Homebrew formulae should work with
either macOS or Linux!

## SQL Scripts

- **reset-password.sql** to reset the password of the user *admin*
- **set-password.sql** to set the password of the user *admin* to *admin1* for testing
- **set-license.sql** to set the license instead of using the UI

## Homebrew formulae

A local formulae can be installed via
> brew install ${project_loc}/homebrew/${formulae_name}

- **sonarqube-dev.rb** for the latest Developer Edition
- **sonarqube-dev-79.rb** for the 7.9 LTS Developer Edition
- **sonarqube-dev-89.rb** for the 8.9 LTS Developer Edition
- **sonarqube-dev-99.rb** for the 9.9 LTS Developer Edition
- **sonarqube-ent.rb** for the latest Enterprise Edition
- **sonarqube-ent-79.rb** for the 7.9 LTS Enterprise Edition
- **sonarqube-ent-89.rb** for the 8.9 LTS Enterprise Edition
- **sonarqube-ent-99.rb** for the 9.9 LTS Enterprise Edition
- **sonarqube-dat.rb** for the latest Datacenter Edition

The services status can be listed with
> brew services list

A service can be started with
> brew services start {formulae name without suffix}

A service can be stopped with
> brew services stop {formulae name without suffix}
