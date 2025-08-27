{
  moduleName,
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf config.modules.${moduleName}.enable {
  wayland.windowManager.hyprland.settings = {
    monitor = lib.mkDefault [
      ",preferred,auto,1.2,transform, 0"
    ];

    general = {
      layout = "dwindle" |> lib.mkDefault;

      allow_tearing = false |> lib.mkDefault;

      snap = {
        enabled = true |> lib.mkDefault;

        window_gap = 10 |> lib.mkDefault;
        monitor_gap = 10 |> lib.mkDefault;
        border_overlap = true |> lib.mkDefault;
      };

      resize_on_border = true |> lib.mkDefault;
      extend_border_grab_area = 15 |> lib.mkDefault;
    };

    dwindle = {
      pseudotile = true |> lib.mkDefault;
      preserve_split = true |> lib.mkDefault;
    };

    misc = {
      force_default_wallpaper = 0 |> lib.mkDefault;
      disable_hyprland_logo = true |> lib.mkDefault;
    };

    input = {
      kb_layout = "us" |> lib.mkDefault;

      follow_mouse = 1 |> lib.mkDefault;

      sensitivity = 0 |> lib.mkDefault;
      repeat_delay = 250 |> lib.mkDefault;

      touchpad = {
        natural_scroll = true |> lib.mkDefault;
        tap-to-click = true |> lib.mkDefault;
        drag_lock = 0 |> lib.mkDefault;
      };
    };

    gestures = {
      workspace_swipe = true |> lib.mkDefault;

      workspace_swipe_fingers = 3 |> lib.mkDefault;
      workspace_swipe_invert = true |> lib.mkDefault;
      workspace_swipe_forever = true |> lib.mkDefault;
      workspace_swipe_cancel_ratio = 0.25 |> lib.mkDefault;
    };
  };
}
