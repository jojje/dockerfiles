FROM jojje/gmail-relay:1.0
MAINTAINER Jonas Tingeborn <github.com/jojje>

# suid needed by cron for non-root users, and bash is nice for running scripts
RUN apk add --no-cache busybox-suid bash

# Add mailto stub to root's crontab to simplify mailing enabling for the user
RUN crontab -u root -l | grep -v "^# MAILTO" \
  | awk 'BEGIN{ print "# MAILTO=<replaced at runtime>\nSHELL=/bin/bash" }{ print }' \
  | crontab -u root - \
 && rm -f /etc/crontabs/cron.update \

##
# Non-root user
#
# Convenience for those not using linux namespace mapping of root, to allow a
# more secure context for running cron jobs.

# Create non-root user and add convenient periodic directories to drop scripts
# into for the user.
 && adduser -D user \
 && su -l -c "mkdir periodic && cd periodic && mkdir 15min hourly daily weekly monthly" user

# Add a no-op crontab for account 'user'
COPY files/crontab.user /etc/crontabs/user
##

# Add hook to configure mailto address at container launch
COPY files/init-cron.sh /usr/local/bin/init-cron

# Chain initialization of mailer and cron before starting the provided command
ENTRYPOINT ["/usr/local/bin/init-mailer", "/usr/local/bin/init-cron"]
CMD ["/usr/sbin/crond", "-f", "-L", "/dev/stdout", "-c", "/tmp"]
