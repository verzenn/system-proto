{
  system,
  hosts,
  meta,
  inputs,
  lib,
  ...
}: {
  flake.nixosConfigurations =
    meta.hosts
    |> lib.mapAttrs (
      hostname: host:
        inputs.nixpkgs.lib.nixosSystem {
          inherit (host) system;
          modules = [hosts];

          specialArgs = {
            inherit system hostname host inputs;
          };
        }
    );
}
