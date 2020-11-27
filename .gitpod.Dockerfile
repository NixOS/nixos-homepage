FROM nixos/nix

RUN chown -R 33333:33333 /nix \
 && echo "substituters = https://cache.nixos.org https://cache.nixos.org/ https://nixos-homepage.cachix.org" >> /etc/nix/nix.conf \
 && echo "trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nixos-homepage.cachix.org-1:NHKBt7NjLcWfgkX4OR72q7LVldKJe/JOsfIWFDAn/tE=" >> /etc/nix/nix.conf
