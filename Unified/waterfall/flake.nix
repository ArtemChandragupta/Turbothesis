{
  description = "haskell devShell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        haskellPackages = pkgs.haskellPackages;
      in
      with pkgs; {
        devShells.default = mkShell rec {
          buildInputs = [
            (haskellPackages.ghcWithPackages (ps: with ps; [
              waterfall-cad
              waterfall-cad-svg
              lens
              linear
            ]))
            haskellPackages.cabal-install
            haskellPackages.haskell-language-server
          ];

          LD_LIBRARY_PATH = "${lib.makeLibraryPath buildInputs}";
        };
      });
}
