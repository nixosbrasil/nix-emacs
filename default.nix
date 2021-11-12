{ pkgs ? import <nixpkgs> {}
, modules ? []
, specialArgs ? {}
, ...
}@args:
let
  inherit (builtins) removeAttrs;
  inherit (pkgs) lib;
  inherit (lib) evalModules;
in
let 
  mainModule = removeAttrs args ["pkgs" "specialArgs"];
  input = evalModules {
    modules = [
      (args: mainModule)
      ./base.nix
      ./modules
    ];
    specialArgs = specialArgs // {
      inherit pkgs;
    };
  };
in input.config.target.entrypoint // {
  inherit (input) config options;
  inherit input;
  inherit (input.config.target) entrypoint;
}
