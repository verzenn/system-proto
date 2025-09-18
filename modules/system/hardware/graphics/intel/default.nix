{
  pkgs,
  lib,
  config,
  ...
}: let
  moduleName = "intel";
in {
  config = lib.mkIf config.modules.${moduleName}.enable {
    services.xserver.videoDrivers = ["modesetting"];

    hardware.graphics = {
      extraPackages = with pkgs; [
        intel-media-driver
      ];
    };

    environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";
  };

  options.modules.${moduleName}.enable = lib.mkOption {
    description = "Enable the ${moduleName} module";
    default = true;
    type = lib.types.bool;
  };
}
