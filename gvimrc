if has("gui_running")
  " Nicer font
  set guifont=Ubuntu\ Mono\ for\ Powerline\ 12
  colorscheme Tomorrow
  " Airline (status line)
  let g:airline_theme='solarized'
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

