{pkgs, config, lib, ...}:
let
  inherit (lib) mkIf;
in
{
  config = mkIf (config.org.enable && config.evil.enable && config.nogui) {
    initEl = {
      pre = ''
        ;; https://github.com/Somelauw/evil-org-mode#common-issues
        (setq evil-want-C-i-jump nil)
      '';
    };
  };
}
