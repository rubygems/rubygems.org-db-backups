FROM ruby:2.7-alpine

RUN apk add --no-cache \
  postgresql-client \
  postgresql-dev \
  ca-certificates \
  ruby-dev \
  build-base \
  bash \
  linux-headers \
  zlib-dev \
  libxml2-dev \
  libxslt-dev \
  tzdata \
  curl-dev \
  openssl \
  && rm -rf /var/cache/apk/*

# Install the backup gem which is currently used to run backups.
RUN gem install --no-doc backup:5.0.0.beta3 nokogiri:1.15.5

# Copy the directories from the repo to the container.
COPY . .

# By default we'll just error out, given that we expect this container to be
# run in the context of a Kubernetes cluster executing a different command.
CMD ["echo", "FATAL: no command entrypoint provided in deployment YAML"]