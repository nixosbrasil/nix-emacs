{pkgs, lib, config, ...}:
let
  inherit (lib) mkIf mkEnableOption optional;
  cfg = config.yasnippet;
in {
  options.yasnippet = {
    enable = mkEnableOption "yasnippet";
    global-mode.enable = mkEnableOption "yasnippet globally";
    official-snippets.enable = mkEnableOption "official snippet collection";
  };
  config = mkIf config.yasnippet.enable {
    plugins = with pkgs.emacsPackages; 
       optional cfg.enable yasnippet
    ++ optional cfg.official-snippets.enable yasnippet-snippets
    ;
    initEl.main = ''
      (require 'yasnippet)
    '';
    initEl.pos = mkIf config.yasnippet.global-mode.enable ''
      (yas-global-mode 1)
    '';
  };
}
