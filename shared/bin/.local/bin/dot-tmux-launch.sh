#!/bin/bash

# Nombre de la sesión de tmux
SESSION_NAME="mi_sesion"

# Inicia una nueva sesión de tmux
tmux new-session -d -s $SESSION_NAME

# Crea una nueva ventana en la sesión
tmux new-window -t $SESSION_NAME:1 -n "mi_ventana"

# Divide la ventana en dos paneles: uno horizontal
tmux split-window -h #-t $SESSION_NAME:1.0

# Divide el panel izquierdo en dos paneles: uno vertical
tmux split-window -v #-t $SESSION_NAME:1.0

# Adjunta la sesión para que puedas interactuar con ella
tmux attach-session -t $SESSION_NAME
