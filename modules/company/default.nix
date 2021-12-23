{pkgs, lib, config, ...}: 
let
  inherit (lib) mkIf mkEnableOption;
in {
  options = {
    company.enable = mkEnableOption "company";
  };
  config = mkIf config.company.enable {
    plugins = with pkgs.emacsPackages; [
      company
    ];
    initEl = {
      pos = ''
        (add-hook 'after-init-hook 'global-company-mode)
      '';
    };
  };
}
