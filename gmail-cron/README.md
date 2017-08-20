# Cron Gmailing container
E-mail enabled alpine based container for running Cron jobs.

# Usage

    docker run -d \
    -e "SMTP_LOGIN=sender-address@gmail.com" \
    -e "SMTP_PASSWORD=secret" \
    -e "CRON_MAILTO=receiver-address@somewhere.com" \
    jojje/gmail-cron

# Configuration
The following environment variables control the cron behavior:

* `SMTP_LOGIN`: The login address for a valid gmail account used to send cron
  mail via gmail.
* `SMTP_PASSWORD`: The corresponding password for the gmail account.
* `CRON_MAILTO`: Email address to send cron mail to.
* `CRON_SENDER`: When provided changes the display name for the sender account. 

If `CRON_SENDER` is not specified, the sender will be "Linux User
<$SMTP_LOGIN>"

# Compose example

  cron:
    image: jojje/gmail-cron
    environment:
      SMTP_LOGIN: sender@gmail.com
      SMTP_PASSWORD: secret
      CRON_MAILTO: receiver@somewhere.com
      CRON_SENDER: Cron user

