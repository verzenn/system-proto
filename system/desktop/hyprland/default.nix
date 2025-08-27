{
  host,
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  moduleName = "hyprland";
in {
  config = lib.mkIf config.modules.${moduleName}.enable {
    nix.settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };

    programs.uwsm.enable = true |> lib.mkForce;
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1" |> lib.mkDefault;
      ELECTRON_OZONE_PLATFORM_HINT = "wayland" |> lib.mkDefault;

      APP2UNIT_SLICES = "a=app-graphical.slice b=background-graphical.slice s=session-graphical.slice" |> lib.mkDefault;
    };

    programs.hyprland = let
      hyprPackages = inputs.hyprland.packages.${host.system};
    in {
      enable = true |> lib.mkForce;
      withUWSM = true |> lib.mkForce;

      xwayland.enable = true |> lib.mkDefault;

      package = hyprPackages.hyprland |> lib.mkDefault;
      portalPackage = hyprPackages.xdg-desktop-portal-hyprland |> lib.mkDefault;
    };

    environment.systemPackages = with pkgs; [
      app2unit
      kitty
    ];
  };

  options.modules.${moduleName}.enable = lib.mkOption {
    description = "Enable the ${moduleName} module";
    default = true;
    type = lib.types.bool;
  };
}
