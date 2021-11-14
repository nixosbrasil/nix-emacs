{pkgs, lib, config, ...}:
let
  inherit (lib) mkOption types mkEnableOption mkIf;
  cfg = config.language-support.markdown;
in {
  options = {
    language-support.markdown = {
      enable = mkEnableOption "markdown language support";
    };
  };
  config = mkIf cfg.enable {
    plugins = with pkgs.emacsPackages; [ markdown-mode ];
  };
}
