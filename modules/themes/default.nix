{pkgs, lib, config, ...}:
let
  inherit (lib) optional mkOption types;
  cfg = config.themes;
in {
  imports = [
    ./themes.nix
    ./loader.nix
    ./base16.nix
  ];
  options = {
    themes = {
      available = mkOption {
        description = "Themes available to just select";
        default = {};
        type = types.attrsOf (types.submodule ({...}: {
          options = {
            packages = mkOption {
              description = "Extra packages required for the theme";
              default = [];
              type = types.listOf types.package;
            };
            supportsNoGui = mkOption {
              description = "Do the theme works on the CLI mode?";
              default = false;
              type = types.bool;
            };
          };
        }));
      };
      selected = mkOption {
        description = "Selected theme";
        default = null;
        type = types.nullOr types.str;
      };
    };
  };
}
