#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

main() {
  # storing the refresh rate in the variable RATE, default is 5
  RATE=$(get_tmux_option "@dracula-refresh-rate" 5)
  mouse_mode_status=$(
    if tmux show-option -g mouse | grep -q "on"; then
      echo "#[fg=green]󰍽"
    else
      echo "#[fg=red]󰍾"
    fi
  )
  echo "$mouse_mode_status"
  sleep $RATE
}

# run main driver
main
