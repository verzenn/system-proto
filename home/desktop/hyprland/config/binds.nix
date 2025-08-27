{
  moduleName,
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf config.modules.${moduleName}.enable {
  wayland.windowManager.hyprland.settings = {
    bind = lib.mkDefault (
      [
        # --- desktop binds --- #
        "SUPER, X, killactive,"

        "SUPER, RETURN, exec, ${pkgs.app2unit}/bin/app2unit -- ${pkgs.kitty}/bin/kitty"

        # --- moving focus between windows --- #
        "SUPER, H, movefocus, l"
        "SUPER, L, movefocus, r"
        "SUPER, K, movefocus, u"
        "SUPER, J, movefocus, d"

        # --- swapping windows --- #
        "SUPER ALT, H, swapwindow, l"
        "SUPER ALT, L, swapwindow, r"
        "SUPER ALT, K, swapwindow, u"
        "SUPER ALT, J, swapwindow, d"
      ]
      ++ (
        lib.concatLists (10
          |> lib.genList (
            i: let
              wsNumber = toString (i + 1);
              key =
                if i == 9
                then "0"
                else wsNumber;
            in [
              # --- switching to a workspace ---
              "SUPER, ${key}, workspace, ${wsNumber}"

              # --- moving a window to a workspace ---
              "SUPER ALT, ${key}, movetoworkspace, ${wsNumber}"

              # --- moving a window to a workspace silently ---
              "SUPER ALT SHIFT, ${key}, movetoworkspacesilent, ${wsNumber}"
            ]
          ))
      )
    );
  };
}
