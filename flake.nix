{
  description = "The base nix flake.";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };
  outputs = { nixpkgs, ... }@inputs: let
    systems = [ "x86_64-linux" "aarch64-linux" ];
    eachSystem = nixpkgs.lib.genAttrs systems;
    withPkgs = system: nixpkgs.legacyPackages.${system};
  in {
    devShells = eachSystem (system: let
      pkgs = withPkgs system;
      node = pkgs.nodejs_latest;
    in { 
      default = pkgs.mkShell {
        packages = with pkgs; with node.pkgs; [ prettier eslint just fzf ];
        nativeBuildInputs = with pkgs; [ node wrangler ];
      };
    });
  };
}
