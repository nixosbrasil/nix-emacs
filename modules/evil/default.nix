{pkgs, config, lib, ...}:
let
  inherit (lib) mkOption mkEnableOption mkIf types;
  cfg = config.evil;
in {
  imports = [
    ./collection.nix
  ];
  options = {
    evil = {
      enable = mkEnableOption "evil-mode";
    };
  };
  config = mkIf cfg.enable {
    initEl = {
      main = ''
        (require 'evil)
      '';
      pos = ''
        (evil-mode 1)
      '';
    };
    plugins = with pkgs.emacsPackages; [ evil ];
  };
}
