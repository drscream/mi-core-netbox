# Changelog

## 23.4.0

- Initial setup core-netbox image with NetBox 4.0.5. [Thomas Merkel]

  * Use core-base image with LTS support (replace trunk/rolling release)
  * Use fixed NetBox version 4.0.5
  * Relocation NetBox to /opt (from /home)
  * Add delegate databaset, pgsql, redis and nginx zoneinit configuration
  * Remove build dependencies after setup and installation via pip
  * Remove unused files by core-base (deleted_packages and more)


## 20230910.0 - 2023-11-06

* use latest base image
* upgrade to python3.10

## 20191127.0

* First release
