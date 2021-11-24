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
