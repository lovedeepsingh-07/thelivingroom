{
  description = "thelivingroom";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/3146c6aa9995e7351a398e17470e15305e6e18ff";
    gitignore = {
      url = "github:hercules-ci/gitignore.nix/cb5e3fdca1de58ccbc3ef53de65bd372b48f567c";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils/11707dc2f618dd54ca8739b309ec4fc024de578b";
  };
  outputs = {...} @ inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [];
          config = {
            allowUnfree = true;
          };
        };
      in {
        devShells = import ./.nix/shell.nix {
          inherit pkgs;
        };
        packages.default = pkgs.callPackage ./.nix/package.nix {
		  src = ./.;
          gitignore = inputs.gitignore;
		  yarn_berry = pkgs.yarn-berry_4;
        };
      }
    );
}
