{
  inputs,
  system,
  pkgs,
  config,
  ...
}: {
  imports = [
    "${system}/boot/grub"
    "${system}/boot/plymouth"

    "${system}/hardware/networkmanager"
    "${system}/hardware/pipewire"
    "${system}/hardware/bluetooth"

    "${system}/hardware/graphics/opengl"
    "${system}/hardware/graphics/nvidia"
    "${system}/hardware/graphics/intel"

    "${system}/services/polkit"
    "${system}/services/firewall"

    "${system}/desktop/niri"

    ./disks.nix
    ./hardware.nix
  ];

  fonts.fontconfig.enable = true;
  services.upower.enable = true;

  time.timeZone = "Europe/Prague";

  services.xserver.xkb = {
    layout = "us,cz";
    variant = ",qwerty";
  };

  users.users.verz.extraGroups = [
    "networkmanager"

    # kanata
    "uinput"
    "input"

    "wheel"
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
