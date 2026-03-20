#!/bin/bash

DOT_DIR="$HOME/macos-dotfile"
CONF_DIR="$HOME/.config"
EXCLUDE_FILE=$DOT_DIR/RSYNC_EX_LIST

FILES=(
	"$HOME/.bashrc"
	"$HOME/.bash_profile"
)

DIR_CONF=(
	"$CONF_DIR"
)

RSYNC_EX_LIST=(
        "newdir"
)

echo "Updating dotfiles.."

for file in "${FILES[@]}"; do
	if [ -f "$file" ]; then
		cp -R "$file" "$DOT_DIR"
		echo "Updated: $file"
	else
		echo "Warning: $file not found"
	fi
done

if [[ ${RSYNC_EX_LIST[@]} ]]; then
	for ex in "${RSYNC_EX_LIST[@]}"; do
		echo "$ex" >> $EXCLUDE_FILE 
	done
fi


for dir in "${DIR_CONF[@]}"; do
	if [ -d "$dir" ]; then
		if [ -z "$(ls -A "$dir")" ]; then
			echo "Skip: $dir is empty"
			continue
		fi
		rsync -a --progress --delete --exclude-from="$EXCLUDE_FILE" "$dir" "$DOT_DIR"
		echo "Updated: $dir"
	else
		echo "Warning: no file found in $dir"
	fi
done

if [ -f "$RSYNC_EX_LIST" ]; then
	rm $EXCLUDE_FILE
fi

cd "$DOT_DIR" || exit

if [[ -n $(git status -s) ]]; then
	echo "Changes detected. Push to Git"

	git add .
	git commit -m "Updated dotfiles: $(date '+%Y-%m-%d|%H:%M:%S')"
	git push origin main

	echo "Pushed!"
else
	echo "Nothing changed."
fi

