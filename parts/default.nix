{
  hosts,
  users,
  modules,
  meta,
  inputs,
}:
inputs.parts.lib.mkFlake {inherit inputs;} {
  inherit (meta) systems;

  _module.args = {
    inherit hosts users modules meta inputs;
    inherit (inputs.nixpkgs) lib;
  };

  imports = [
    ./configurations/nixos.nix
    ./configurations/home.nix

    ./tooling/formatter.nix
  ];
}
