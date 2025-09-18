{
  hostname,
  host,
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = with inputs;
    [
      disko.nixosModules.disko
      impermanence.nixosModules.impermanence
    ]
    ++ [
      ./${hostname}
    ];

  environment.systemPackages = [
    pkgs.git
    inputs.home-manager.packages.${host.system}.home-manager
  ];

  networking.hostName = hostname |> lib.mkDefault;

  users.defaultUserShell = pkgs.zsh |> lib.mkOverride 999;
  programs.zsh.enable = true |> lib.mkDefault;

  users.users =
    lib.genAttrs host.users
    (username: user: {
      isNormalUser = true |> lib.mkDefault;
      initialPassword = username |> lib.mkDefault;
    })
    // {
      root.initialPassword = "root" |> lib.mkDefault;
    };

  environment.persistence."/nix/persist" = {
    hideMounts = true |> lib.mkDefault;

    directories = [
      "/etc/NetworkManager/system-connections" # network connections
      "/var/lib/bluetooth" # bluetooth pairings

      "/var/lib/nixos" # nixos state

      "/var/log" # logs
      "/var/lib/systemd/coredump" # systemd crash dumps

      "/var/lib/systemd/timers" # systemd timers

      "/var/db/sudo"
    ];

    files = [
      "/etc/machine-id"
    ];
  };

  services.dbus.implementation = "broker" |> lib.mkDefault;

  nix.gc = {
    automatic = true |> lib.mkDefault;
    dates = "weekly" |> lib.mkDefault;
  };

  nix = {
    channel.enable = false |> lib.mkDefault;
    nixPath = ["nixpkgs=${inputs.nixpkgs}"] |> lib.mkDefault;

    settings = {
      experimental-features = ["flakes" "nix-command" "pipe-operators"] |> lib.mkDefault;
      auto-optimise-store = true |> lib.mkDefault;

      flake-registry = "" |> lib.mkDefault;
    };
  };

  documentation.enable = false |> lib.mkDefault;

  nixpkgs.config.allowUnfree = true |> lib.mkDefault;

  environment = {
    variables = {
      NIXPKGS_ALLOW_UNFREE = 1 |> lib.mkDefault;
      NIXPKGS_ALLOW_INSECURE = 1 |> lib.mkDefault;
    };
  };

  system.stateVersion = host.stateVersion |> lib.mkForce;
}
