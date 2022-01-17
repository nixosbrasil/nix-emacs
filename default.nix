{ pkgs ? import <nixpkgs> {}
, modules ? []
, specialArgs ? {}
, ...
}@args:
let
  inherit (builtins) removeAttrs length trace head tail;
  inherit (pkgs) lib;
  inherit (lib) evalModules;
in
let
  traceWarnings = warnings: v:
    if length warnings == 0 
    then v
    else
      trace (head warnings) (traceWarnings (tail warnings) v)
    ;

  mainModule = removeAttrs args ["pkgs" "specialArgs"];
  input = evalModules {
    modules = [
      (args: mainModule)
      ./base.nix
      ./modules
      ./target.nix
    ];
    specialArgs = specialArgs // {
      inherit pkgs;
    };
  };
in traceWarnings input.config.warnings input.config.target.entrypoint // {
  inherit (input) config options;
  inherit input;
  inherit (input.config.target) entrypoint;
}
