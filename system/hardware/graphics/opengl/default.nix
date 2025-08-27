{
  lib,
  config,
  ...
}: let
  moduleName = "opengl";
in {
  config = lib.mkIf config.modules.${moduleName}.enable {
    hardware.graphics = {
      enable = true |> lib.mkForce;
      enable32Bit = true |> lib.mkDefault;
    };
  };

  options.modules.${moduleName}.enable = lib.mkOption {
    description = "Enable the ${moduleName} module";
    default = true;
    type = lib.types.bool;
  };
}
