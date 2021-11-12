{pkgs, lib, config, ...}:
let
  inherit (lib) mkOption types optional;
  inherit (builtins) toFile concatStringsSep;
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
    initSnippet = mkOption {
      type = types.lines;
      description = "init.el content";
      default = "";
    };
  };
  config = let
    initEl = toFile "init-${config.identifier}.el" config.initSnippet;
    overrided = config.package.pkgs.withPackages config.plugins;
    flags = config.extraFlags
      ++ ["-l" initEl]
    ;
  in {
    target = {
      entrypoint = pkgs.stdenv.mkDerivation {
        inherit (overrided) meta;
        inherit (overrided.emacs) pname version;

        dontUnpack = true;

        nativeBuildInputs = with pkgs; [ makeWrapper ];
        installPhase = ''
          cp -r ${overrided} $out
          chmod +w $out/bin/emacs
          ls $out
          makeWrapper ${overrided}/bin/emacs $out/bin/emacs ${concatStringsSep " " (map (v: ''--add-flags "${v}"'') flags)}
        '';
      };
    };
  };
}
