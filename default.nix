let
  pkgs = import <nixpkgs> { };
  inherit (pkgs) lib;

  pyproject-nix = import
    (builtins.fetchTarball {
      url = "https://github.com/pyproject-nix/pyproject.nix/archive/d6c61dbe0be75e2f4cf0efcdc62428175be4cfb5.tar.gz";
      sha256 = "sha256-PUlomle4klGbnZr0wOn8z61Mbt7tXh6Yp3hZ9/CQkq0=";
    })
    {
      inherit lib;
    };

  uv2nix = import
    (builtins.fetchTarball {
      url = "https://github.com/pyproject-nix/uv2nix/archive/1610e554e579c3d47b47c8a32d47042116d0e153.tar.gz";
      sha256 = "sha256-qBbyM1Gnvs/ncbnWfbBboMyevelz+owIdSN5Sg89wzw=";
    })
    {
      inherit pyproject-nix lib;
    };

  pyproject-build-systems = import
    (builtins.fetchTarball {
      url = "https://github.com/pyproject-nix/build-system-pkgs/archive/042904167604c681a090c07eb6967b4dd4dae88c.tar.gz";
      sha256 = "sha256-4bocaOyLa3AfiS8KrWjZQYu+IAta05u3gYZzZ6zXbT0=";
    })
    {
      inherit pyproject-nix uv2nix lib;
    };

  pythonBase = pkgs.callPackage pyproject-nix.build.packages {
    python = pkgs.python3;
  };
  workspace = uv2nix.lib.workspace.loadWorkspace { workspaceRoot = ./.; };
  overlay = workspace.mkPyprojectOverlay {
    sourcePreference = "wheel";
  };
  pythonSet = pythonBase.overrideScope (
    lib.composeManyExtensions [
      pyproject-build-systems.default
      overlay
    ]
  );
in
pythonSet.mkVirtualEnv "application-env" workspace.deps.default
