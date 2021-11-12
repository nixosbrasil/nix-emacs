{pkgs ? import <nixpkgs> {}}:
pkgs.callPackage ./default.nix {
  initSnippet = ''
    ;; Works
    (tool-bar-mode 0)

    (require 'evil)
    (evil-mode 1)
  '';
  nogui = true;
  plugins = with pkgs.emacsPackages; [ evil ];
}
