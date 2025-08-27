{
  lib,
  config,
  ...
}: let
  moduleName = "networkmanager";
in {
  config = lib.mkIf config.modules.${moduleName}.enable {
    networking.networkmanager = {
      enable = true |> lib.mkForce;

      wifi.macAddress = "random" |> lib.mkDefault;
      ethernet.macAddress = "random" |> lib.mkDefault;
    };
  };

  options.modules.${moduleName}.enable = lib.mkOption {
    description = "Enable the ${moduleName} module";
    default = true;
    type = lib.types.bool;
  };
}
