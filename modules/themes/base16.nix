{ lib, pkgs, config, ... }:
let
  inherit (lib) mkIf mkOption mkDefault types concatStringsSep listToAttrs attrNames;
  inherit (cfg.base16-pallete) base00 base01 base02 base03 base04 base05 base06 base07 base08 base09 base0A base0B base0C base0D base0E base0F;
  inherit (pkgs) writeText;
  cfg = config.themes;
  color-keys = [
    "base00"
    "base01"
    "base02"
    "base03"
    "base04"
    "base05"
    "base06"
    "base07"
    "base08"
    "base09"
    "base0A"
    "base0B"
    "base0C"
    "base0D"
    "base0E"
    "base0F"
  ];
in {
  options = {
    themes.base16-pallete = let # stolen from https://github.com/Misterio77/nix-colors/blob/main/module/colorscheme.nix
      mkColorOption = name: {
        inherit name;
        value = mkOption {
          type = types.strMatching "[a-fA-F0-9]{6}";
          description = "${name} color.";
        };
      };
    in mkOption {
      description = "Base16 pallette to be applied instead of a theme";
      default = null;
      type = types.nullOr (types.submodule {
        options = (listToAttrs (map mkColorOption color-keys));
      });
    };
  };
  config = mkIf (cfg.base16-pallete != null) (let
      elFile = writeText "base16-nix-theme.nix" ''
        ;; base16-nix-theme.el -- A base16 colorscheme

        ;;; Commentary:
        ;; Base16: (https://github.com/base16-project/base16)

        ;;; Authors:
        ;; Scheme: {{scheme-author}}
        ;; Template: Kaleb Elwert <belak@coded.io>

        ;;; Code:
        (require 'base16-theme)

        (defvar base16-nix-theme-colors
        '(${concatStringsSep " " (map (name: '':${name} "#${cfg.base16-pallete.${name}}"'') color-keys)})
        "All colors for the nix-emacs generated base16 theme are defined here.")

        ;; Define the theme
        (deftheme base16-nix)

        ;; Add all the faces to the theme
        (base16-theme-define 'base16-nix base16-nix-theme-colors)

        ;; Mark the theme as provided
        (provide-theme 'base16-nix)
        (provide 'base16-nix-theme)
        ;;; base16-nix-theme.el ends here
      '';

    base16-plugin = pkgs.stdenv.mkDerivation {
      pname = "base16-nix";
      version = "1";
      src = elFile;
      dontUnpack = true;

      installPhase = ''
          install -d $out/share/emacs/site-lisp
          install $src $out/share/emacs/site-lisp/base16-nix-theme.el
      '';
      };
  in {
    themes.selected = mkDefault "base16-nix";
    initEl.pre = ''
      (add-to-list 'custom-theme-load-path "${base16-plugin}/share/emacs/site-lisp")
    '';
    themes.available.base16-nix.packages = with pkgs.emacsPackages; [
      base16-theme
      base16-plugin
    ];
  });
}
