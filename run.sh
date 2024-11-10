#!/usr/bin/bash
tmux new -s devicons -d
tmux send-keys -t devicons 'lpm run --ephemeral ./ devicons && tmux kill-session -t devicons' C-m
tmux attach -t devicons

