#!/bin/sh
set -e # exit on error

# Variables
[ -z "$SMTP_LOGIN" -o -z "$SMTP_PASSWORD" ] && {
	echo "SMTP_LOGIN and SMTP_PASSWORD _must_ be defined" >&2
	exit 1
}

# Template instantiation
user=$(echo -n "$SMTP_LOGIN"    | sed -e 's/[]\/$*.^|[]/\\&/g')
pass=$(echo -n "$SMTP_PASSWORD" | sed -e 's/[]\/$*.^|[]/\\&/g')
sed -i'' "s/\${SMTP_LOGIN}/${user}/g"   /etc/ssmtp/ssmtp.conf
sed -i'' "s/\${SMTP_PASSWORD}/${pass}/g" /etc/ssmtp/ssmtp.conf

# Allow customization of sender (FROM) addresses
# Format required for each entry: <system-account>=<name-to-use-in-FROM>
# Entries are comma delimited. E.g. "root=someone,www-data=my-web-server"
echo "$SMTP_SENDERS" | tr "," "\n" | while read mapping; do 
  account=${mapping%=*}; name=${mapping#*=}
  [ -n "$name" ] || continue
  #exists $account || { echo "ERROR No such account: $account"; exit 1 ;}
  echo "Adding customized account sender mapping: $account -> $name"
  #update_account_name "$account" "$name"
  chfn -f "$name" $account
done

echo "Outgoing mail will be sent using address: $SMTP_LOGIN"

# Remove the variables, to not pollute the environment
unset SMTP_LOGIN SMTP_PASSWORD SMTP_SENDERS 

exec "$@"
