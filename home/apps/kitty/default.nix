{
  lib,
  config,
  ...
}: let
  moduleName = "kitty";
in {
  config = lib.mkIf config.modules.${moduleName}.enable {
    programs.kitty.enable = true |> lib.mkForce;
  };

  options.modules.${moduleName}.enable = lib.mkOption {
    description = "Enable the ${moduleName} module";
    default = true;
    type = lib.types.bool;
  };
}
