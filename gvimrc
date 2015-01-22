if has("gui_running")
  " Nicer font
  set guifont=Terminus\ for\ Powerline\ 08
  set bg=dark
  colorscheme Tomorrow-Night-Bright
  " Airline (status line)
  let g:airline_theme='tomorrow'
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

