{
  lib,
  config,
  ...
}: let
  moduleName = "nvidia";
in {
  config = lib.mkIf config.modules.${moduleName}.enable {
    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      prime = lib.mkIf config.modules."intel".enable {
        offload = {
          enable = true |> lib.mkOverride 999;

          enableOffloadCmd = true |> lib.mkDefault;
          offloadCmdMainProgram = "offload" |> lib.mkDefault;
        };

        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };

      open = true |> lib.mkDefault;
      modesetting.enable = true |> lib.mkForce;

      powerManagement.enable = false |> lib.mkDefault;
      powerManagement.finegrained = true |> lib.mkDefault;

      nvidiaSettings = false |> lib.mkDefault;

      package = config.boot.kernelPackages.nvidiaPackages.latest |> lib.mkDefault;
    };
  };

  options.modules.${moduleName}.enable = lib.mkOption {
    description = "Enable the ${moduleName} module";
    default = true;
    type = lib.types.bool;
  };
}
