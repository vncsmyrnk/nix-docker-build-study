{
  description = "A flake for building a simple Nginx Docker image";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      # We are building a Docker image, so we target a Linux system.
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      # Define variables for our external files. Nix will handle resolving
      # the paths and copying them into the Nix store.
      indexHtml = ../sample-project/index.html;
      nginxConf = ../sample-project/nginx.conf;

      # The Docker image derivation.
      nginxImage = pkgs.dockerTools.buildImage {
        name = "nginx-webserver-nix-build";
        tag = "latest";

        # Add the Nginx package to the image. `copyToRoot` is the modern replacement
        # for the deprecated `contents` parameter.
        copyToRoot = pkgs.buildEnv {
          name = "image-root";
          paths = [ pkgs.nginx ];
        };

        # Create directories and copy our custom files into the image.
        runAsRoot = ''
          #!${pkgs.runtimeShell}
          # Create a non-root user and group for Nginx to run as.
          mkdir -p /etc
          echo "nogroup:x:65534:" > /etc/group
          echo "nobody:x:65534:65534:Nginx non-root user:/var/lib/nginx:/sbin/nologin" > /etc/passwd

          # Create directories and set correct permissions for the new user.
          mkdir -p /var/www /var/log/nginx /var/lib/nginx
          chown -R nobody:nogroup /var/log/nginx /var/lib/nginx

          cp ${indexHtml} /var/www/index.html
          # Copy Nginx config and default mime.types for correct content-type headers.
          mkdir -p /etc/nginx
          cp ${nginxConf} /etc/nginx/nginx.conf
          cp ${pkgs.nginx}/conf/mime.types /etc/nginx/mime.types
        '';

        # Configure container metadata.
        config = {
          # Command to run when the container starts.
          Cmd = [ "${pkgs.nginx}/bin/nginx" "-c" "/etc/nginx/nginx.conf" "-g" "daemon off;" ];
          ExposedPorts = { "80/tcp" = {}; };
        };
      };

    in
    {
      # The main output of our flake, accessible via `nix build .#`
      packages.${system}.default = nginxImage;
    };
}
