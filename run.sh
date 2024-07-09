#!/usr/bin/bash
tmux new -s devicons -d
tmux send-keys -t devicons 'lpm run --ephemeral ./ devicons' C-m
tmux attach -t devicons

