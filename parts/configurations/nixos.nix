{
  hosts,
  modules,
  meta,
  inputs,
  lib,
  ...
}: let
  cacheHostSuffix = "/cache";
in {
  flake.nixosConfigurations =
    (lib.attrNames meta.hosts)
    |> lib.foldl' (
      acc: hostname: let
        host = meta.hosts.${hostname};
      in
        acc
        // {
          ${hostname} = host // {cached = true;};
          ${hostname + cacheHostSuffix} = host // {cached = false;};
        }
    ) {}
    |> lib.mapAttrs (
      hostname: host: let
        normalizedHostname = hostname |> lib.replaceStrings [cacheHostSuffix] [""];
      in
        inputs.nixpkgs.lib.nixosSystem {
          inherit (host) system;
          modules = [hosts];

          specialArgs = {
            inherit host inputs;

            hostname = normalizedHostname;
            modules = modules.system;
          };
        }
    );
}
