{pkgs, config, lib, ...}:
let
  inherit (lib) mkIf;
in
{
  config = mkIf (config.org.enable && config.evil.enable) {
    plugins = with pkgs.emacsPackages; [ evil-org ];
    initEl = {
      pre = ''
        (setq evil-org-key-theme '(textobjects navigation additional insert todo))
      '';
      main = ''
        (require 'evil-org)
      '';
      pos = ''
        (evil-org-set-key-theme)
        (add-hook 'org-mode-hook 'evil-org-mode)
      '';
    };
  };
}
