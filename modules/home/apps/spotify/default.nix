{
  host,
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  moduleName = "spotify";

  inherit (inputs) spotify;
in {
  imports = [spotify.homeManagerModules.default];

  config = lib.mkIf config.modules.${moduleName}.enable {
    programs.spicetify = let
      spicetifyPkgs = spotify.legacyPackages.${host.system};
    in {
      enable = true |> lib.mkForce;

      enabledCustomApps = lib.mkDefault [
        {
          name = "lyrics-plus";
          src = pkgs.fetchFromGitHub {
            owner = "spicetify";
            repo = "cli";
            rev = "main";
            hash = "sha256-2fsHFl5t/Xo7W5IHGc5FWY92JvXjkln6keEn4BZerw4=";
          };
        }
      ];

      enabledExtensions = lib.mkDefault (with spicetifyPkgs.extensions; [
        adblock
        hidePodcasts
        shuffle
        keyboardShortcut
      ]);
    };
  };

  options.modules.${moduleName}.enable = lib.mkOption {
    description = "Enable the ${moduleName} module";
    default = true;
    type = lib.types.bool;
  };
}
