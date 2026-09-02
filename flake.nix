{
  description = "Cemu (Wii U emulator) built from the latest git main";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    import-tree.url = "github:vic/import-tree";
  };

  outputs =
    { flake-parts, import-tree, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (import-tree ./modules);

  nixConfig = {
    extra-substituters = [ "https://cemu-nix.cachix.org" ];
    extra-trusted-public-keys = [
      "cemu-nix.cachix.org-1:T/ZzErp7a/kDpY5U8FGtJPUcE9uGvJTCp2WrpidM2eE="
    ];
  };
}
