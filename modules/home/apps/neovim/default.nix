{
  inputs,
  lib,
  config,
  ...
}: let
  moduleName = "neovim";
in {
  imports = [inputs.nvf.homeManagerModules.nvf];

  config = lib.mkIf config.modules.${moduleName}.enable {
    programs.nvf = {
      enable = true;
      settings.vim = {
        startPlugins = [
          "lualine-nvim"
        ];

        statusline.lualine.enable = true;

        viAlias = true;
        vimAlias = true;
      };
    };
  };

  options.modules.${moduleName}.enable = lib.mkOption {
    description = "Enable the ${moduleName} module";
    default = true;
    type = lib.types.bool;
  };
}
