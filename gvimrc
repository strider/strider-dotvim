if has("gui_running")
  " Nicer font
  set guifont=Ubuntu\ Mono\ 09
  set bg=light
  colorscheme solarized
endif

" No icky toolbar, menu or scrollbars in the GUI
if has('gui')
  set guioptions+=a " Automatically make visual selection available in system clipboard
  set guioptions-=m
  set guioptions-=T
  set guioptions-=l
  set guioptions-=L
  set guioptions-=r
  set guioptions-=R
  set guioptions-=b
  set mousehide     " Hide the mouse while typing
end

