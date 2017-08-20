FROM jojje/gmail-relay:1.0
MAINTAINER Jonas Tingeborn <github.com/jojje>

RUN apk add --no-cache supervisor rsyslog busybox-suid bash

# Add user for running cron jobs
RUN adduser -s /bin/bash -D -u 1000 user

# Setup services
COPY files/rsyslog.conf /etc/rsyslog.conf
COPY files/crontab.user /etc/crontabs/user
COPY files/supervisord.conf /etc/supervisord.conf
COPY files/init-cron.sh /usr/local/bin/init-cron

# Chain initialization of mailer and cron before starting services
ENTRYPOINT ["/usr/local/bin/init-mailer", "/usr/local/bin/init-cron", \
            "/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
