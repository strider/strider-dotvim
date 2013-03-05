" Vim colorscheme
" Name:         lofic 
" Maintainer:   Louis Coilliot 'lofic' [louis.coilliot at gmail dot com]
" Last Change:  2012-11-06

hi clear
set background=light
if exists("syntax_on")
  syntax reset
  endif
  let g:colors_name = "lofic"

" gvim custom colors
"hi Statement gui=NONE        guifg=gold3          guibg=NONE
hi Statement gui=NONE        guifg=DarkGoldenRod          guibg=NONE
hi Type gui=NONE guifg=chartreuse4
hi Comment       guifg=DodgerBlue4
hi Include       guifg=pink4
hi String        guifg=firebrick4

hi rubyBoolean   guifg=red3
hi rubyBlockParameter guifg=black
hi rubyClass     guifg=HotPink4
hi rubyDefine    guifg=HotPink4
hi rubyFloat     guifg=firebrick1
hi rubyInteger   guifg=firebrick1
hi rubyInclude   guifg=Pink4
hi rubyModule    guifg=HotPink4
hi rubyPseudoVariable guifg=red3
hi rubySharpBang guifg=DodgerBlue3
hi rubySymbol    guifg=firebrick4

hi vimHiAttrib   guifg=pink4
hi vimOption     guifg=pink4
hi vimHiGuiRgb   guifg=firebrick2
hi vimNumber     guifg=firebrick1

hi shDerefSimple guifg=SlateBlue
hi shNumber      guifg=firebrick1

hi pythonNumber  guifg=firebrick1
hi pythonPreCondit  guifg=SlateBlue

hi octopressLiquidBlock gui=NONE guifg=DeepSkyBlue4
hi octopressLiquidBlockDelimiter gui=NONE guifg=SeaGreen4

hi markdownHeadingDelimiter guifg=DodgerBlue4
hi markdownH1 gui=bold guifg=DodgerBlue4
hi markdownH2 gui=bold guifg=DodgerBlue4
hi markdownH3 gui=bold guifg=DodgerBlue4
hi markdownH4 gui=bold guifg=DodgerBlue4
hi markdownLinkText guifg=MidnightBlue
hi markdownUrl guifg=DimGray
hi markdownOrderedListMarker guifg=red4
hi markdownListMarker guifg=red4

hi yamlInteger guifg=firebrick1

hi htmlH1 guifg=SlateBlue 

hi asciidocTwoLineTitle gui=bold guifg=DodgerBlue4

hi VertSplit gui=NONE guibg=White guifg=Grey90
hi StatusLine    gui=NONE guibg=Grey90 guifg=Black
hi StatusLineNC  gui=NONE guibg=LightGrey guifg=Black
hi NonText guifg=Grey95
hi LineNr gui=none guifg=Grey60

hi NERDTreeExecFile guifg=chartreuse4
hi NERDTreeDir guifg=SteelBlue3
hi NERDTreeUp  guifg=SteelBlue3

hi cssColor guifg=firebrick4
hi cssValueLength guifg=firebrick1
