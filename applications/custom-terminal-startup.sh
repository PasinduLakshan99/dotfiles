#!/bin/bash

current_dir="$1"
# If tmux session exists
if tmux ls &>/dev/null; then
  # Get the first session name
  session_name=$(tmux list-sessions -F "#{session_name}" | head -n 1)

  # Check if there is already a window with the exact current directory path
  existing_window_index=""
  while IFS= read -r line; do
    win_idx=$(echo "$line" | cut -d " " -f1)
    win_path=$(echo "$line" | cut -d " " -f2-)
    if [ "$win_path" = "$current_dir" ]; then
      existing_window_index="$win_idx"
      break
    fi
  done < <(tmux list-windows -t "$session_name" -F "#{window_index} #{pane_current_path}")

  if [ -n "$existing_window_index" ]; then
    # If a window exists with this exact directory, focus it
    tmux select-window -t "$session_name:$existing_window_index"
    tmux attach-session -t "$session_name:$existing_window_index"
  else
    # Store current list of windows before creating new one
    before_windows=$(tmux list-windows -t "$session_name" -F "#{window_index}")

    # Create a new window in the background
    tmux new-window -d -c "$current_dir"

    # Store new list of windows
    after_windows=$(tmux list-windows -t "$session_name" -F "#{window_index}")

    # Find the new window index (the one that appears in after but not before)
    new_window_index=$(comm -13 <(echo "$before_windows" | sort) <(echo "$after_windows" | sort) | head -n 1)

    # Now attach to the session with the specific window selected
    tmux attach-session -t "$session_name:$new_window_index"
  fi
else
  # Start new tmux session in that directory
  tmux new -c "$current_dir"
fi
