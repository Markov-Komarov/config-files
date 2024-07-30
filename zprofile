# Executes commands at login pre-zshrc.
#Terminal

export TERMINAL=st

# Editors

if [[ -z "$EDITOR" ]]; then
  export EDITOR='helix'
fi
if [[ -z "$VISUAL" ]]; then
  export VISUAL='nvim'
fi
if [[ -z "$PAGER" ]]; then
  export PAGER='bat'
fi

# Language

if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi

# Paths

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# Set the list of directories that cd searches.
# cdpath=(
#   $cdpath
# )

# Set the list of directories that Zsh searches for programs.
path=(
  $HOME/{,s}bin(N)
  /usr/local/{,s}bin(N)
  $HOME/.local/bin(N)
  $HOME/.cargo/bin/(N)
  $path
)

# Try to startx after user login on tty1
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec startx
fi
