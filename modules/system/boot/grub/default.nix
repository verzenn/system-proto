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
      timeout = 0 |> lib.mkDefault;

      grub = {
        enable = true |> lib.mkForce;
        useOSProber = true |> lib.mkDefault;

        timeoutStyle = "hidden" |> lib.mkDefault;
        backgroundColor = "#000000" |> lib.mkOverride 999;
        splashImage = null |> lib.mkOverride 999;

        extraInstallCommands = let
          extraEntries = ''
            menuentry "Reboot" --class restart {
                  reboot
            }

            menuentry "Shutdown" --class shutdown {
                  halt
            }
          '';
        in
          lib.mkDefault ''
            echo "${extraEntries}" >> /boot/grub/grub.cfg
          '';

        efiSupport = true |> lib.mkDefault;
        device = "nodev" |> lib.mkDefault;
      };

      efi.canTouchEfiVariables = true |> lib.mkDefault;
    };
  };

  options.modules.${moduleName}.enable = lib.mkOption {
    description = "Enable the ${moduleName} module";
    default = true;
    type = lib.types.bool;
  };
}
