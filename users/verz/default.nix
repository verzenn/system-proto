{home, ...}: {
  imports = [
    "${home}/services/kanata"
    "${home}/services/hyprpolkit"

    "${home}/shell/zsh"
    "${home}/shell/starship"

    "${home}/desktop/hyprland"

    "${home}/apps/kitty"
    "${home}/apps/spotify"
    "${home}/apps/discord"

    ./packages.nix
  ];
}
