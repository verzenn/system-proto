{
  hosts,
  users,
  modules,
  meta,
  inputs,
  lib,
}:
inputs.parts.lib.mkFlake {inherit inputs;} {
  imports = [
    ./configurations/nixos.nix
    ./configurations/home.nix

    ./tooling/formatter.nix
  ];

  _module.args = {
    inherit hosts users modules meta inputs lib;
  };

  systems =
    meta.hosts
    |> lib.attrValues
    |> map (host: host.system)
    |> lib.unique;
}
