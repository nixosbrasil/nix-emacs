{pkgs, lib, config, ...}:
let
  inherit (lib) mkEnableOption mkIf;
in {
  options.org.roam = {
    enable = mkEnableOption "org-roam";
    ack-v2 = mkEnableOption "disable the annoying reminder about note migration from v1";
  };
  config = mkIf (config.org.enable && config.org.roam.enable) {
    plugins = with pkgs.emacsPackages; [
      org-roam
    ];
    initEl.pre = mkIf config.org.roam.ack-v2 ''
      (setq org-roam-v2-ack t)
    '';
    initEl.pos = ''
      (add-hook 'after-init-hook (lambda ()
          (define-key (current-global-map) (kbd "C-c n f") 'org-roam-node-find)
          (define-key (current-global-map) (kbd "C-c n r") 'org-roam-node-random)
          (define-key (org-mode-map) (kbd "C-c n i") 'org-roam-node-insert)
          (define-key (org-mode-map) (kbd "C-c n o") 'org-id-get-create)
          (define-key (org-mode-map) (kbd "C-c n t") 'org-roam-tag-add)
          (define-key (org-mode-map) (kbd "C-c n a") 'org-roam-alias-add)
          (define-key (org-mode-map) (kbd "C-c n l") 'org-roam-buffer-toggle)))

    '';
  };
}
