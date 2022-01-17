{pkgs, lib, config, ...}:
let
  inherit (lib) mkOption types optional;
in {
  options = {
    target = mkOption {
      type = types.attrsOf types.package;
      default = {};
      visible = false;
    };
    identifier = mkOption {
      type = types.str;
      description = "Unique identifier for the configuration";
      default = "default";
    };
    package = mkOption {
      type = types.package;
      description = "Emacs package used";
      default = pkgs.emacs;
    };
    plugins = mkOption {
      type = types.listOf types.package;
      description = "Emacs plugins";
      default = [];
    };
    extraFlags = mkOption {
      type = types.listOf types.str;
      description = "Extra flags to launch the entrypoint";
      default = [];
    };
    initEl = {
      pre = mkOption {
        type = types.lines;
        description = "init.el pre part for ordering";
        default = "";
      };
      main = mkOption {
        type = types.lines;
        description = "init.el pre part for ordering";
        default = "";
      };
      pos = mkOption {
        type = types.lines;
        description = "init.el pre part for ordering";
        default = "";
      };
    };
  };
}
