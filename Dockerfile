FROM ruby:2.3-alpine

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
  && rm -rf /var/cache/apk/*

# Install the backup gem which is currently used to run backups.
RUN gem install backup --no-doc

# Copy the directories from the repo to the container.
COPY . .

# By default we'll just error out, given that we expect this container to be
# run in the context of a Kubernetes cluster executing a different command.
CMD ["echo", "FATAL: no command entrypoint provided in deployment YAML"]