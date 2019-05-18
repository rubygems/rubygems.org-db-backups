#!/usr/bin/env bash
#
# Generates an encrypted backup of the RubyGems database and uploads it to S3.

backup perform --trigger postgresql --config-file ../config/postgresql.rb
