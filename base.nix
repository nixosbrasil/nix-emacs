{pkgs, lib, config, ...}:
let
  inherit (lib) mkOption types optional;
  inherit (builtins) toFile concatStringsSep attrValues;
in {
  options = {
    target = mkOption {
      type = types.attrsOf types.package;
      default = {};
      visible = false;
    };
    identifier = mkOption {
      type = types.str;
      description = "Unique identifier for the configuration";
      default = "default";
    };
    package = mkOption {
      type = types.package;
      description = "Emacs package used";
      default = pkgs.emacs;
    };
    plugins = mkOption {
      type = types.listOf types.package;
      description = "Emacs plugins";
      default = [];
    };
    extraFlags = mkOption {
      type = types.listOf types.str;
      description = "Extra flags to launch the entrypoint";
      default = [];
    };
    initEl = {
      pre = mkOption {
        type = types.lines;
        description = "init.el pre part for ordering";
        default = "";
      };
      main = mkOption {
        type = types.lines;
        description = "init.el pre part for ordering";
        default = "";
      };
      pos = mkOption {
        type = types.lines;
        description = "init.el pre part for ordering";
        default = "";
      };
    };
  };
  config = let
    initEl = toFile "init-${config.identifier}.el" (
      concatStringsSep "\n" (with config.initEl; [ pre main pos ])
    );
    overrided = config.package.pkgs.withPackages config.plugins;
    flags = config.extraFlags;
  in {
    target = {
      entrypoint = pkgs.stdenvNoCC.mkDerivation {
        inherit (overrided) meta;
        inherit (overrided.emacs) pname version;

        dontUnpack = true;

        nativeBuildInputs = with pkgs; [ makeWrapper ];
        installPhase = ''
          cp -r ${overrided} $out
          chmod +w $out/bin/emacs
          ls $out
          makeWrapper ${overrided}/bin/emacs $out/bin/emacs ${concatStringsSep " " (map (v: ''--add-flags "${v}"'') (flags ++ ["-l" initEl]))}
        '';
      };
      nixlessBundleZipped =
        pkgs.runCommandNoCC "nixless-emacs.zip" {} "cd ${config.target.nixlessBundle}; ${pkgs.zip}/bin/zip -r $out .";
      nixlessBundle = builtins.trace "DISCLAIMER: nixless emacs is a very experimental feature. Be careful!"
      pkgs.stdenvNoCC.mkDerivation {
        inherit (overrided.emacs) pname version;
        dontUnpack = true;
        dontFixup = true;
        nativeBuildInputs = with pkgs; [ makeWrapper ];

        installPhase = ''
          mkdir $out/modules -p
          thePath=`cat ${overrided}/bin/emacs | grep deps | head -n 1 | sed 's;^.*(\(.*\)).*$;\\1;'`
          cp -rvL $thePath/elpa $out/modules/elpa
          cp -L $thePath/subdirs.el $out/modules
          cp ${initEl} $out/init.el

          {
            echo '#!/usr/bin/env bash'
            echo 'export CONFPATH=`dirname "$(realpath "$0")"`'
            echo 'echo "confpath: $CONFPATH"'
            echo 'export EMACSLOADPATH=$CONFPATH/modules:$EMACSLOADPATH'
            echo 'exec "emacs" -l "$CONFPATH/init.el" "$@"'
          } > $out/nemacs

          chmod +x $out/nemacs

          {
            echo 'set "PATH=%PATH;C:\Program Files\Emacs\x86_64\bin"'
            echo 'set CONFPATH=%~dp0'
            echo 'set "EMACSLOADPATH=%CONFPATH%modules;"'
            echo 'start runemacs -l "%CONFPATH%init.el" %*'
          } > $out/nemacs.bat
        '';
      };
    };
  };
}
