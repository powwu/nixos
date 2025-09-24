{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.file = {
    ".config/hypr/hyprlock.conf".text = ''
# sample hyprlock.conf
# for more configuration options, refer https://wiki.hyprland.org/Hypr-Ecosystem/hyprlock
#
# rendered text in all widgets supports pango markup (e.g. <b> or <i> tags)
# ref. https://wiki.hyprland.org/Hypr-Ecosystem/hyprlock/#general-remarks
#
# shortcuts to clear password buffer: ESC, Ctrl+U, Ctrl+Backspace
#
# you can get started by copying this config to ~/.config/hypr/hyprlock.conf
#

$font = Monospace

general {
    hide_cursor = false
}

# uncomment to enable fingerprint authentication
auth {
    fingerprint {
        enabled = true
        # ready_message = Scan fingerprint...
        # present_message = Scanning...
        retry_delay = 250 # in milliseconds
    }
}

animations {
    enabled = true
    bezier = linear, 1, 1, 0, 0
    animation = fadeIn, 1, 5, linear
    animation = fadeOut, 1, 5, linear
    animation = inputFieldDots, 1, 2, linear
}

background {
    monitor =
    path = screenshot
    blur_passes = 3
}

input-field {
    monitor =
    size = 0%, 0%
    outline_thickness = 3
    inner_color = rgba(0, 0, 0, 0.0) # no fill

    outer_color = rgba(FFFFFF00)
    check_color = rgba(FFFFFF00)
    fail_color = rgba(ff6633ee)

    font_color = rgb(255, 255, 255)
    fade_on_empty = false
    rounding = 15

    font_family = $font
    placeholder_text = Input password...
    fail_text = $PAMFAIL

    # uncomment to use a letter instead of a dot to indicate the typed password
    dots_text_format =
    # dots_size = 0.4
    dots_spacing = 0.3

    # uncomment to use an input indicator that does not show the password length (similar to swaylock's input indicator)
    hide_input = true

    position = 0, -20
    halign = center
    valign = center
}
        '';
  };
}
