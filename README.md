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
