{pkgs, lib, config, ...}:
let
  inherit (lib) mkOption types mkEnableOption mkIf;
  cfg = config.language-support.nix;
in {
  options = {
    language-support.nix = {
      enable = mkEnableOption "nix language-support";
    };
  };
  config = mkIf cfg.enable {
    plugins = with pkgs.emacsPackages; [ nix-mode ];
    initEl = {
      main = ''
        (require 'nix-mode)
      '';
      pos = ''
        (add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode))
      '';
    };
  };
}
