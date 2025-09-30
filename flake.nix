{ inputs = {
    swww = {
      url = "github:lgfae/swww";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    discord = {
      url = "github:kaylorben/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spotify = {
      url = "github:gerg-l/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen = {
      url = "github:0xc000022070/zen-browser-flake/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kanata = {
      url = "github:jtroo/kanata";
      flake = false;
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      #inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    parts.url = "github:hercules-ci/flake-parts";
  };

  description = ''''; # TODO

  outputs = inputs:
    import ./parts {
      hosts = ./hosts;
      users = ./users;

      modules = {
        system = ./modules/system;
        home = ./modules/home;
      };

      meta = import ./meta.nix;
      inherit inputs;

      inherit (inputs.nixpkgs) lib;
    };
}
