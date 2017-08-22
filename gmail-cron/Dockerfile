FROM jojje/gmail-relay:1.0
MAINTAINER Jonas Tingeborn <github.com/jojje>

# suid needed by cron for non-root users, and bash is nice for running scripts
RUN apk add --no-cache busybox-suid bash

# Add user for running cron jobs
RUN adduser -s /bin/bash -D -u 1000 user

COPY files/crontab.user /etc/crontabs/user
COPY files/init-cron.sh /usr/local/bin/init-cron

# Chain initialization of mailer and cron before starting the provided command
ENTRYPOINT ["/usr/local/bin/init-mailer", "/usr/local/bin/init-cron"]
CMD ["/usr/sbin/crond", "-f", "-L", "/dev/stdout", "-c", "/tmp"]
