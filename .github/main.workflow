workflow "Docker image" {
  resolves = ["Push docker image"]
  on = "push"
}

action "Build Docker image" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  args = ["build", "quay.io/rubygems/rubygems.org-db-backups:$GITHUB_SHA", "."]
}

action "Master branch only" {
  uses = "actions/bin/filter@3c0b4f0e63ea54ea5df2914b4fabf383368cd0da"
  needs = ["Build Docker image"]
  args = "branch master"
}


action "Docker Registry" {
  uses = "actions/docker/login@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  needs = ["Master branch only"]
  secrets = ["DOCKER_REGISTRY_URL", "DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "Push docker image" {
  uses = "actions/docker/login@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  args = "push quay.io/rubygems/rubygems.org-db-backups:$GITHUB_SHA"
  needs = ["Master branch only", "Docker Registry"]
}
