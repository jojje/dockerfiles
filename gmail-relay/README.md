# Gmail Relay
Provides a sendmail shim (ssmtp) which makes it easy to add mail sending support to containers built from it.

# Usage

    docker run -e "SMTP_LOGIN=address@gmail.com" -e "SMTP_PASSWORD=secret" jojje/gmail-relay \
    sendmail someone@address.com

# Configuration:
The following environment variables control the relaying behavior:

* `SMTP_LOGIN`: The login address for a valid gmail account to be used for the
  relaying of mail.
* `SMTP_PASSWORD`: The corresponding password for the gmail account.
* `SMTP_SENDERS`: When provided changes the display name for one or more linux
  accounts in the image.

The SMTP_SENDERS variable takes a comma delimited list of
`<linux-account>=<display name>`.

For example if the variable contains `root=default mailer,www-data=web server`,
then mail sent from the root or www-data account will show up in mail clients
with the FROM name displayed as "default mailer" and "web server" respectively.

The email address itself will however remain that of the gmail address used to
authenticate (SMTP_LOGIN).

