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
The container is prepared to run run cron-jobs both as root and as a non-root
user. Root's jobs are governed by `/etc/crontabs/root` and the non-root account,
named 'user' with uid and gid 1000, by the file `/etc/crontabs/user`.

The options for adding jobs are listed below.

## Add a periodic job
Place an executable file (script typically) in one of the directories under
`/etc/periodic/` for root, or `~/periodic/` for the non-root account.

For example, to run the script `hello-world` every 15 minutes as root, place it
in `/etc/periodic/15min/`

## Add custom job schedule
If the periodic intervals are not sufficient, you can modify the crontab file
itself for the user that is to run the job(s).

E.g. adding a new job to be run every 5 minutes:

    # echo '5 * * * *  /some-dir/my-script' >> /etc/crontabs/user

Or using the normal edit commands for crontab

    $ crontab -e or crontab -l | <edit command> | crontab -

Or simply replace the default crontab file(s) with your own.

These actions would normally be done as part of your own Dockerfile, where you
create override layers from this image as a base.

E.g.

    FROM jojje/gmail-cron
    COPY my-job /usr/local/bin/
    COPY crontab /etc/crontabs/user

## Trouble shooting
### Get more runtime info
Starting of crond is just the default argument to the container, so you can
replace that with a custom command. E.g. `sh` to dig into how the container
looks after initialization, or increasing the crond logging.

Example of the latter

    docker-compose run --rm cron crond -f -L /dev/stdout -l 8

Note: assumes a compose file like in the example is used, to reduce typing.

### Ensure mail delivery
To make sure that you've white-listed the cron emails, so they don't end up in
a spam folder, or are prevented from delivery for some reason or another, it's
good to at least fire off a test email before deploying the container to
production.

    echo -e "Subject:Test\n\nbody\n" | \
      docker-compose run --rm cron sendmail recipient@somewhere.com

