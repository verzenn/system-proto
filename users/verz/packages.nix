{
  host,
  pkgs,
  inputs,
  ...
}: {
  home.packages = [
    inputs.zen.packages.${host.system}.default
    pkgs.xwayland-satellite
  ];
}
