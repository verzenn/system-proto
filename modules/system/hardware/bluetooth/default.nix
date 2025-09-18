{
  lib,
  config,
  ...
}: let
  moduleName = "bluetooth";
in {
  config = lib.mkIf config.modules.${moduleName}.enable {
    hardware.bluetooth = {
      enable = true |> lib.mkForce;
      powerOnBoot = false |> lib.mkDefault;
    };
  };

  options.modules.${moduleName}.enable = lib.mkOption {
    description = "Enable the ${moduleName} module";
    default = true;
    type = lib.types.bool;
  };
}
