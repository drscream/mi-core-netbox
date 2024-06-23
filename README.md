# mi-core-netbox

Please note this repository should be build with the [mi-core-base](https://github.com/skylime/mi-core-base) mibe image.

## documentation

NetBox exists to empower network engineers. The premier source of truth powering network automation.

## mdata variables

- `nginx_ssl`: ssl cert, key and CA for nginx in pem format (if not provided Let's Encrypt will be used)
- `netbox_admin_email`: email address used for the administration user
- `netbox_pgsql_pw`: auto-generated password used for the connection to the database
- `netbox_admin_initial_pw`: initial admin user password for netbox

## services

- `80/tcp`: http via nginx
- `443/tcp`: https via nginx
