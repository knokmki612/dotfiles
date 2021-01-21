#!/bin/sh

NVIM_DIR="${HOME}/.config/nvim"
VIM_DIR="${HOME}/.vim"
VIM_CONFIG="${VIM_DIR}/vimrc"

mkdir -p "${NVIM_DIR}" "${NVIM_DIR}/colors"

[ -f "${VIM_CONFIG}" ] && {
  ln -s "$VIM_CONFIG" "${NVIM_DIR}/init.vim"
}

colorscheme=$(
  find "${VIM_DIR}" -type f -name "hybrid.vim" |
  grep -v ".cache"                             |
  head -n 1
)

[ -n "${colorscheme}" ] && {
  ln -s "$colorscheme" "${NVIM_DIR}/colors/$(basename ${colorscheme})"
}
