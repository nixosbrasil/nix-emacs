{pkgs, lib, config, ...}:
let
  inherit (builtins) toFile concatStringsSep attrValues;
in {
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
          echo $thePath
          cp -rvL $thePath/elpa $out/modules/elpa
                    # cat $thePath/subdirs.el | sed 's/ \r/g'
          # cp -L $thePath/subdirs.el $out/modules
          {
            echo "(setq load-path (let ((dir (file-name-as-directory (concat (file-name-as-directory (getenv \"CONFPATH\")) \"modules\")))) (delete-dups (append "
            cat $thePath/subdirs.el | sed 's/ /\n/g' | tr "\"'()" ' '  | grep site-lisp | sed 's/ //g' | sed "s;$thePath;;g" | sed 's;^/;;g' | while read -r line; do
              echo "(list (concat dir \"$line\"))"
            done
            echo "load-path))))"
            echo "(require 'json)"
            echo "(message (json-encode load-path))"
            echo
            echo
            cat ${initEl}
          } > $out/init.el

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
