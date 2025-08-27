{
  system,
  home,
  hosts,
  users,
  meta,
  inputs,
}:
inputs.flake-parts.lib.mkFlake {inherit inputs;} {
  inherit (meta) systems;

  _module.args = {
    inherit system home hosts users meta inputs;
    inherit (inputs.nixpkgs) lib;
  };

  imports = [
    ./configurations/nixos.nix
    ./configurations/home.nix

    ./tooling/formatter.nix
  ];
}
