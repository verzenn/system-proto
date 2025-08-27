{
  pkgs,
  lib,
  config,
  ...
} @ _args: let
  moduleName = "kanata";
in {
  imports = [
    (_args // {inherit moduleName;} |> import ./config.nix)
  ];

  config = lib.mkIf config.modules.${moduleName}.enable {
    systemd.user.services.kanata = {
      Unit.Description = "Kanata, the keyboard remapper";
      Install.WantedBy = ["default.target"];

      Service = {
        ExecStart = "${pkgs.kanata-with-cmd}/bin/kanata";
        Restart = "on-failure";
      };
    };

    home = {
      packages = with pkgs; [
        kanata-with-cmd
        playerctl
        brightnessctl
        wireplumber
      ];
    };
  };

  options.modules.${moduleName}.enable = lib.mkOption {
    description = "Enable the ${moduleName} module";
    default = true;
    type = lib.types.bool;
  };
}
