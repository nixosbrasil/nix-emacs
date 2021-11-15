{pkgs, lib, config, ...}:
# TODO: some of these themes actually works in CLI mode
{
  config = {
    themes.available = { # define the default themes as no package required
      adwaita.packages = [];
      deeper-blue.packages = [];
      dichromacy.packages = [];
      leuven.packages = [];
      light-blue.packages = [];
      manoj-dark.packages = [];
      misterioso.packages = [];
      tango-dark.packages = [];
      tsdh-dark.packages = [];
      tsdh-light.packages = [];
      wheatgrass.packages = [];
      whiteboard.packages = [];
      wombat.packages = [];
    };
  };
}
