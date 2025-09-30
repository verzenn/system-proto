{
  users,
  modules,
  meta,
  inputs,
  lib,
  ...
}: {
  flake.homeConfigurations =
    meta.hosts
    |> lib.foldlAttrs
    (
      acc: hostname: host:
        acc
        // (
          lib.listToAttrs (
            host.users
            |> lib.map (
              username: {
                name = "${username}@${hostname}";
                value = inputs.home-manager.lib.homeManagerConfiguration {
                  pkgs = inputs.nixpkgs.legacyPackages.${host.system};
                  modules = [users];

                  extraSpecialArgs = {
                    inherit username hostname host inputs;
                    modules = modules.home;
                  };
                };
              }
            )
          )
        )
    )
    {};
}
