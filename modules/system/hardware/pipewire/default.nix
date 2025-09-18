{
  lib,
  config,
  ...
}: let
  moduleName = "pipewire";
in {
  config = lib.mkIf config.modules.${moduleName}.enable {
    services.pipewire = {
      enable = true |> lib.mkForce;
      audio.enable = true |> lib.mkDefault;

      wireplumber.enable = true |> lib.mkDefault;

      pulse.enable = true |> lib.mkDefault;

      alsa = {
        enable = true |> lib.mkDefault;
        support32Bit = true |> lib.mkDefault;
      };
    };

    security.rtkit.enable = true |> lib.mkDefault;
  };

  options.modules.${moduleName}.enable = lib.mkOption {
    description = "Enable the ${moduleName} module";
    default = true;
    type = lib.types.bool;
  };
}
