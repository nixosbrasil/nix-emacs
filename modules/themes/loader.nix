{config, lib, ...}:
let
  inherit (lib) mkIf;
  cfg = config.themes;
in mkIf (cfg.selected != null) {
  plugins = cfg.available."${cfg.selected}";
  initEl.pos = ''
    (load-theme '${cfg.selected})
  '';
}
