# sonarqube-local: Utilities for local SonarQube instance(s)

This repository contains scripts and utilities for working with local instance(s) of SonarQube.
Scripts working only with specific versions of SonarQube are marked with the information required.

This project should be only used with Jetbrains DataGrip. The Homebrew formulae should work with
either macOS or Linux!

## SQL Scripts

- **reset-password.sql** to reset the password of the user *admin*
- **set-password.sql** to set the password of the user *admin* to *admin1* for testing
- **set-license.sql** to set the 

## Homebrew formulae

A local formulae can be installed via
> brew install {path to formulae}

- **sonarqube-dev.rb** for the Developer Edition
- **sonarqube-ent.rb** for the Enterprise Edition
- **sonarqube-dat.rb** for the Datacenter Edition

The services status can be listed with
> brew services

A service can be started with
> brew services start {formulae name without suffix}

A service can be stopped with
> brew services stop {formulae name without suffix}
