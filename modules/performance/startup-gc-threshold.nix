{config, lib, ...}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options = {
    performance.startup.increase-gc-threshold-on-init = mkEnableOption "increase GC threshold to avoid GCs on initialization";
  };
  config = mkIf config.performance.startup.increase-gc-threshold-on-init {
    initEl.pre = ''
      (let
        (
          ;; Temporarily increase the GC threshold to avoid GCs on initialization
          (gc-cons-threshold most-positive-fixnum)
          ;; Avoid analyzing files when loading remote files
          (file-name-handler-alist nil))
    '';
    initEl.pos = ''
      )
    '';
  };
}
