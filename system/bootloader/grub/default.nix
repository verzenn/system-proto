{
  pkgs,
  lib,
  config,
  ...
}: let
  moduleName = "grub";
in {
  config = lib.mkIf config.modules.${moduleName}.enable {
    boot.loader = {
      timeout = null |> lib.mkDefault;
      efi.canTouchEfiVariables = true |> lib.mkDefault;

      grub = let
        extraEntries = ''
          menuentry "Reboot" --class restart {
          	reboot
          }

          menuentry "Shutdown" --class shutdown {
          	halt
          }
        '';
      in {
        enable = true |> lib.mkForce;

        configurationLimit = 10 |> lib.mkDefault;

        useOSProber = true |> lib.mkDefault;
        efiSupport = true |> lib.mkDefault;
        device = "nodev" |> lib.mkDefault;

        backgroundColor = "#000000" |> lib.mkOverride 999;
        splashImage = null |> lib.mkOverride 999;

        extraInstallCommands = lib.mkDefault ''
          echo "${extraEntries}" >> /boot/grub/grub.cfg
        '';
      };
    };
  };

  options.modules.${moduleName}.enable = lib.mkOption {
    description = "Enable the ${moduleName} module";
    default = true;
    type = lib.types.bool;
  };
}
