#!/bin/bash
set -e

user="screenshot"
hostname="gunnar"
location="/srv/http/screenshots"
webadress="http://i.rxn.be"

# Make a random file
file="$(mktemp XXXX.png)"
# Save the server adress to the clipboard
echo "$webadress/$file" | xclip -sel clip
# Take a screenshot with the user's arguments
escrotum $* "$file" > /dev/null 2>&1
# Make the file secure
chmod 644 $file
# Push the screenshot to the server
if scp -p $file $user@$hostname:$location/$file
then
    # Notify the user
    notify-send "Screenshot taken: $webadress/$file"
else
    notify-send -u critical "Failed to send screenshot to server."
fi
# Remove the temporary file
rm -f $file
