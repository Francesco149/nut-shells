# machine-specific config goes here
{ pkgs, ... }:
{
  # NOTE: remember to add at least one ssh key if you need ssh access
  nut.ssh.authorizedKeys = [
    "ssh-ed25519 ... user@machine"
  ];

  hardware.graphics.enable = true;

  programs.fish.enable = true; # shell
  users.defaultUserShell = pkgs.fish;

  # for pipewire
  security.rtkit.enable = true;

  # audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.blueman.enable = true;

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  environment.variables = {
    SUDO_EDITOR = "micro";
    EDITOR = "micro";
  };

  environment.systemPackages = with pkgs; [
    git
    nixfmt
    vim
    micro # user friendly terminal-based text editor
  ];

  environment.etc."xdg/micro/settings.json".text = builtins.toJSON {
    colorscheme = "terminal";
    background = false;
  };

  # login manager
  programs.regreet = {
    enable = true;
    theme = {
      name = "Flat-Remix-GTK-Cyan-Darkest";
      package = pkgs.flat-remix-gtk;
    };
    font = {
      name = "Roboto";
      package = pkgs.roboto;
    };
    settings = {
      GTK.application_prefer_dark_theme = true;
      default_session = {
        command = "${pkgs.uwsm}/bin/uwsm start -- hyprland-uwsm.desktop";
        name = "Hyprland (UWSM)";
      };
    };
  };
}
