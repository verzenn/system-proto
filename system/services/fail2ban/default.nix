{
  lib,
  config,
  ...
}: let
  moduleName = "fail2ban";
in {
  config = lib.mkIf config.modules.${moduleName}.enable {
    services.fail2ban.enable = true |> lib.mkForce;
  };

  options.modules.${moduleName}.enable = lib.mkOption {
    description = "Enable the ${moduleName} module";
    default = true;
    type = lib.types.bool;
  };
}
