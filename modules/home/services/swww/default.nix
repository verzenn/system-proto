{
  lib,
  config,
  ...
}: let
  moduleName = "swww";
in {
  config = lib.mkIf config.modules.${moduleName}.enable {
    services.swww.enable = true;
  };

  options.modules.${moduleName}.enable = lib.mkOption {
    description = "Enable the ${moduleName} module";
    default = true;
    type = lib.types.bool;
  };
}
