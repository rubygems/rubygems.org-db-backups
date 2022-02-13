# encoding: utf-8

##
# Backup v5.x Configuration
#
# Documentation: http://meskyanichi.github.io/backup
# Issue Tracker: https://github.com/meskyanichi/backup/issues

require 'json'

module OpenSSLFixDeprecatedKeyDerivation
  def options
    super + ' -pbkdf2'
  end
end

require 'backup/encryptor/open_ssl'
Backup::Encryptor::OpenSSL.prepend(OpenSSLFixDeprecatedKeyDerivation)

Backup::Model.new(:postgresql, 'PostgreSQL Backup') do

  database PostgreSQL do |db|
    db.name     = ENV.fetch('POSTGRESQL_DB')
    db.username = ENV.fetch('POSTGRESQL_USER')
    db.password = ENV.fetch('POSTGRESQL_PASSWORD')
    db.host     = ENV.fetch('POSTGRESQL_HOST')
    db.port     = 5432
  end

  compress_with Gzip

  # I am not sure who owns this key.
  # encrypt_with GPG do |encryption|
  #   encryption.keys = {}
  #   encryption.keys[ENV.fetch('GPG_EMAIL')] = ENV.fetch('GPG_PUBLIC_KEY')
  #   encryption.recipients = ENV.fetch('GPG_EMAIL')
  # end

  encrypt_with OpenSSL do |encryption|
    encryption.password      = ENV.fetch('ENC_PASSWORD')
    encryption.base64        = true
    encryption.salt          = true
  end

  store_with S3 do |s3|
    s3.access_key_id      = ENV.fetch('AWS_ACCESS_KEY')
    s3.secret_access_key  = ENV.fetch('AWS_SECRET_KEY')
    s3.bucket             = 'rubygems-rds-private-backups'
    s3.region             = 'us-west-2'
    s3.path               = ENV.fetch('CRON_FREQ')
  end

  notify_by Slack do |slack|
    slack.on_success  = false
    slack.on_warning  = true
    slack.on_failure  = true
    slack.webhook_url = ENV.fetch('SLACK_WEBHOOK_URL')
  end

end
