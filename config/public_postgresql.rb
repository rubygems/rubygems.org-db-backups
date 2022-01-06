# encoding: utf-8

##
# Backup v5.x Configuration
#
# Documentation: http://meskyanichi.github.io/backup
# Issue Tracker: https://github.com/meskyanichi/backup/issues

require 'json'

Backup::Model.new(:public_postgresql, 'RubyGems.org Public Database Dump') do

  database PostgreSQL do |db|
    db.name        = ENV.fetch('POSTGRESQL_DB')
    db.username    = ENV.fetch('POSTGRESQL_USER')
    db.password    = ENV.fetch('POSTGRESQL_PASSWORD')
    db.host        = ENV.fetch('POSTGRESQL_HOST')
    db.port        = 5432
    db.only_tables = ['rubygems', 'versions', 'dependencies', 'linksets', 'version_histories', 'gem_downloads']
  end

  compress_with Gzip

  store_with S3 do |s3|
    s3.access_key_id      = ENV.fetch('AWS_ACCESS_KEY')
    s3.secret_access_key  = ENV.fetch('AWS_SECRET_KEY')
    s3.bucket             = 'rubygems-dumps'
    s3.region             = 'us-west-2'
    s3.path               = ENV.fetch('DEPLOYMENT_ENV')
  end

  notify_by Slack do |slack|
    slack.on_success  = false
    slack.on_warning  = true
    slack.on_failure  = true
    slack.webhook_url = ENV.fetch('SLACK_WEBHOOK_URL')
  end

end
