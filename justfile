default:
  @echo "Building via nix..."
  just build-via-nix
  @echo "\nBuilding via docker..."
  just build-via-docker
  @echo "\nFinished. Listing images generated:"
  just list-docker-images

build-via-nix:
  nix build --rebuild ./nix#
  docker load < result

build-via-docker:
  docker build --no-cache -t nginx-webserver-docker-build:latest -f docker-build/Dockerfile .

list-docker-images:
  docker image ls | grep 'nginx-webserver'
