{
  host,
  inputs,
  lib,
  config,
  ...
}: let
  moduleName = "ghostty";
in {
  config = lib.mkIf config.modules.${moduleName}.enable {
    programs.ghostty = {
      enable = true;
      enableZshIntegration = false;

      settings = {
        theme = "nord";
      };
    };
  };

  options.modules.${moduleName}.enable = lib.mkOption {
    description = "Enable the ${moduleName} module";
    default = true;
    type = lib.types.bool;
  };
}
