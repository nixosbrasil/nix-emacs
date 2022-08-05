{config, pkgs, lib, ...}:
let
  inherit (lib) mkIf optional;
  cfg = config.themes;
in mkIf (cfg.selected != null) (
  let
    selected = cfg.available."${cfg.selected}";
  in {
    warnings = optional (!selected.supportsNoGui && config.nogui) "the selected theme does not support GUIless mode";
    plugins = selected.packages;
    initEl.pos = ''
      (load-theme '${cfg.selected})
    '';
})
