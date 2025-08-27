{
  host,
  inputs,
  ...
}: {
  home.packages = [
    inputs.flow.packages.${host.system}.default
  ];
}
