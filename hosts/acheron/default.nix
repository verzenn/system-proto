{
  modules,
  inputs,
  pkgs,
  config,
  ...
}: {
  imports =
    [
      "${modules}/boot/grub"
      #"${modules}/boot/plymouth"

      "${modules}/hardware/networkmanager"
      "${modules}/hardware/pipewire"
      #"${modules}/hardware/bluetooth"

      #"${modules}/hardware/graphics/opengl"
      #"${modules}/hardware/graphics/nvidia"
      #"${modules}/hardware/graphics/intel"

      #"${modules}/services/polkit"
      #"${modules}/services/firewall"

      "${modules}/desktop/niri"
    ]
    ++ [
      ./disks.nix
      ./hardware.nix
    ];

  virtualisation.docker = {
    enable = false;

    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  #fonts.fontconfig.enable = true;
  #services.upower.enable = true;

  #time.timeZone = "Europe/Prague";

  #services.xserver.xkb = {
  #  layout = "us,cz";
  #  variant = ",qwerty";
  #};

  users.users.verz.extraGroups = [
    "networkmanager"

    # kanata
    "uinput"
    "input"

    "docker"

    "wheel"
  ];

  # kanata
  hardware.uinput.enable = true;

  # tty1 autologin
  #systemd.services."getty@tty1" = let
  #  user = "verz";
  #in {
  #  overrideStrategy = "asDropin";
  #  serviceConfig.ExecStart = ["" "@${pkgs.util-linux}/sbin/agetty agetty --login-program ${config.services.getty.loginProgram} --autologin ${user} --noclear --keep-baud %I 115200,38400,9600 $TERM"];
  #};
}
