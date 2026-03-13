{ pkgs, ... }:
{
  home.packages = with pkgs; [
    font-awesome # icon font
    nerd-fonts.jetbrains-mono
    nautilus # file manager
    file-roller # archive manager
    eog # image viewer
    vlc
    mpv
    celluloid # modern video player
    grimblast # screenshot
    icon-library # browse icon themes
    swappy # screenshot annotator
    pwvucontrol # volume control
    nwg-look # inspect / tweak theme
    playerctl # media control
    brightnessctl
    networkmanagerapplet
    blueman
    wl-clipboard
    wl-clip-persist
    fd # fast find replacement
    diskus # check how big a dir is, very fast
    dust # show disk usage tree of a dir
    moreutils # ts to timestamp lines of output and other nice things
    jq # cli to parse and query json
    libnotify
  ];

  fonts.fontconfig.enable = true;
  services.cliphist.enable = true; # clipboard manager

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
  };

  wayland.windowManager.hyprland.settings =
    let
      app = "uwsm app --";
    in
    {
      general = {
        "col.active_border" = "rgba(89b4fa60)";
        "col.inactive_border" = "rgba(31324400)";
      };

      exec-once = [
        "${app} waybar"
        "${app} kitty"
        "${app} nm-applet --indicator"
        "${app} blueman-applet"
        "${app} wl-clip-persist --clipboard regular"
      ];

      misc.force_default_wallpaper = 2;

      "$mod" = "ALT";

      bind = [
        ", F1, exec, ${app} fish -c keybinds"

        "$mod, Return, exec, ${app} kitty"
        "$mod, D, exec, ${app} wofi --show drun"
        "$mod, Q, killactive"
        "$mod, F, fullscreen"
        "$mod SHIFT, F, togglefloating"

        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"

        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"

        "$mod      , V, exec, ${app} fish -c clipboard-history"
        "$mod      , Print, exec, ${app} sh -c 'grimblast save area   - | swappy -f -'" # select region
        "          , Print, exec, ${app} sh -c 'grimblast save screen - | swappy -f -'" # full screen
        "$mod SHIFT, Print, exec, ${app} sh -c 'grimblast save active - | swappy -f -'" # active window
        "$mod      , S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspacesilent, special:magic"
        "$mod,       Y, exec, ${app} sh -c 'wl-paste | xargs celluloid'"

        ", XF86AudioPlay, exec, ${app} playerctl play-pause"
        ", XF86AudioNext, exec, ${app} playerctl next"
        ", XF86AudioPrev, exec, ${app} playerctl previous"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bindel = [
        ", XF86AudioRaiseVolume, exec, ${app} wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, ${app} wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, ${app} wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86MonBrightnessUp, exec, ${app} brightnessctl set 5%+"
        ", XF86MonBrightnessDown, exec, ${app} brightnessctl set 5%-"
      ];

      decoration = {
        blur = {
          enabled = true;
          size = 8;
          passes = 2;
          vibrancy = 0.2;
        };
      };

      layerrule = [
        "blur on, match:namespace wofi"
        "ignore_alpha 0.0, match:namespace wofi"
        "blur on, match:namespace notifications"
        "ignore_alpha 0.0, match:namespace notifications"
        "blur on, match:namespace waybar"
        "ignore_alpha 0.0, match:namespace waybar"
      ];
    };

  programs.waybar = {
    enable = true;
    settings.mainBar = {
      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "clock" ];
      modules-right = [
        "tray"
        "cpu"
        "memory"
        "pulseaudio"
        "network"
        "battery"
        "custom/power"
      ];
      pulseaudio.format = "{icon} {volume}%";
      pulseaudio.format-icons.default = [
        ""
        ""
        "⏎"
      ];
      pulseaudio.on-click = "uwsm app -- pwvucontrol";
      network.format-wifi = " {signalStrength}%";
      network.format-ethernet = "󰈀 {ipaddr}";
      network.format-disconnected = "⏎";
      battery.format-icons = [
        ""
        ""
        ""
        ""
        ""
      ];
      clock.format = " {:%H:%M}";
      cpu.format = " {usage}%";
      memory.format = " {percentage}%";

      "custom/power" = {
        format = "⏻  ";
        on-click = ''
          choice=$(printf 'shutdown\nreboot\nlogout\nlock' | wofi --dmenu --prompt 'power')
          case $choice in
            shutdown) systemctl poweroff ;;
            reboot) systemctl reboot ;;
            logout) hyprctl dispatch exit ;;
            lock) uwsm app -- hyprlock ;;
          esac
        '';
        tooltip = false;
      };
    };
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
      }

      window#waybar {
        background: rgba(30, 30, 46, 0.65);
        color: #cdd6f4;
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
      }

      #workspaces button {
        color: #6c7086;
        padding: 0 8px;
      }

      #workspaces button.active {
        color: #cdd6f4;
      }

      #clock, #network, #battery, #tray, #pulseaudio, #cpu, #memory {
        color: #6c7086;
        padding: 0 12px;
      }

      #custom-lock, #custom-logout {
        color: #f38ba8;
        padding: 0 8px;
      }

      #tray image {
        opacity: 0.6;
      }
    '';
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };
    settings = {
      window_padding_width = 8;
      background_opacity = "0.65";

      foreground = "#CDD6F4";
      background = "#0E0E1E";
      cursor = "#F5E0DC";

      color0 = "#45475A";
      color1 = "#F38BA8";
      color2 = "#A6E3A1";
      color3 = "#F9E2AF";
      color4 = "#89B4FA";
      color5 = "#F5C2E7";
      color6 = "#94E2D5";
      color7 = "#BAC2DE";
      color8 = "#585B70";
      color9 = "#F38BA8";
      color10 = "#A6E3A1";
      color11 = "#F9E2AF";
      color12 = "#89B4FA";
      color13 = "#F5C2E7";
      color14 = "#94E2D5";
      color15 = "#A6ADC8";
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      background = {
        blur_passes = 3;
        blur_size = 8;
        noise = 0.02;
        brightness = 0.6;
      };

      input-field = {
        size = "300, 50";
        outline_thickness = 2;
        outer_color = "rgb(1e1e2e)";
        inner_color = "rgb(313244)";
        font_color = "rgb(cdd6f4)";
        placeholder_text = "password";
        check_color = "rgb(a6e3a1)";
        fail_color = "rgb(f38ba8)";
      };

      label = {
        text = "$TIME";
        font_size = 48;
        color = "rgb(cdd6f4)";
        position = "0, 200";
        halign = "center";
        valign = "center";
      };
    };
  };

  # cool shell prompt
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings =
      fromTOML (
        builtins.readFile (
          builtins.fetchurl {
            url = "https://raw.githubusercontent.com/vipau/veeship/2144df930c898d64dffc3b44fe1f5ddb1564af69/starship.toml";
            sha256 = "05dmarzwhbxwc07had7pnjbjm2c8xkiakfcmr0w20d0vpqx4jjv5";
          }
        )
      )
      // {
        palette = "catppuccin_mocha";

        fill = {
          symbol = "─";
          style = "fg:overlay0";
        };

        palettes.catppuccin_mocha = {
          rosewater = "#f5e0dc";
          flamingo = "#f2cdcd";
          pink = "#f5c2e7";
          mauve = "#cba6f7";
          red = "#f38ba8";
          maroon = "#eba0ac";
          peach = "#fab387";
          yellow = "#f9e2af";
          green = "#a6e3a1";
          teal = "#94e2d5";
          sky = "#89dceb";
          sapphire = "#74c7ec";
          blue = "#89b4fa";
          lavender = "#b4befe";
          text = "#cdd6f4";
          subtext1 = "#bac2de";
          subtext0 = "#a6adc8";
          overlay2 = "#9399b2";
          overlay1 = "#7f849c";
          overlay0 = "#6c7086";
          surface2 = "#585b70";
          surface1 = "#45475a";
          surface0 = "#313244";
          base = "#1e1e2e";
          mantle = "#181825";
          crust = "#11111b";
        };
      };
  };

  home.sessionVariables = {
    GTK_THEME = "Flat-Remix-GTK-Cyan-Darkest";
    MOZ_GTK_TITLEBAR_DECORATION = "client";
    TERMINAL = "kitty";
    VISUAL = "zed";
  };

  programs.firefox = {
    enable = true;
    profiles.default = {
      settings = {
        "ui.systemUsesDarkTheme" = 1;
        "browser.theme.content-theme" = 0;
        "browser.theme.toolbar-theme" = 0;
      };
    };
  };

  gtk = {
    enable = true;

    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Cyan-Darkest";
    };

    iconTheme = {
      package = pkgs.flat-remix-icon-theme;
      name = "Flat-Remix-Cyan-Dark";
    };

    font = {
      name = "Sans";
      size = 11;
    };
  };

  # the stock hyprland cursor is nicer
  #home.pointerCursor = {
  #  gtk.enable = true;
  #  package = pkgs.catppuccin-cursors.mochaDark;
  #  name = "catppuccin-mocha-dark-cursors";
  #  size = 32;
  #};

  # fancy neovim client
  programs.neovide = {
    enable = true;
    settings.font = {
      size = 12.0;
      normal = [ "JetBrainsMono Nerd Font" ];
    };
  };

  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      nixd
      nixfmt
    ];
    plugins = with pkgs.vimPlugins; [
      conform-nvim
      blink-cmp
    ];
    initLua = builtins.readFile ./vim/init.lua;
  };

  # fancy editor, more user friendly than vim
  programs.zed-editor = {
    enable = true;
    extensions = [
      "catppuccin"
      "nix"
    ];
    extraPackages = with pkgs; [
      nixd
      nixfmt
    ];
    userSettings = {
      theme = {
        mode = "dark";
        dark = "Catppuccin Mocha";
        light = "Catppuccin Latte";
      };
      ui_font_family = "JetBrainsMono Nerd Font";
      ui_font_size = 16;
      buffer_font_family = "JetBrainsMono Nerd Font";
      buffer_font_size = 14;
      vim_mode = false;
      cursor_blink = false;
      format_on_save = "on";
      autosave = "on_focus_change";
      terminal = {
        font_family = "JetBrainsMono Nerd Font";
        font_size = 14;
        opacity = 0.65;
        blinking = "off";
      };
      tab_size = 2;
      indent_guides.enabled = true;
      window_decorations = "client";
      lsp = {
        nixd = {
          binary.path = "nixd";
          settings = {
            nixpkgs.expr = "import (builtins.getFlake \".\").inputs.nixpkgs {}";
            formatting.command = [ "nixfmt" ];
          };
        };
      };
      languages.Nix = {
        language_servers = [
          "nixd"
          "!nil"
        ];
        formatter = {
          language_server.name = "nixd";
        };
        format_on_save = "on";
      };
    };
  };

  # notifications
  services.mako = {
    enable = true;
    settings = {
      background-color = "#0E0E1E80";
      text-color = "#CDD6F4FF";
      border-color = "#89B4FAFF";
      border-size = 2;
      border-radius = 8;
      padding = "12";
      width = 350;
      height = 200;
      margin = "12";
      font = "JetBrainsMono Nerd Font 11";
      layer = "overlay";

      "urgency=low" = {
        border-color = "#313244FF";
        text-color = "#6C7086FF";
        default-timeout = 4000;
      };

      "urgency=normal" = {
        default-timeout = 8000;
      };

      "urgency=high" = {
        border-color = "#F38BA8FF";
        text-color = "#F38BA8FF";
        default-timeout = 0;
      };
    };
  };

  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        type = "small";
      };
      modules = [
        "title"
        "os"
        "kernel"
        "packages"
        "shell"
        "nixstore"
        "colors"
      ];
    };
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      cat = "TERM=xterm-256color bat";
      grep = "rg";
      du = "dust";
      f = "xdg-open";
      e = "$EDITOR";
      l = "ls -latr";
      nq = "nix search nixpkgs";

      # TERM fixes not being able to type when searching with /
      man = "TERM=xterm-256color batman";
      less = "more"; # less is more haha get it
    };

    functions.ns = {
      description = "nix shell shorthand";
      body = builtins.readFile ./fish/functions/ns.fish;
    };

    functions.clipboard-history = {
      description = "nix shell shorthand";
      body = builtins.readFile ./fish/functions/clipboard-history.fish;
    };

    functions.keybinds = {
      description = "browse and run keybiunds";
      body = builtins.readFile ./fish/functions/keybinds.fish;
    };

    # remove this to get rid of the instructions when you open a shell
    interactiveShellInit = builtins.readFile ./fish/motd.fish;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = "org.gnome.Nautilus.desktop";
      "text/plain" = "zed.desktop";
      "text/html" = "firefox.desktop";
      "application/pdf" = "firefox.desktop";
      "image/png" = "org.gnome.eog.desktop";
      "image/jpeg" = "org.gnome.eog.desktop";
      "video/mp4" = "celluloid.desktop";
      "video/x-matroska" = "celluloid.desktop";
      "audio/mpeg" = "celluloid.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "application/octet-stream" = "zed.desktop";
    };
  };

  # auto lock/hibernate
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "hyprlock";
        before_sleep_cmd = "hyprlock";
      };
      listener = [
        {
          timeout = 300;
          on-timeout = "hyprlock";
        }
        #{ timeout = 600; on-timeout = "systemctl suspend"; }
      ];
    };
  };

  programs.yt-dlp = {
    enable = true;
    settings = {
      format = "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best";
      embed-thumbnail = true;
      embed-subs = true;
      sub-langs = "en.*";
      sponsorblock-mark = "sponsor,intro,outro,selfpromo";
    };
  };

  # automatically enter dev shells
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    silent = true;
    enableFishIntegration = true;
  };

  # fuzzy file finder
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    defaultCommand =
      let
        excluded = [
          ".git"
          ".nix-defexpr"
          ".direnv"
          "result*"
        ];
        excludeFlags = map (d: "--exclude ${d}") excluded;
      in
      "fd --type f --hidden --follow ${builtins.concatStringsSep " " excludeFlags}";
  };

  # shell tab completions/suggestions
  programs.carapace = {
    enable = true;
    enableFishIntegration = true;
  };

  # cat replacement
  programs.bat = {
    enable = true;
    config = {
      style = "plain"; # no filename header, no line numbers, no git diff
      theme = "catppuccin-mocha";
    };
    themes = {
      catppuccin-mocha = {
        src = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/catppuccin/bat/6810349b28055dce54076712fc05fc68da4b8ec0/themes/Catppuccin%20Mocha.tmTheme";
          sha256 = "sha256-OVVm8IzrMBuTa5HAd2kO+U9662UbEhVT8gHJnCvUqnc=";
        };
      };
    };
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batgrep
      batman
    ];
  };

  # minimal terminal based user friendly editor, good alternative to vi/vim
  programs.micro = {
    enable = true;
    settings = {
      colorscheme = "solarized";
      background = false;
    };
  };

  # grep replacement
  programs.ripgrep = {
    enable = true;
    arguments = [
      "--smart-case"
      "--hidden"
    ];
  };

  programs.wofi.enable = true;

  programs.wofi.settings = {
    insensitive = true;
    dynamic_lines = true;
    width = 600;
    location = "center";
    halign = "center";
    orientation = "vertical";
    prompt = "";
    hide_scroll = true;
  };

  programs.wofi.style = ''
    window {
      background-color: rgba(14, 14, 30, 0.85);
      border: 1px solid rgba(137, 180, 250, 0.3);
      border-radius: 12px;
      padding: 8px;
    }

    #input {
      background-color: rgba(49, 50, 68, 0.65);
      color: #cdd6f4;
      border: 1px solid rgba(137, 180, 250, 0.2);
      border-radius: 8px;
      padding: 10px 14px;
      margin: 4px;
      font-family: "JetBrainsMono Nerd Font";
      font-size: 14px;
    }

    #input:focus {
      border-color: rgba(137, 180, 250, 0.6);
      outline: none;
    }

    #outer-box {
      background-color: transparent;
    }

    #inner-box {
      background-color: transparent;
      margin-top: 4px;
    }

    #scroll {
      background-color: transparent;
    }

    #entry {
      padding: 8px 14px;
      border-radius: 6px;
      color: #6c7086;
      font-family: "JetBrainsMono Nerd Font";
      font-size: 13px;
    }

    #entry:selected {
      background-color: rgba(137, 180, 250, 0.15);
      color: #cdd6f4;
    }

    #text {
      color: inherit;
    }

    #img {
      margin-right: 8px;
    }
  '';
  # system monitor
  programs.bottom.enable = true;

  # the latest stable NixOS version you first installed Home Manager.
  # you can check here at the time of install: https://status.nixos.org/
  # do not change this afterwards
  home.stateVersion = "25.11";
}
