{pkgs, lib, config, ...}:
let
  inherit (lib) optional mkOption types;
  cfg = config.themes;
in {
  options = {
    themes = {
      available = mkOption {
        description = "Themes available to just select";
        default = {};
        type = types.attrsOf (types.listOf types.package);
      };
      selected = mkOption {
        description = "Selected theme";
        default = null;
        type = types.str;
      };
    };
  };
  config = {
    themes.available = { # define the default themes as no package required
      adwaita = [];
      deeper-blue = [];
      dichromacy = [];
      leuven = [];
      light-blue = [];
      manoj-dark = [];
      misterioso = [];
      tango-dark = [];
      tsdh-dark = [];
      tsdh-light = [];
      wheatgrass = [];
      whiteboard = [];
      wombat = [];
    };
    plugins = if cfg.selected == null then [] else cfg.available."${cfg.selected}";
    initSnippet = if (cfg.selected == null) then "" else ''
      (load-theme '${cfg.selected})
    '';
  };
}
