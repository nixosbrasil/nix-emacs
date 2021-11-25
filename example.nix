# Config example used to demo if it works and as a baseline for users to experiment
# Use `nix-build example.nix` and open emacs via ./result/bin/emacs
# This file returns a function that returns a derivation so import/callPackage and nix-env should work as well

{pkgs ? import <nixpkgs> {}}:
pkgs.callPackage ./default.nix {
  initEl = {
    pos = ''
      ;; Works
      (tool-bar-mode 0)
    '';
  };
  nogui = true;
  evil = {
    enable = true;
    escesc = true;
    collection = true;
  };
  language-support = {
    nix.enable = true;
    markdown.enable = true;
  };
  performance.startup.increase-gc-threshold-on-init = true;
  themes.selected = "manoj-dark";
  org.enable = true;
}
