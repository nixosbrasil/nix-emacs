{pkgs, lib, config, ...}:
let
  inherit (lib) mkOption types;
in {
  options = {
    warnings = mkOption {
      description = "Evaluation warnings";
      default = [];
      type = types.listOf types.str;
    };
  };
}
