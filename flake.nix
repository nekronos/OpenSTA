{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        opensta = pkgs.stdenv.mkDerivation {
          name = "OpenSTA";
          pname = "sta";
          src = ./.;
          nativeBuildInputs = with pkgs; [
            clang
            cmake
            gcc
            tcl
            swig
            bison
            flex
            cudd
            eigen
            tclreadline
            zlib
          ];

          buildPhase = "make -j $NIX_BUILD_CORES";
          installPhase = ''
            mkdir -p $out/bin
            cp -r ../app/* $out/bin
          '';
        };

      in
      rec {
        packages.default = opensta;
        defaultApp = flake-utils.lib.mkApp {
          drv = packages.default;
        };
      }
    );
}
