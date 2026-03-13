
    set -l display_lines
    set -l commands

    set -l binds (hyprctl binds -j | jq -r '.[] |
      ( (.modmask as $m |
          (if ($m / 8  | floor) % 2 == 1 then "ALT+"   else "" end) +
          (if ($m / 64 | floor) % 2 == 1 then "SUPER+" else "" end) +
          (if ($m / 4  | floor) % 2 == 1 then "CTRL+"  else "" end) +
          (if ($m / 1  | floor) % 2 == 1 then "SHIFT+" else "" end)
        ) + .key
      ) + "\t" +
      (.dispatcher + " " + .arg) + "\t" +
      (if .dispatcher == "exec" then .arg
       else "hyprctl dispatch " + .dispatcher + " " + .arg
       end)')

    for line in $binds
      set -l parts (string split \t -- $line)
      set -a display_lines "$parts[1] → $parts[2]"
      set -a commands $parts[3]
    end

    set -l selection (printf '%s\n' $display_lines \
      | wofi --dmenu --prompt "keybinds" --width "80%")

    test -z "$selection" && return

    set -l idx (printf '%s\n' $display_lines | grep -nF "$selection" | head -1 | cut -d: -f1)
    test -z "$idx" && return

    eval $commands[$idx]
