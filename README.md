# Nix vs Traditional Docker Build Comparison

This project demonstrates and compares two approaches to building Docker images for a simple Nginx web server:

1. **Traditional Docker Build** - Using a standard Dockerfile with the `nginx:alpine` base image
2. **Nix Docker Build** - Using Nix flakes with `dockerTools.buildImage` for reproducible builds

## Project Structure

```
├── README.md                 # This file
├── justfile                  # Task runner with build commands
├── docker-build/
│   └── Dockerfile           # Traditional Docker build definition
├── nix/
│   ├── flake.nix           # Nix flake for reproducible Docker image building
│   └── flake.lock          # Locked dependencies for reproducibility
└── sample-project/
    ├── index.html          # Simple HTML page served by Nginx
    └── nginx.conf          # Custom Nginx configuration
```

## Prerequisites

Make sure you have the following installed:
- **Docker** - For building and running containers
- **Nix** - With flakes enabled (`nix.settings.experimental-features = [ "nix-command" "flakes" ];`)
- **Just** - Task runner (optional, can run commands manually)

## Quick Start

Build both images and compare them:

```sh
just
```

This will:
1. Build the Docker image using Nix
2. Build the Docker image using traditional Docker
3. List both images for comparison

## Conclusions

1. **Nix produces truly "distroless" images**: Unlike the traditional Docker build that starts with a base image (including package managers, shells, and utilities), the Nix build creates a minimal image containing only the Nginx binary and its exact runtime dependencies. This significantly reduces attack surface and image size.
2. **Fine-grained dependency control**: The Nix flake explicitly declares every component - from the Nginx package to configuration files and directory structure. Traditional Dockerfiles inherit whatever is in the base image, while Nix builds everything from a known, reproducible state.
3. **Guaranteed reproducibility**: With `flake.lock` pinning exact versions and hashes, the Nix build produces bit-for-bit identical images across different machines and time periods. Docker builds can vary due to base image updates or build environment differences.
