{
  host,
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  moduleName = "niri";
in {
  imports = [inputs.niri.nixosModules.niri];

  config = lib.mkIf config.modules.${moduleName}.enable {
    nix.settings = {
      substituters = ["https://niri.cachix.org/"];
      trusted-public-keys = ["niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="];
    };

    nixpkgs.overlays = [inputs.niri.overlays.niri];

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1" |> lib.mkDefault;
      ELECTRON_OZONE_PLATFORM_HINT = "wayland" |> lib.mkDefault;
    };

    systemd.user.services.niri-flake-polkit.enable = false;
    niri-flake.cache.enable = false;

    programs.niri = {
      enable = host.cached;
      package = pkgs.niri-unstable;
    };
  };

  options.modules.${moduleName}.enable = lib.mkOption {
    description = "Enable the ${moduleName} module";
    default = true;
    type = lib.types.bool;
  };
}
