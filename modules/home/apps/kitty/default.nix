{
  lib,
  config,
  pkgs,
  ...
}: let
  moduleName = "kitty";
in {
  config = lib.mkIf config.modules.${moduleName}.enable {
    programs.kitty = {
      #enable = true |> lib.mkForce;
      #settings = {
      #  cursor_trail = 1;
      #  confirm_os_window_close = 0;
      #};

      #extraConfig = lib.mkBefore ''
      #  include colors.conf
      #'';
    };

    home.packages = with pkgs; [
      kitty
    ];
  };

  options.modules.${moduleName}.enable = lib.mkOption {
    description = "Enable the ${moduleName} module";
    default = true;
    type = lib.types.bool;
  };
}
