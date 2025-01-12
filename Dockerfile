FROM ruby:3.1-alpine

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
# Required to install ovirt-engine-sdk with cflags to apply workaround like https://github.com/oVirt/ovirt-engine-sdk-ruby/issues/14#issuecomment-2098809409
RUN gem install ovirt-engine-sdk --no-doc --version 4.6.0 -- --with-cflags="-Wno-error=incompatible-pointer-types -Wno-error=implicit-function-declaration" && \
  gem install backup --no-doc --version 5.0.0.beta3

# Copy the directories from the repo to the container.
COPY . .

# By default we'll just error out, given that we expect this container to be
# run in the context of a Kubernetes cluster executing a different command.
CMD ["echo", "FATAL: no command entrypoint provided in deployment YAML"]