{config, lib, ...}:
let
  inherit (lib) mkOption types mkIf;
in
{
  options.workaround.evil-org-evil-redirect-digit-argument = mkOption {
    type = types.bool;
    description = "See https://github.com/Somelauw/evil-org-mode/issues/93#issuecomment-950306532";
    default = true;
  };
  config = mkIf (config.org.enable && config.evil.enable && config.workaround.evil-org-evil-redirect-digit-argument) {
    warnings = [
      "there is a bug on https://github.com/Somelauw/evil-org-mode and the fix should be available soon. See https://github.com/Somelauw/evil-org-mode/issues/93#issuecomment-950306532"
    ];
    initEl.pre = ''
      (fset 'evil-redirect-digit-argument 'ignore) ;; before evil-org loaded
    '';
  };
}
