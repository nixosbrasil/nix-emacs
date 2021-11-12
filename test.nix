{pkgs ? import <nixpkgs> {}}:
pkgs.callPackage ./default.nix {
  initSnippet = ''
    ;; Works
    (tool-bar-mode 0)
  '';
  nogui = true;
  evil.enable = true;
  language-support.nix.enable = true;
}
