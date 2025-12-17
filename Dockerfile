FROM nixos/nix

RUN echo 'experimental-features = nix-command flakes' | tee -a /etc/nix/nix.conf

WORKDIR /app
