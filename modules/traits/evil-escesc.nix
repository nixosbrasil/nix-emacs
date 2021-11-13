{pkgs, config, lib, ...}:
let
  inherit (lib) mkEnableOption mkIf;
in {
  options = {
    evil.escesc = mkEnableOption "Accept esc esc to go to normal mode quickly";
  };
  config = {
    initEl.pos = mkIf (config.evil.escesc && config.evil.enable) ''
    (define-key evil-insert-state-map (kbd "ESC <escape>") 'evil-normal-state)
    '';
  };
}
