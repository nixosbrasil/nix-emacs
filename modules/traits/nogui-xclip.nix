{config, pkgs, lib, ...}:
let
  inherit (lib) mkIf;
in
{
  config = mkIf config.nogui {
    plugins = with pkgs.emacsPackages; [ xclip ];
    initEl.pos = ''
      (xclip-mode 1)
    '';
  };
}
