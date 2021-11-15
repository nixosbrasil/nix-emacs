{pkgs, lib, config, ...}:
let
  inherit (lib) optional mkOption types;
  cfg = config.themes;
in {
  imports = [
    ./themes.nix
    ./loader.nix
  ];
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
}
