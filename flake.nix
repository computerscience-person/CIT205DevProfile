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
        packages = with pkgs; with node.pkgs; [ prettier eslint just fzf graphicsmagick ];
        nativeBuildInputs = with pkgs; [ node static-web-server ];
      };
    });
    packages = eachSystem (system: let
      pkgs = withPkgs system;
      sws = pkgs.static-web-server;
      siteContent = pkgs.runCommand "site-content" {} ''
        mkdir -p $out
        cp -r ${./site}/* $out/
      '';
    in {
      default = pkgs.writeShellScriptBin "serve-site" ''
          exec ${sws}/bin/static-web-server -p 8080 -d ${siteContent}
        '';
    });
  };
}
