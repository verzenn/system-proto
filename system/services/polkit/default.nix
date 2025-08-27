{
  lib,
  config,
  ...
}: let
  moduleName = "polkit";
in {
  config = lib.mkIf config.modules.${moduleName}.enable {
    security.polkit.enable = true |> lib.mkForce;
  };

  options.modules.${moduleName}.enable = lib.mkOption {
    description = "Enable the ${moduleName} module";
    default = true;
    type = lib.types.bool;
  };
}
