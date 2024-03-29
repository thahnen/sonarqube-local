# sonarqube-local: Utilities for local SonarQube instance(s)

This repository contains scripts and utilities for working with local instance(s) of SonarQube.
Scripts working only with specific versions of SonarQube are marked with the information required.

This project should be only used with JetBrains DataGrip. The Homebrew formulae should work with
either macOS or Linux!

## SQL Scripts

- **reset-password.sql** to reset the password of the user *admin*
- **set-password.sql** to set the password of the user *admin* to *admin1* for testing

Regarding licensing of SonarQube editions other than Community, there is either a SQL script:

- **set-license.sql** to set the license instead of using the UI

or the SonarQube Web API can be used by invoking the following REST API endpoint with HTTP POST:
> curl -X POST http://localhost:9000/api/editions/set_license?license={license key}

## Homebrew formulae

A local formulae can be installed via
> brew install {local repository directory}/homebrew/{formulae name with file suffix}

- **sonarqube-dev.rb** for the latest Developer Edition
- **sonarqube-dev-79.rb** for the 7.9 LTS Developer Edition
- **sonarqube-dev-89.rb** for the 8.9 LTS Developer Edition
- **sonarqube-dev-99.rb** for the 9.9 LTS Developer Edition
- **sonarqube-ent.rb** for the latest Enterprise Edition
- **sonarqube-ent-79.rb** for the 7.9 LTS Enterprise Edition
- **sonarqube-ent-89.rb** for the 8.9 LTS Enterprise Edition
- **sonarqube-ent-99.rb** for the 9.9 LTS Enterprise Edition
- **sonarqube-dat.rb** for the latest Datacenter Edition

Updates can be done over all installed packages with Homebrew, for this "custom" formulaes rather
use take the manual approach:
> brew upgrade {formulae name without file suffix}

The services status can be listed with
> brew services list

A service can be started with
> brew services start {formulae name without file suffix}

A service can be stopped with
> brew services stop {formulae name without file suffix}
