{
  pkgs,
  lib,
  config,
  ...
}: let
  moduleName = "firewall";
in {
  config = lib.mkIf config.modules.${moduleName}.enable {
    networking = {
      firewall = {
        enable = true |> lib.mkForce;
        package = pkgs.nftables |> lib.mkDefault;
      };

      nftables.enable = true |> lib.mkDefault;
    };
  };

  options.modules.${moduleName}.enable = lib.mkOption {
    description = "Enable the ${moduleName} module";
    default = true;
    type = lib.types.bool;
  };
}
