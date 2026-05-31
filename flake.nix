{
  inputs = {
    deploy = {
      url = "github:dwayne/deploy";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils, deploy }:
    flake-utils.lib.eachDefaultSystem(system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          name = "elmwithdwayne.dev";

          packages = [
            deploy.packages.${system}.deploy
            pkgs.nodejs-slim_24
            pkgs.pnpm
          ];

          shellHook = ''
            export PROJECT_ROOT="$PWD"
            export PS1="($name)\n$PS1"
            export PATH="$PROJECT_ROOT/node_modules/.bin:$PATH"

            if [ ! -d "$PROJECT_ROOT/node_modules" ]; then
              pnpm install --silent
            fi

            deploy-prod () {
              #
              # N.B. You MUST build the website before attempting to deploy.
              #
              deploy "$@" "$PROJECT_ROOT/dist" release/prod
            }

            clean () {
              rm -rf "$PROJECT_ROOT/"{.astro,dist,node_modules}
            }
            alias c='clean'

            alias d='pnpm dev'
            alias b='pnpm build'
            alias p='pnpm preview'
          '';
        };
      }
    );
}
