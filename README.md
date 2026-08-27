# eden-nix

[![NixOS unstable](https://img.shields.io/badge/NixOS-unstable-78C0E8?logo=nixos&logoColor=white)](https://nixos.org)
[![License: MPL-2.0](https://img.shields.io/badge/License-MPL--2.0-blue.svg)](./LICENSE)

Nix flake for the [Cemu](https://github.com/cemu-project/Cemu) Wii U emulator.

## Upstream

|             |                                                         |
| ----------- | ------------------------------------------------------- |
| **Project** | [cemu-project/Cemu](https://github.com/cemu-project/Cemu) |
| **License** | MPL-2.0                                       |

## What is this?

A Nix flake that provides a fully-functioning cached package of Cemu's latest git commit, made by overriding the nixpkgs `cemu` package.

## Installation

Add this flake input:

```nix
{
  inputs = {
    cemu-nix.url = "github:Nyramu/cemu-nix";
  };
}
```

Then install the package:

```nix
{ inputs, pkgs, ... }:
{
  environment.systemPackages = [
    inputs.cemu-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
```

### Cache

This flake sets `extra-substituters` and `extra-trusted-public-keys` via
`nixConfig`, but you can set the cache manually by adding the following in your
`configuration.nix`:

```nix
{
  nix.settings = rec {
    substituters = [ "https://cemu-nix.cachix.org" ];
    trusted-substituters = substituters;
  
    trusted-public-keys = [
      "cemu-nix.cachix.org-1:T/ZzErp7a/kDpY5U8FGtJPUcE9uGvJTCp2WrpidM2eE="
    ];
  };
}
```

## License

This packaging flake is [MPL-2.0](./LICENSE) licensed (matches
upstream). Upstream Cemu is
[MPL-2.0](https://github.com/cemu-project/Cemu/blob/main/LICENSE.txt).
