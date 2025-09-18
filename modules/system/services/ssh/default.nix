{
  lib,
  config,
  ...
}: let
  moduleName = "ssh";
in {
  config = lib.mkIf config.modules.${moduleName}.enable {
    services.openssh = {
      enable = true |> lib.mkForce;
      startWhenNeeded = true |> lib.mkDefault;

      ports = [999] |> lib.mkDefault;
      openFirewall = true |> lib.mkDefault;

      settings = {
        AllowUsers = ["verz"] |> lib.mkDefault;

        PasswordAuthentication = false |> lib.mkDefault;
        KbdInteractiveAuthentication = false |> lib.mkDefault;
        PermitRootLogin = "no" |> lib.mkDefault;
      };
    };
  };

  options.modules.${moduleName}.enable = lib.mkOption {
    description = "Enable the ${moduleName} module";
    default = true;
    type = lib.types.bool;
  };
}
