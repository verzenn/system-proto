{
  inputs,
  lib,
  config,
  ...
}: let
  moduleName = "discord";
in {
  imports = [inputs.discord.homeModules.default];

  config = lib.mkIf config.modules.${moduleName}.enable {
    programs.nixcord.enable = true |> lib.mkForce;
  };

  options.modules.${moduleName}.enable = lib.mkOption {
    description = "Enable the ${moduleName} module";
    default = true;
    type = lib.types.bool;
  };
}
