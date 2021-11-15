{pkgs, lib, config, ...}:
{
  config = {
    themes.available = { # define the default themes as no package required
      adwaita = [];
      deeper-blue = [];
      dichromacy = [];
      leuven = [];
      light-blue = [];
      manoj-dark = [];
      misterioso = [];
      tango-dark = [];
      tsdh-dark = [];
      tsdh-light = [];
      wheatgrass = [];
      whiteboard = [];
      wombat = [];
    };
  };
}
