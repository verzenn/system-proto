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
        keymaps = [
          {
            key = "<C-e>";
            mode = ["n" "x" "v"];
            silent = true;
            action = ":NvimTreeToggle<CR>";
          }
        ];

        startPlugins = [
          "neo-tree-nvim"
          "lualine-nvim"
        ];

        languages.typst.extensions.typst-preview-nvim.enable = true;
        languages.typst.enable = true;
        languages.typst.lsp.enable = true;

        statusline.lualine.enable = true;
        filetree.nvimTree = {
          enable = true;

          setupOpts = {
            disable_netrw = true;
            hijack_netrw = true;
            #open_on_setup = false;
            hijack_cursor = true;

            update_focused_file = {
              enable = true;
            };

            diagnostics = {
              enable = true;
              icons = {
                hint = "";
                info = "";
                warning = "";
                error = "";
              };
            };

            git = {
              enable = true;
              ignore = true;
              timeout = 500;
            };

            view = {
              width = 30;
              side = "left";
              number = false;
              relativenumber = true;
              signcolumn = "yes";
            };

            renderer = {
              group_empty = true;
              icons.show.git = true;
              highlight_git = true;
            };

            auto_close = true;
          };
        };

        viAlias = false;
        vimAlias = true;

        lsp = {
          enable = true;
        };
      };
    };
  };

  options.modules.${moduleName}.enable = lib.mkOption {
    description = "Enable the ${moduleName} module";
    default = true;
    type = lib.types.bool;
  };
}
