{ pkgs ? import <nixpkgs> { } }:
let
  poetry2nix = pkgs.callPackage (import ./poetry2nix.nix) { };
  poetryEnv = poetry2nix.mkPoetryEnv {
    projectDir = ./.;
    overrides = poetry2nix.overrides.withDefaults (self: super: {
      pytest = super.pytest.overridePythonAttrs (_: {
        doCheck = false; # unit tests take too long to execute
      });
      streamlink = super.streamlink.overrideAttrs (old: {
        buildInputs = old.buildInputs ++ [ super.setuptools ];
      });
    });
  };
in
poetryEnv.env
