{pkgs, lib, config, ...}:
let
  inherit (lib) mkOption types mkEnableOption mkIf;
  cfg = config.language-support.golang;
in {
  options = {
    language-support.golang = {
      enable = mkEnableOption "golang language support";
    };
  };
  config = mkIf cfg.enable {
    plugins = with pkgs.emacsPackages; [ go-mode ];
  };
}
