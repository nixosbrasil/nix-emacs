{pkgs, config, lib, ...}:
let
  inherit (lib) mkOption mkEnableOption mkIf types;
  cfg = config.evil;
in {
  options = {
    evil = {
      enable = mkEnableOption "evil-mode";
    };
  };
  config = mkIf cfg.enable {
    initSnippet = ''
      (require 'evil)
      (evil-mode 1)
    '';
    plugins = with pkgs.emacsPackages; [ evil ];
  };
}
