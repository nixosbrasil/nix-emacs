{pkgs, config, lib, ...}:
let
  inherit (lib) mkOption mkEnableOption;
in {
  imports = [
    ./org-roam.nix
  ];
  options = {
    org = {
      enable = mkEnableOption "org-mode";
    };
  };
  config = {
    plugins = with pkgs.emacsPackages; [ org ];
  };
}
