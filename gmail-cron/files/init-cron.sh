#!/bin/sh
set -e # exit on error

# Mandatory variable
[ -n "${CRON_MAILTO}" ] || {
  echo "CRON_MAILTO _must_ be defined" >&2
  exit 2
}


# Template instantiation
receiver=$(echo -n "${CRON_MAILTO}" | sed -e 's/[]\/$*.^|[]/\\&/g')
for tab in /etc/crontabs/*; do
  sed -i'' "s/^# MAILTO=.*/MAILTO=${receiver}/g" "${tab}"
done
echo "Cron mailto address: ${CRON_MAILTO}"

# Optional variable, defaults to account named running cron
if [ -n "${CRON_SENDER}" ]; then
	chfn -f "${CRON_SENDER}" user
	chfn -f "${CRON_SENDER}" root
	echo "Cron mail sender display name: \"${CRON_SENDER}\""
fi

exec "$@"

