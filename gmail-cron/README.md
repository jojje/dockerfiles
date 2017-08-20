# Cron Gmailing container
E-mail enabled alpine based container for running Cron jobs.

# Usage

    docker run -d \
    -e "SMTP_LOGIN=sender-address@gmail.com" \
    -e "SMTP_PASSWORD=secret" \
    -e "CRON_MAILTO=receiver-address@somewhere.com" \
    jojje/gmail-cron

# Compose example

    cron:
      image: jojje/gmail-cron
      environment:
        SMTP_LOGIN: sender@gmail.com
        SMTP_PASSWORD: secret
        CRON_MAILTO: receiver@somewhere.com
        CRON_SENDER: Cron user

# Configuration
The following environment variables control the cron behavior:

* `SMTP_LOGIN`: The login address for a valid gmail account used to send cron
  mail via gmail.
* `SMTP_PASSWORD`: The corresponding password for the gmail account.
* `CRON_MAILTO`: Email address to send cron mail to.
* `CRON_SENDER`: When provided changes the display name for the sender account. 

If `CRON_SENDER` is not specified, the sender will be "Linux User
<_$SMTP_LOGIN_>"

# Adding cron jobs
The container is setup to run cron-jobs as a non-root user, under the account
`user` with uid 1000.  In the container there is a sample crontab file for this
user, located at `/etc/crontabs/user`, which runs /bin/true once a day.

To add custom jobs, it's easiest to just overlay that file with a custom file
from your own project, or one mounted from a volume.

If there is a need to add additional users, then simply add additional crontab
files to `/etc/crontabs/`, where the name of the file corresponds to the
account you want cron-jobs to run under.

