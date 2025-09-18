{
  inputs,
  modules,
  pkgs,
  ...
}: {
  imports =
    [
      #"${modules}/services/kanata"
      #"${modules}/services/hyprpolkit"

      #"${modules}/shell/zsh"
      #"${modules}/shell/starship"

      #"${modules}/desktop/niri"

      #"${modules}/apps/neovim"
      #"${modules}/apps/kitty"
      #"${modules}/apps/spotify"
      #"${modules}/apps/discord"
    ]
    ++ [
      #./packages.nix
    ];

  #fonts.fontconfig.enable = true;

  #dconf.settings = {
  #  "org/gnome/desktop/background" = {
  #    picture-uri-dark = "file://${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.src}";
  #  };
  #  "org/gnome/desktop/interface" = {
  #    color-scheme = "prefer-dark";
  #  };
  #};

  #gtk = {
  #  enable = true;
  #  theme = {
  #    name = "Adwaita-dark";
  #    package = pkgs.gnome-themes-extra;
  #  };
  #};

  #home.packages = with pkgs; [
  #  kdePackages.qt5compat # For Qt5Compat.GraphicalEffects
  #  kdePackages.qtdeclarative # For QML
  #  kdePackages.kdialog
  #  kdePackages.qtwayland # For Wayland support
  #  kdePackages.qtpositioning # For Weather service location features
  #  kdePackages.qtlocation # Additional location services for QtPositioning

  #  material-symbols
  #  wlsunset
  #  inputs.swww.packages.${host.system}.swww # waiting for nixpkgs unstable to support this

  #  youtube-music
  #  typst

  #  nodePackages_latest.nodejs
  #];

  #qt.enable = true;
  #qt.platformTheme.name = "kde";

  #programs.quickshell.enable = true;
  #programs.quickshell.systemd.enable = true;
}
