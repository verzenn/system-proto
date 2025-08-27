{
  host,
  inputs,
  pkgs,
  lib,
  config,
  ...
} @ _args: let
  moduleName = "hyprland";

  args = _args // {inherit moduleName;};
in {
  imports = [
    (args |> import ./config/general.nix)
    (args |> import ./config/binds.nix)
    (args |> import ./config/style.nix)
  ];

  config = lib.mkIf config.modules.${moduleName}.enable {
    wayland.windowManager.hyprland = {
      enable = true |> lib.mkForce;
      systemd.enable = false |> lib.mkForce; # avoid conflicts with uwsm

      # inherit system packages
      package = null |> lib.mkDefault;
      portalPackage = null |> lib.mkDefault;
    };
  };

  options.modules.${moduleName}.enable = lib.mkOption {
    description = "Enable the ${moduleName} module";
    default = true;
    type = lib.types.bool;
  };
}
