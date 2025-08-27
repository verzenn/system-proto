{
  username,
  host,
  lib,
  ...
}: {
  imports = [./${username}];

  home = {
    username = username |> lib.mkDefault;
    homeDirectory = "/home/${username}" |> lib.mkDefault;
  };

  nixpkgs.config.allowUnfree = true |> lib.mkDefault;

  systemd.user.startServices = "sd-switch" |> lib.mkDefault;

  home.stateVersion = host.stateVersion |> lib.mkForce;
}
