{
  lib,
  config,
  inputs,
  ...
}: let
  moduleName = "zen";
in {
  imports = [inputs.zen.homeModules.twilight];

  config = lib.mkIf config.modules.${moduleName}.enable {
    programs.zen-browser.enable = true;
  };

  options.modules.${moduleName}.enable = lib.mkOption {
    description = "Enable the ${moduleName} module";
    default = true;
    type = lib.types.bool;
  };
}
