{pkgs, config, lib, ...}:
let
  inherit (lib) mkIf;
in
{
  config = mkIf (config.org.enable && config.evil.enable) {
    plugins = with pkgs.emacsPackages; [ evil-org ];
    initEl = {
      pre = ''
        (require 'evil-org)
      '';
      main = ''
        (add-hook 'org-mode-hook 'evil-org-mode)
      '';
      pos = ''
        (evil-org-set-key-theme '(navigation insert textobjects additional calendar)) ;; HELPME: is this really essential?
      '';
    };
  };
}
