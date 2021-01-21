#!/bin/sh

NVIM_DIR="${HOME}/.config/nvim"
VIM_DIR="${HOME}/.vim"

mkdir -p "${NVIM_DIR}" "${NVIM_DIR}/colors"

[ -f "${VIM_DIR}/vimrc" ] && {
  ln -sf "${VIM_DIR}/vimrc" "${NVIM_DIR}/init.vim"
}

[ -d "${VIM_DIR}/ftplugin" ] && {
  ln -sf "${VIM_DIR}/ftplugin" "${NVIM_DIR}/"
}

[ -d "${VIM_DIR}/ftdetect" ] && {
  ln -sf "${VIM_DIR}/ftdetect" "${NVIM_DIR}/"
}

colorscheme=$(
  find "${VIM_DIR}" -type f -name "hybrid.vim" |
  grep -v ".cache"                             |
  head -n 1
)

[ -n "${colorscheme}" ] && {
  ln -sf "$colorscheme" "${NVIM_DIR}/colors/$(basename ${colorscheme})"
}
