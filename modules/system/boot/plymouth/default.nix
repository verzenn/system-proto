{
  pkgs,
  lib,
  config,
  ...
}: let
  moduleName = "plymouth";
in {
  config = lib.mkIf config.modules.${moduleName}.enable {
    boot = {
      plymouth = {
        enable = true;
        theme = "deus_ex";
        themePackages = with pkgs; [
          # By default we would install all themes
          (adi1090x-plymouth-themes.override {
            selected_themes = ["deus_ex"];
          })
        ];
      };

      # Enable "Silent boot"
      consoleLogLevel = 3;
      initrd = {
        kernelModules = ["i915"];
        #extraModulePackages = [ ];
        verbose = false;
      };

      kernelParams = [
        "quiet"
        "splash"
        #"boot.shell_on_fail"
        "udev.log_priority=3"
        "rd.systemd.show_status=auto"
      ];
    };
  };

  options.modules.${moduleName}.enable = lib.mkOption {
    description = "Enable the ${moduleName} module";
    default = true;
    type = lib.types.bool;
  };
}
