# No longer maintained

This project was created to avoid node dependencies on workstations.  
Bitwarden have [released their own binary now](https://bitwarden.com/help/cli/#download-and-install),
obsoleting this project.

# Bitwarden container

A containerized version of bitwarden

## Installation

With [μpkg](https://github.com/orbit-online/upkg)

```
upkg install -g orbit-online/bitwarden-container@<VERSION>
```

## Usage

Just like [bw](https://bitwarden.com/help/cli/)

## Versions

The versioning follows bitwarden cli release versions with a `v` prefix and
a `-<PATCH>` suffix for fixes concerning this package (starting with `-1`,
naturally sorted).
