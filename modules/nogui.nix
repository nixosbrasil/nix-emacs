{pkgs, config, lib, ...}:
let
  inherit (lib) mkOption types mkIf;
in {
  options = {
    nogui = mkOption {
      type = types.bool;
      default = false;
      description = "Open Emacs in a terminal instead of in a GUI";
    };
  };
  config = mkIf config.nogui {
    extraFlags = [ "-nw" ];
  };
}
