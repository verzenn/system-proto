{
  host,
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  moduleName = "niri";
in {
  imports = [inputs.niri.homeModules.niri];

  config = lib.mkIf config.modules.${moduleName}.enable {
    nixpkgs.overlays = [inputs.niri.overlays.niri];

    programs.niri = {
      enable = true;
      package = pkgs.niri-unstable;
      settings = {
        # internal laptop display
        outputs."eDP-1" = {
          variable-refresh-rate = true;

          mode = {
            width = 1920;
            height = 1080;
            refresh = 144.003;
          };

          scale = 1.2;
        };

        prefer-no-csd = true; # no window decorations
        hotkey-overlay.skip-at-startup = true; # dont display keybinds on startup
        screenshot-path = null; # wont be using the built in screenshot tool

        spawn-at-startup = [
          #{command = ["${inputs.swww.packages.${host.system}.swww}/bin/swww-daemon" "-n" "workspace-background"];}
          #{command = ["${inputs.swww.packages.${host.system}.swww}/bin/swww-daemon" "-n" "overview-background"];}
        ];

        input = {
          focus-follows-mouse = {
            enable = true;
            max-scroll-amount = "0%";
          };

          #workspace-auto-back-and-forth maybe enable this later?

          keyboard.repeat-delay = 400;

          touchpad = {
            enable = true;
            drag-lock = true; # wish i could change the timeout
          };

          mouse.enable = true;

          trackpoint.enable = false;
          trackball.enable = false;
          tablet.enable = false;
          touch.enable = false;
        };

        binds = with config.lib.niri.actions; let
          sh = spawn "sh" "-c";
        in {
          # focusing columns/workspaces
          "Mod+J".action = focus-workspace-down;
          "Mod+K".action = focus-workspace-up;
          "Mod+H".action = focus-column-left;
          "Mod+L".action = focus-column-right;
          "Mod+U".action = focus-column-first;
          "Mod+I".action = focus-column-last;

          # focusing and consuming/expeling windows
          "Mod+Down".action = focus-window-down-or-top;
          "Mod+Up".action = focus-window-up-or-bottom;
          "Mod+Left".action = consume-or-expel-window-left;
          "Mod+Right".action = consume-or-expel-window-right;

          # moving columns/workspaces
          "Mod+Alt+J".action = move-workspace-down;
          "Mod+Alt+K".action = move-workspace-up;
          "Mod+Alt+H".action = move-column-left;
          "Mod+Alt+L".action = move-column-right;
          "Mod+Alt+U".action = move-column-to-first;
          "Mod+Alt+I".action = move-column-to-last;

          # moving/swapping windows
          "Mod+Alt+Down".action = move-window-down;
          "Mod+Alt+Up".action = move-window-up;
          "Mod+Alt+Left".action = swap-window-left;
          "Mod+Alt+Right".action = swap-window-right;

          #"Mod+1".action.focus-column = 1;
          #"Mod+2".action.focus-column = 2;
          #"Mod+3".action.focus-column = 3;
          #"Mod+4".action.focus-column = 4;
          #"Mod+5".action.focus-column = 5;
          #"Mod+6".action.focus-column = 6;
          #"Mod+7".action.focus-column = 7;
          #"Mod+8".action.focus-column = 8;
          #"Mod+9".action.focus-column = 9;
          #"Mod+0".action.focus-column = 10;

          "Mod+X".action = close-window;
          "Mod+O" = {
            action = toggle-overview;
            repeat = false;
          };
          "Mod+F".action = maximize-column;
          "Mod+Alt+F".action = fullscreen-window;
          "Mod+R".action = switch-preset-column-width;
          "Mod+W".action = toggle-column-tabbed-display;
          "Mod+Escape".action = toggle-keyboard-shortcuts-inhibit;

          "Mod+Return".action = spawn "${pkgs.kitty}/bin/kitty";
          "Mod+Space".action = sh "qs ipc call appLauncher toggle";
        };

        layer-rules = [
          {
            matches = [{namespace = "overview-background";}];
            place-within-backdrop = true;
          }
        ];

        window-rules = [
          {
            geometry-corner-radius = let
              radius = 16.0;
            in {
              top-left = radius;
              top-right = radius;
              bottom-left = radius;
              bottom-right = radius;
            };

            clip-to-geometry = true;
          }
        ];

        overview = {
          zoom = 0.65;
          workspace-shadow.enable = true;
        };

        layout = {
          empty-workspace-above-first = true;

          center-focused-column = "never";

          background-color = "transparent";

          gaps = 12;

          # maximize new windows
          default-column-width.proportion = 1.0;

          focus-ring.enable = false;
          border = {
            enable = true;

            width = 2;

            active.color = "#ffffff";
            inactive.color = "#000000";
          };

          tab-indicator = {
            enable = true;

            corner-radius = 6;
            position = "right";
            place-within-column = true;
            width = 6;
            length.total-proportion = 1. / 3.;
            gap = 8;
            gaps-between-tabs = 12;
          };

          insert-hint = {
            enable = true;
            display.color = "rgba(255, 255, 255, 0.25)";
          };

          preset-column-widths = [
            {proportion = 1. / 3.;}
            {proportion = 1. / 2.;}
            {proportion = 2. / 3.;}
          ];
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
