#!/usr/bin/env bash

DOT_DIR="$HOME/macos-dotfile"
CONF_DIR="$HOME/.config"
EXCLUDE_FILE="$DOT_DIR/RSYNC_EX_LIST"
SYMLINK_PATH="/usr/local/bin/mydotfiles"
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


update_fc() {
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
   
   if [ -f "$EXCLUDE_FILE" ]; then
   	rm $EXCLUDE_FILE
   fi
push_fc
}

push_fc() {
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
}

pull_fc (){
   cd "$DOT_DIR" || exit
   git pull
}

symlink_fc (){
   if [ -a "$SYMLINK_PATH" ]; then
	   echo "Warning: Symlink to $SYMLINK_PATH already exists"
   else 
	   sudo ln -s "$DOT_DIR/mydotfiles.sh" "$SYMLINK_PATH"
	   sudo chmod +x "$SYMLINK_PATH"
	   echo "Symlink to $SYMLINK_PATH created"
   fi
}

case "$1" in
	update)
		update_fc
		;;
	push)
		push_fc
		;;
	pull)
		pull_fc
		;;
	symlink)
		symlink_fc
		;;
	restore)
		restore_fc
		;;
        *)
		echo "Usage: $0 {update|restore|push|pull|symlink}"
		exit 1
		;;
esac
