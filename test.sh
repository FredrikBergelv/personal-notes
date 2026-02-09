#!/bin/bash

# Fixed destination folder
DEST="$HOME/Desktop/personal-notes"

# Ensure destination exists
mkdir -p "$DEST"

echo "Current directory:"
pwd
echo

# List files only
echo "Available files:"
select FILE in *; do
    if [[ -f "$FILE" ]]; then
        SOURCE="$(pwd)/$FILE"
        break
    else
        echo "Please select a valid file."
    fi
done

echo
echo "  Selected file:"
echo "  $SOURCE"
echo "  Destination:"
echo "  $DEST"
echo

# -------- COPY ONCE IMMEDIATELY --------
cp -u "$SOURCE" "$DEST"

cd "$DEST"     #chnage working directory o DEST and push with git
# Automatically add all files
FILES_TO_PUSH="."
# Add all files to Git
git add $FILES_TO_PUSH
git commit -m "This push was done via a bash script"
git push
cd "$SOURCE"

echo "Initial copy and push done at $(date)"
echo

echo "Watching for changes (Ctrl+C to stop)..."
echo

# -------- WATCH FOR FUTURE CHANGES --------
while true; do
    inotifywait -e close_write,moved_to,create "$SOURCE" >/dev/null 2>&1
    cp -u "$SOURCE" "$DEST"
    cd "$DEST"     #chnage working directory o DEST and push with git
    FILES_TO_PUSH="."
    git add $FILES_TO_PUSH
    git commit -m "This push was done via a bash script"
    git push
    cd "$SOURCE"
    echo "Updated copy and pushed at $(date)"
done

hej

