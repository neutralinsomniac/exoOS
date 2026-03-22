{
  description = "exoOS";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";

    lanzaboote.url = "github:nix-community/lanzaboote/v1.0.0";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    exocortex.url = "github:neutralinsomniac/exocortex";
    exocortex.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {
      nixosConfigurations =
        nixpkgs.lib.genAttrs
          [
            "micropc"
          ]
          (
            hostName:
            nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              specialArgs = { inherit inputs; };
              modules = [
                inputs.disko.nixosModules.disko
                { networking.hostName = hostName; }
                ./hw/${hostName}
                ./configuration.nix
                { system.configurationRevision = self.rev or "dirty"; }
              ];
            }
          );

      apps.x86_64-linux.update = {
        type = "app";
        program = "${
          pkgs.writeShellScriptBin "update" (
            builtins.readFile (
              pkgs.replaceVars ./.scripts/update.sh {
                bash = "${pkgs.bash}/bin/bash";
              }
            )
          )
        }/bin/update";
      };
    };
}
