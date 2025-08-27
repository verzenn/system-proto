{
  moduleName,
  lib,
  config,
  ...
}:
lib.mkIf config.modules.${moduleName}.enable {
  wayland.windowManager.hyprland.settings = {
    general = {
      no_border_on_floating = false |> lib.mkDefault;

      gaps_in = 5 |> lib.mkDefault;
      gaps_out = 10 |> lib.mkDefault;
      gaps_workspaces = 0 |> lib.mkDefault;

      border_size = 0 |> lib.mkDefault;

      "col.active_border" = "rgba(ffffffff)" |> lib.mkDefault;
      "col.inactive_border" = "rgba(ffffffff)" |> lib.mkDefault;

      "col.nogroup_border_active" = "rgba(ffffffff)" |> lib.mkDefault;
      "col.nogroup_border" = "rgba(ffffffff)" |> lib.mkDefault;
    };

    decoration = {
      blur = {
        enabled = false |> lib.mkDefault;
      };

      rounding = 15 |> lib.mkDefault;
      rounding_power = 2 |> lib.mkDefault;

      active_opacity = 1.0 |> lib.mkDefault;
      inactive_opacity = 1.0 |> lib.mkDefault;
      fullscreen_opacity = 1.0 |> lib.mkDefault;
    };

    animations = {
      enabled = true |> lib.mkDefault;

      bezier = lib.mkDefault [
        "expressiveFastSpatial, 0.42, 1.67, 0.21, 0.90"
        "expressiveSlowSpatial, 0.39, 1.29, 0.35, 0.98"
        "expressiveDefaultSpatial, 0.38, 1.21, 0.22, 1.00"
        "emphasizedDecel, 0.05, 0.7, 0.1, 1"
        "emphasizedAccel, 0.3, 0, 0.8, 0.15"
        "standardDecel, 0, 0, 0, 1"
        "menu_decel, 0.1, 1, 0, 1"
        "menu_accel, 0.52, 0.03, 0.72, 0.08"
      ];

      animation = lib.mkDefault [
        "windowsIn, 1, 3, emphasizedDecel, popin 80%"
        "windowsOut, 1, 2, emphasizedDecel, popin 90%"
        "windowsMove, 1, 3, emphasizedDecel, slide"
        "border, 1, 10, emphasizedDecel"
        "layersIn, 1, 2.7, emphasizedDecel, popin 93%"
        "layersOut, 1, 2, menu_accel, popin 94%"
        "fadeLayersIn, 1, 0.5, menu_decel"
        "fadeLayersOut, 1, 2.2, menu_accel"
        "workspaces, 1, 7, menu_decel, slide"
        "specialWorkspaceIn, 1, 2.8, emphasizedDecel, slidevert"
        "specialWorkspaceOut, 1, 1.2, emphasizedAccel, slidevert"
      ];
    };
  };
}
