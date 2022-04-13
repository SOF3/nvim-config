#!/usr/bin/env bash

set -x

HOST=$1

if [[ -z $COPY ]]; then
	if [[ $OS == Windows_NT ]]; then
		COPY="cat > /dev/clipboard"
	elif command -v pbcopy >/dev/null; then
		COPY="pbcopy"
	elif command -v xclip >/dev/null; then
		COPY="xclip"
	else
		echo "Cannot detect clipboard manager, specify with COPY=\"command that sends stdin to clipboard\""
	fi
fi

mtime=$(ssh $HOST -T stat /tmp/vim-yank -c %Y)

while true; do
	new_mtime=$(ssh $HOST -T stat /tmp/vim-yank -c %Y || echo SSH_ERROR)
	if [[ $mtime -ne $new_mtime ]] && [[ $new_mtime != SSH_ERROR ]]; then
		mtime=$new_mtime
		scp $HOST:/tmp/vim-yank /tmp/vim-yank
		$COPY < /tmp/vim-yank
	fi
done
