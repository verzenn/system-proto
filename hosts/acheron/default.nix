{
  system,
  pkgs,
  config,
  ...
}: {
  imports = [
    "${system}/bootloader/grub"

    "${system}/hardware/networkmanager"
    "${system}/hardware/pipewire"
    "${system}/hardware/bluetooth"

    "${system}/hardware/graphics/opengl"
    "${system}/hardware/graphics/nvidia"
    "${system}/hardware/graphics/intel"

    "${system}/services/polkit"
    "${system}/services/firewall"

    "${system}/desktop/hyprland"

    ./disks.nix
    ./hardware.nix
  ];

  users.users.verz.extraGroups = [
    "networkmanager"

    # kanata
    "uinput"
    "input"

    "wheel"
  ];

  programs.niri.enable = true;
  environment.systemPackages = with pkgs; [
    fuzzel
    alacritty
  ];

  # kanata
  hardware.uinput.enable = true;

  # tty1 autologin
  systemd.services."getty@tty1" = let
    user = "verz";
  in {
    overrideStrategy = "asDropin";
    serviceConfig.ExecStart = ["" "@${pkgs.util-linux}/sbin/agetty agetty --login-program ${config.services.getty.loginProgram} --autologin ${user} --noclear --keep-baud %I 115200,38400,9600 $TERM"];
  };
}
