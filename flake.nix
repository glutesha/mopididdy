{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.flake-parts.flakeModules.easyOverlay ];
      systems = [ "x86_64-linux" "aarch64-linux" ];
      perSystem = ({ pkgs, ... }: {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            (pkgs.writeShellScriptBin "mopidy" ''
              exec python -c "from mopidy._app.cli import app; app.meta()" "$@"
            '')
            cairo
            gobject-introspection
            gst_all_1.gstreamer
            gst_all_1.gst-plugins-base
            gst_all_1.gst-plugins-good
            gst_all_1.gst-plugins-ugly
            (python313.withPackages (pypkgs: with pypkgs; [
              gst-python
              cyclopts
              httpx
              platformdirs
              pydantic
              pygobject3
              pykka
              rich
              tornado

              tox
              mkdocstrings-python
              zensical
              rumdl
              ruff

              dirty-equals
              polyfactory
              pytest
              pytest-cov
              pytest-httpx
              pytest-mock
              pytest-repeat
            ]))
          ];

          shellHook = ''
            export PYTHONPATH=$(pwd)/src
          '';
        };
      });
    };
}
