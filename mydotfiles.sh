#!/bin/bash

DOT_DIR="$HOME//macos-dotfile"
CONF_DIR="$HOME/.config"

FILES=(
	"$HOME/.bashrc"
	"$HOME/.bash_profile"
)

DIR_CONF=(
	"$CONF_DIR"
	"$HOME/bin"
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

for dir in "${DIR_CONF[@]}"; do
	if [ -d "$dir" ]; then
		if [ -z "$(ls -A "$dir")"]; then
			echo "Skip: $dir is empty"
			continue
		fi
		cp -R "$dir" "$DOT_DIR"
		echo "Updated:" "$(tree $dir)"
	else
		echo "Warning: no file found in $dir"
	fi
done


if [[ -n $(git status -s) ]]; then
	echo "Changes detected. Push to Git"

	git add .
	git commit -m "Updated dotfiles: $(date + '%Y-%m-%d %H:%M:%S')"
	git push origin main

	echo "Pushed!"
else
	echo "Nothing changed."
fi

