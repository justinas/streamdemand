{ pkgs ? import <nixpkgs> { }
, poetry2nix ? pkgs.poetry2nix
}:
let poetryEnv = poetry2nix.mkPoetryEnv {
  projectDir = ./.;
  overrides = poetry2nix.overrides.withDefaults (self: super: {
    pytest = super.pytest.overridePythonAttrs (_: {
      doCheck = false; # unit tests take too long to execute
    });
  });
};
in poetryEnv.env
