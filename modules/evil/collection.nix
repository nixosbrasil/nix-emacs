{pkgs, config, lib, ...}:
let
  inherit (lib) mkIf mkEnableOption;
in {
  options = {
    evil.collection = mkEnableOption "evil-collection";
  };
  config = mkIf (config.evil.enable && config.evil.collection) {
    plugins = with pkgs.emacsPackages; [ evil-collection ];
    initEl = {
      pre = ''
        (setq evil-want-integration t)
        (setq evil-want-keybinding nil)
      '';
      main = ''
        (require 'evil-collection nil t)
      '';
      pos = ''
        (evil-collection-init)
      '';
    };
  };
}
