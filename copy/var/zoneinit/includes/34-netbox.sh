#!/usr/bin/env bash
# Setup netbox configuration

SECRET_KEY=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c"${1:-100}")
NETBOX_ADMIN_INITIAL_PW=$(/opt/core/bin/mdata-create-password.sh -m netbox_admin_initial_pw)

# Configure settings.py
# _insertreplace FILE KEY VALUE
_insertreplace() {
    local file="${1}"
    shift
    local key="${1}"
    shift
    local value="${*}"
    if [[ "${value}" != "True" &&
        "${value}" != "False" &&
        "${value:0:1}" != "[" ]]; then
        value="\"${value}\""
    fi
    if grep -q "${key}" "${file}"; then
        gsed -i "s|^${key} \+=.*|${key} = ${value}|g" "${file}"
    else
        echo "${key} = ${value}" >> "${file}"
    fi
}

NETBOX_CONFIGURATION='/opt/netbox/netbox/netbox/configuration.py'

_insertreplace "${NETBOX_CONFIGURATION}" SECRET_KEY "${SECRET_KEY}"
_insertreplace "${NETBOX_CONFIGURATION}" ALLOWED_HOSTS "[ '$(hostname)', '127.0.0.1', '::1' ]"

if ADMIN_EMAIL=$(mdata-get netbox_admin_email 2> /dev/null); then
    _insertreplace "${NETBOX_CONFIGURATION}" ADMINS "[ [ 'admin', '${ADMIN_EMAIL}', ], ]"
fi

# DB Configure
gsed -i "s/_NETBOX_PGSQL_PW_/${USER_PGSQL_PW}/g" "${NETBOX_CONFIGURATION}"

# Initial DB migration
sudo -u netbox -- sh << EOF
cd /opt/netbox/netbox
/opt/netbox/venv/bin/python3 manage.py migrate
/opt/netbox/venv/bin/python3 manage.py collectstatic --no-input
EOF

# Create SuperUser if it doesn't exists
NETBOX_ADMIN_INITIAL_PW=$(mdata-get netbox_pgsql_pw)
cat << EOF | /opt/netbox/venv/bin/python3 /opt/netbox/netbox/manage.py shell
from django.contrib.auth import get_user_model
User = get_user_model()
User.objects.filter(username="admin").exists() or \
    User.objects.create_superuser("admin", "${ADMIN_EMAIL}", "${NETBOX_ADMIN_INITIAL_PW}")
EOF
