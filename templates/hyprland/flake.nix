{
  description = "tiling desktop with frosted catpuccino aesthetics";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nut.url = "github:Francesco149/nut";
    nut.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self, nut, ... }@inputs:
    nut.lib.mf {
      inherit self inputs;
      dir = ./.;
      hosts.nixos = [ ];
      hmModules.headpats = [ ];

      modules = [
        # fix issues when running as a guest with virtio acceleration.
        # leave it commented out unless you are using a virtio gpu
        #./modules/virtio-tweaks.nix
      ];

    };
}
