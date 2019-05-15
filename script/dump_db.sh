#!/usr/bin/env bash
#
# Generates a public dump of the RubyGems database and uploads it to S3.

backup perform --trigger public_postgresql --config-file ../config/public_postgresql.rb
