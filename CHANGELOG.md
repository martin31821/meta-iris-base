# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [APR's Version Numbering](https://apr.apache.org/versioning.html).

## [2.0.1]-dev (HEAD) - n/a
### Added


### Changed


### Deprecated


### Removed


### Fixed


### Simulation only


### Maintenance only


### Known issues



## [2.0.0] - 2021-07-16
### Changed 
- bump linux kernel version to 4.14.233. updating the linux kernel. in the process backported patches do no longer apply.

### Fixed
- Re-add python3 support in perf tools
- [RDSBUG-568] Streamline firmware versioning
- Move DISTRO_VERSION declaration to KAS repository

### Removed
- Remove static ip, which is configured by the eth0-pre-up script if needed.


## [1.0.0] - 2021-05-28
### Added
- This is the initial release of meta-iris-base, a yocto meta-layer which contains all recipes in order to build the Iris base Linux image
