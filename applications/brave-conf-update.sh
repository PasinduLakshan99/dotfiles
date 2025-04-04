#!/bin/bash

# Path to the Brave browser .desktop file
FILE_PATH="/usr/share/applications/brave-browser.desktop"

# Function to display error messages and exit
error_exit() {
  echo "ERROR: $1" >&2
  exit 1
}

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
  error_exit "This script requires root privileges. Please run with sudo."
fi

# Check if the file exists
if [ ! -f "$FILE_PATH" ]; then
  error_exit "File not found: $FILE_PATH"
fi

# Check if the file is writable
if [ ! -w "$FILE_PATH" ]; then
  error_exit "File is not writable: $FILE_PATH"
fi

# The pattern to search for
SEARCH_PATTERN="Exec=/usr/bin/brave-browser-stable %U"
# The replacement text
REPLACEMENT="Exec=/usr/bin/brave-browser-stable --enable-features=TouchpadOverscrollHistoryNavigation --disable-experiments"

# Check if the file already contains the target configuration
if grep -q "$REPLACEMENT" "$FILE_PATH"; then
  echo "File is already up to date. No changes needed."
  exit 0
fi

# Check if the pattern exists in the file
if ! grep -q "$SEARCH_PATTERN" "$FILE_PATH"; then
  error_exit "Pattern not found in file. No changes made."
fi

# Perform the replacement
if sed -i "s|$SEARCH_PATTERN|$REPLACEMENT|" "$FILE_PATH"; then
  echo "Successfully updated Brave browser launch configuration."
  echo "Original pattern: $SEARCH_PATTERN"
  echo "New pattern: $REPLACEMENT"
else
  error_exit "Failed to update file."
fi

echo "Changes applied successfully."
