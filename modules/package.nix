{ ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      source = builtins.fromJSON (builtins.readFile ../source.json);
      oldDeps = [
        pkgs.fmt_9
        pkgs.SDL2
        pkgs.wxwidgets_3_2
      ];
      newDeps = [
        pkgs.fmt_12
        pkgs.sdl3
        pkgs.wxwidgets_3_3
      ];
    in
    {
      packages.default = pkgs.cemu.overrideAttrs (old: {
        pname = "cemu";
        version = "git-${builtins.substring 0 7 source.rev}-0.0";
        src = pkgs.fetchFromGitHub {
          owner = "cemu-project";
          repo = "Cemu";
          rev = source.rev;
          hash = source.hash;
          fetchSubmodules = true;
        };

        patches = builtins.filter (
          p:
          !(pkgs.lib.hasSuffix "0002-cemu-imgui.patch" (toString p))
          && !(pkgs.lib.hasInfix "c1c2962b6633017cd956c6925288e2529c532ee4" (toString p))
        ) old.patches;

        postPatch = (old.postPatch or "") + ''
          sed -i '/io\.ImeWindowHandle = nullptr;/d' src/imgui/imgui_extension.cpp
        '';
        
        nativeBuildInputs = (pkgs.lib.subtractLists oldDeps old.nativeBuildInputs) ++ newDeps;
        buildInputs = (pkgs.lib.subtractLists oldDeps old.buildInputs) ++ newDeps;
      });
    };
}
