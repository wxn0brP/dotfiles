#!/usr/bin/env zsh

DOTFILES="${DOTFILES:-$HOME/dotfiles}"
GLOB_DIR="$DOTFILES/glob"
LINK_DIR="$DOTFILES/glob-path"

if [[ ! -d "$GLOB_DIR" ]]; then
	echo "Error: $GLOB_DIR not found" >&2
	exit 1
fi

mkdir -p "$LINK_DIR"

find "$LINK_DIR" -maxdepth 1 -type l -delete 2>/dev/null

count=0
for f in "$GLOB_DIR"/*.ts; do
	[[ -f "$f" ]] || continue
	name="${f:t:r}"
	ln -sf "$f" "$LINK_DIR/$name"
	((count++))
done

echo "Linked $count bun scripts"
