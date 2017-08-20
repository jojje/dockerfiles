#!/bin/sh
set -e # exit on error

# Mandatory variable
[ -n "${CRON_MAILTO}" ] || {
  echo "CRON_MAILTO _must_ be defined" >&2
  exit 2
}


# Template instantiation
receiver=$(echo -n "${CRON_MAILTO}" | sed -e 's/[]\/$*.^|[]/\\&/g')
sed -i'' "s/^#MAILTO.*/MAILTO=${receiver}/g" /etc/crontabs/user
echo "Cron mailto address: ${CRON_MAILTO}"

# Optional variable, defaults to account named running cron
if [ -n "${CRON_SENDER}" ]; then
	chfn -f "${CRON_SENDER}" user
	echo "Cron mail sender display name: \"${CRON_SENDER}\""
fi

exec "$@"

