{config, lib, pkgs, ...}:
let
  inherit (lib) optional;
in
{
  config = {
    warnings = []
      ++ optional (config.evil.enable && config.language-support.markdown.enable) "markdown language support is enabled and evil mode is enabled too but evil-markdown is not defined, the evil part of markdown-mode will be disabled";
  };
}
