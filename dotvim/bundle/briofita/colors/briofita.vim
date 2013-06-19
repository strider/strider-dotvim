" =============================================================================
" Name:        Briofita
" Scriptname:  briofita.vim
" Author:      Sergio Nobre <sergio.o.nobre@gmail.com>
" Last Change: May 14th, 2013
" =============================================================================        {{{1
let this_color = "briofita"
if (!has('gui_running')) || (!v:version >= 703)
    echoerr "Colorscheme ".this_color." was designed only for Vim versions >= 7.3.0 in GUI mode."
    finish
endif
let g:briofitaversion = "2.0.2"
set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = this_color
let save_cpo = &cpo
set cpo&vim

" Local Variables: internal state control            {{{1
" Cursorline Cursorcolumn Dictionary: s:dict_hi_cul: selectable highlights  {{{2
if !exists("s:dict_hi_cul")
        let s:dict_hi_cul={
            \   0        : "#333399",
            \   1        : "#3A5022",
            \   2        : "#880c0e",
            \   3        : "Navy",
            \   4        : "DarkMagenta",
            \   5        : "SaddleBrown",
            \   6        : "#333399",
            \   7        : "#3A5022",
            \   8        : "Black",
            \   9        : ""
            \ }
endif
let s:hi_cul_maxx = len(s:dict_hi_cul)-1 " maximun key for cursorline highlights dict

" Configuration Dictionary:  s:dict_conf_options: core options configuration  {{{2
let s:dict_conf_options = {
    \ "uniformity":         [ 0,  1],
    \ "nodistractionmode":  [ 0,  1],
    \ "statusline":         [ 0,  1],
    \ "localcursorline":    [ 0,  1],
    \ "cursorline":         [ 3, -1],
    \ "colorcolumn":        [ 0,  3],
    \ "search":             [ 0,  5],
    \ "normal":             [ 0,  4],
    \ "cursorlinenr":       [ 0,  3],
    \ "foldcolumn":         [ 0,  4],
    \ "folded":             [ 0,  4],
    \ "conceal":            [ 0,  2],
    \ "special":            [ 0,  3],
    \ "vimgroup":           [ 0,  5],
    \ }
"
let g:briofita_allowed_parms = [ "uniformity",   "nodistractionmode", "statusline", "localcursorline",
                      \   "cursorline",   "colorcolumn",       "search",     "normal",
                      \   "cursorlinenr", "foldcolumn",         "folded",    "conceal",
                      \   "special",      "vimgroup" ]

let s:userchoicesList  = []

let s:lst_hi_conceal = [
        \     [ "LightGrey",  "#1E4959" ],
        \     [ "AquaMarine", "#880C0E" ],
        \     [ "#CCFFCC",    "#1E4959" ],
        \ ]

let s:dict_conf_options.conceal[1] = len(s:lst_hi_conceal)

let s:lst_hi_specialopt = [
   \  [ "#88CB35",    "NONE",   ],
   \  [ "#78B37A",    "NONE",   ],
   \  [ "#8B8B8B",    "NONE",   ],
   \  [ "AquaMarine", "#880C0E" ],
   \ ]

let s:dict_conf_options.special[1] = len(s:lst_hi_specialopt)

let s:dict_conf_options.cursorline[1] = (s:hi_cul_maxx - 1)

" Global Variables: external parameters that the user may set or change            {{{1
if exists("g:briofita_parms")
	"try
		if !empty(g:briofita_parms)
			for kp in keys(g:briofita_parms)
                " TODO check if the below tolower is really necessary
                let kl = tolower(kp)
                if kl=="cursorline"
                    if    (g:briofita_parms.cursorline >= s:hi_cul_maxx) ||
                     \    (g:briofita_parms.cursorline <  0)
                            " correct
                            let g:briofita_parms.cursorline = 0
                    endif
                endif
                if has_key(s:dict_conf_options, kl)
                    execute 'let tmpvalue  = g:briofita_parms.'      . kl
                    execute 'let s:limit = s:dict_conf_options.' . kl . '[1]'
                    if (s:limit >= 0)
                        if (tmpvalue > s:limit) || (tmpvalue < 0)
                            " correct
                            let tmpvalue = 0
                            execute 'let g:briofita_parms.' . kl . ' = ' .
                                      \     "[" . tmpvalue . ',' . s:limit . ']'
                        endif
                    endif
                    execute 'let s:dict_conf_options.' . kl . ' = ' .
                              \     "[" . tmpvalue . ',' . s:limit . ']'
                    call add(s:userchoicesList, kl)
                endif
			endfor
		endif
endif

" Check No Distraction Mode Internal State:  {{{1
if s:dict_conf_options.nodistractionmode[0]
    if exists("t:briofita_nodistractionmode")
        if t:briofita_nodistractionmode < 0
            let t:briofita_nodistractionmode = 0
        elseif t:briofita_nodistractionmode > 1
            let t:briofita_nodistractionmode = 0
        endif
        if !s:dict_conf_options.nodistractionmode[0]
            let s:dict_conf_options.nodistractionmode[0]=[1, s:dict_conf_options.nodistractionmode[1]]
        endif
    endif
endif

" Check Dict Conf Options Internal State:     {{{1
if exists    ("s:dict_conf_options")
    if has_key(s:dict_conf_options,"cursorline")
        if    (s:dict_conf_options.cursorline[0] >  s:dict_conf_options.cursorline[1]) ||
         \    (s:dict_conf_options.cursorline[0] >= s:hi_cul_maxx) ||
         \    (s:dict_conf_options.cursorline[0] <  0)
                " correct
                let s:dict_conf_options.cursorline[0] = 0
        endif
    endif
endif

" Check Tab Page Local Cursor Line Variable:      {{{1
if exists("t:briofita_choice_for_cursorline")
    if    (t:briofita_choice_for_cursorline >  s:dict_conf_options.cursorline[1]) ||
     \    (t:briofita_choice_for_cursorline >= s:hi_cul_maxx) ||
     \    (t:briofita_choice_for_cursorline <  0)
            " correct
            let t:briofita_choice_for_cursorline = 0
    endif
endif

" BriofitaNoDistraction Function: a distractionless editing mode         {{{1
if !exists ("*s:BriofitaNoDistraction")
    function! s:BriofitaNoDistraction(style)
        if a:style == 0
            let nodstBG1 = "#062926"
            let nodstFG1 = "#062926"
            let normFG   = "#C6B6FE"
        else
            let nodstBG1 = "Black"
            let nodstFG1 = "Black"
            let normFG   = "#49bef3"
        endif
        execute "highlight NonText     gui=NONE guifg=".nodstFG1." guibg=".nodstBG1
        execute "highlight VertSplit   gui=NONE guifg=".nodstFG1." guibg=".nodstBG1
        execute "highlight FoldColumn                              guibg=".nodstBG1
        execute "highlight signColumn                              guibg=".nodstBG1
        execute "highlight ColorColumn gui=NONE guifg=NONE guibg=NONE"
        execute 'let usrFG = "#401340"'
        execute 'let usrBG = "#401340"'
        execute "highlight User1   gui=NONE   guifg=".usrFG." guibg=".usrBG
        execute "highlight User2   gui=NONE   guifg=".usrFG." guibg=".usrBG
        execute "highlight User3   gui=NONE   guifg=".usrFG." guibg=".usrBG
        execute "highlight User4   gui=NONE   guifg=".usrFG." guibg=".usrBG
        execute "highlight User5   gui=NONE   guifg=".usrFG." guibg=".usrBG
        execute "highlight User6   gui=NONE   guifg=".usrFG." guibg=".usrBG
        execute "highlight User7   gui=NONE   guifg=".usrFG." guibg=".usrBG
        execute "highlight User8   gui=NONE   guifg=".usrFG." guibg=".usrBG
        execute "highlight User9   gui=NONE   guifg=".usrFG." guibg=".usrBG
        execute 'let statFG = "#401340"'
        execute 'let statBG = "#401340"'
        execute "highlight StatusLine   gui=NONE   guifg=".statFG." guibg=".statBG
        execute "highlight StatusLineNC gui=NONE   guifg=".statFG." guibg=".statBG
        execute "highlight Normal gui=NONE   guifg=".normFG." guibg=".nodstBG1
        execute 'let culBG = "'.s:dict_hi_cul[2].'"'
        execute "highlight CursorLine   gui=bold guifg=NONE guibg=".culBG
        execute "highlight CursorColumn gui=NONE guifg=NONE guibg=".culBG
        let s:dict_conf_options.colorcolumn[0]=[3, s:dict_conf_options.colorcolumn[1]]
        unlet normFG culBG statFG statBG usrFG usrBG nodstBG1 nodstFG1
        return
    endfunction
endif

" ColorDictParser Function: sets all color highlights specified in a dictionary {{{1
if !exists ("*s:ColorDictParser")
	function! s:ColorDictParser(color_dict) " Color dictionary parser
		for [group, group_colors] in items(a:color_dict)
				exec 'highlight ' . group
					\ . ( ! empty(group_colors[0])? ' guifg=' . group_colors[0]: '')
					\ . ( ! empty(group_colors[1])? ' guibg=' . group_colors[1]: '')
					\ . (   empty(group_colors[2])? ' gui=NONE' : ' gui=' . group_colors[2])
				   "\ . ( ! empty(group_colors[2]) ? ' gui='   . group_colors[2]: '')
		endfor
	endfunction
endif
"
" ParseAllSyntaxes Function: sets the highlights for all syntaxes used      {{{1
if !exists ("*s:ParseAllSyntaxes")
	function! s:ParseAllSyntaxes(listOfDicts)
		for langdict in a:listOfDicts
				call s:ColorDictParser(langdict)
		endfor
	endfunction
endif
"
" Color Dictionaries Initialization: define most of the highlights used in the colorscheme  {{{1
" NOTE: Design criteria:
" NOTE:     1. Use as few highlight links as possible.
" NOTE:     2. Harmony of highlights within a syntax prevails over inter-syntax uniformity.
"       |-------------------|-----------|-------------|-----------------|
"       | Highlight group   |Foreground |Background   |   Attributes    |
"       |-------------------|-----------|-------------|-----------------|
" Asciidoc                                          {{{2
let s:dict_hi_asciidoc = {
	\   "asciidocAdmonitionNote"	            : [ "#85B2FE",    "#1C4F4F", ""],
	\   "asciidocAdmonitionWarn"	            : [ "Wheat2", "#345FA8",  ""],
	\   "asciidocBiblio"	                    : [ "#2DB3A0", "", "bold,italic"],
	\   "asciidocFootnote"	                    : [ "CornflowerBlue", "Gray26",  "italic"],
	\   "asciidocGlossary"	                    : [ "#00B780", "",  "underline"],
	\   "asciidocInclude"	                    : [ "#A191F5", "",  ""],
	\   "asciidocLink"	                        : [ "#8870FF", "",  "bold,underline"],
	\   "asciidocQuestion"	                    : [ "#00B780", "",  "underline"],
	\   "asciidocReference"	                    : [ "#A191F5", "",  ""],
	\   "asciidocReplacements"	                : [ "DeepSkyBlue2", "",  ""],
	\   "asciidocRevisionInfo"	                : [ "DodgerBlue2", "",  ""],
	\   "asciidocSect1Old"	                    : [ "#9B91F6", "",  "bold"],
	\   "asciidocSect2"	                        : [ "#5FD75F", "#1C4F4F",  "underline"],
	\   "asciidocSect2Old"	                    : [ "#5FD75F", "#1C4F4F",  ""],
	\   "asciidocSect3"	                        : [ "DarkSeaGreen3", "Gray26",  "underline"],
	\   "asciidocSect3Old"	                    : [ "DarkSeaGreen3", "Gray26",  ""],
	\   "asciidocSect4Old"	                    : [ "#5FD75F", "#003366",  ""],
	\   "asciidocSource"	                    : [ "#c59f6f", "",  ""],
	\   "asciidocTripplePlusPassthrough"	    : [ "#A191F5", "",  ""],
 	\   "asciidocSect4"	                        : [ "#5FD75F", "#003366",  ""],
    \   "asciidocAdmonition"                    : [ "PowderBlue", "#007880",  ""],
    \   "asciidocAnchorMacro"                   : [ "SlateGray3", "",  ""],
    \   "asciidocAttributeEntry"                : [ "DarkSeaGreen3", "#1C3644", ""],
    \   "asciidocAttributeList"                 : [ "#CC4455", "",  ""],
    \   "asciidocAttributeMacro"                : [ "DodgerBlue2", "",  "italic"],
    \   "asciidocAttributeRef"                  : [ "#9A85FF", "#1C3644", "italic"],
    \   "asciidocBackslash"                     : [ "Aquamarine2", "",  ""],
    \   "asciidocBlockTitle"                    : [ "#CC4455", "",  ""],
    \   "asciidocCallout"                       : [ "SeaGreen2", "",  ""],
    \   "asciidocCommentBlock"                  : [ "#8B7F4C", "",  "italic"],
    \   "asciidocCommentLine"                   : [ "#5D8B9C", "",  ""],
    \   "asciidocDoubleDollarPassthrough"       : [ "DodgerBlue2", "",  ""],
    \   "asciidocEmail"                         : [ "SkyBlue2", "",  "underline"],
    \   "asciidocEntityRef"                     : [ "#8fbfdc", "",  ""],
    \   "asciidocExampleBlockDelimiter"         : [ "SlateGray4", "", "bold"],
    \   "asciidocFilterBlock"                   : [ "DeepSkyBlue2", "",  ""],
    \   "asciidocHLabel"                        : [ "SeaGreen2", "",  ""],
    \   "asciidocHyphenInterpolation"           : [ "#9FE846", "#573D8C", ""],
    \   "asciidocIdMarker"                      : [ "SpringGreen2", "",  ""],
    \   "asciidocIndexTerm"                     : [ "#7FA2E6", "",  ""],
    \   "asciidocLineBreak"                     : [ "Red", "",  ""],
    \   "asciidocList"                          : [ "#00B780", "",  ""],
    \   "asciidocListBlockDelimiter"            : [ "#779DB2", "",  ""],
    \   "asciidocListBullet"                    : [ "SpringGreen2", "",  ""],
    \   "asciidocListContinuation"              : [ "#8B8B8B", "",  "italic"],
    \   "asciidocListingBlock"                  : [ "DeepSkyBlue2", "",  ""],
    \   "asciidocListLabel"                     : [ "#00B780", "", "bold"],
    \   "asciidocListNumber"                    : [ "SpringGreen2", "",  ""],
    \   "asciidocLiteralBlock"                  : [ "#2FBBA6", "",  "italic"],
    \   "asciidocLiteralParagraph"              : [ "#00B780", "",  "italic"],
    \   "asciidocMacro"                         : [ "#7FAAF2", "#1C3644", "italic"],
    \   "asciidocMacroAttributes"               : [ "BurlyWood2","Gray30","italic"],
    \   "asciidocNonAsciidocBar"                : [ "Maroon", "",  "bold"],
    \   "asciidocOddnumberedTableCol"           : [ "#9FE846", "#573D8C", ""],
    \   "asciidocOneLineTitle"                  : [ "FireBrick1", "#112A33", "bold,underline"],
    \   "asciidocPagebreak"                     : [ "CadetBlue2", "",  ""],
    \   "asciidocPassthroughBlock"              : [ "#009F6F", "",  "italic"],
    \   "asciidocQuoteBlockDelimiter"           : [ "DeepSkyBlue2", "",  ""],
    \   "asciidocQuotedAttributeList"           : [ "#9A85FF", "",  "italic"],
    \   "asciidocQuotedBold"                    : [ "Green2","#1E4959", "italic"],
    \   "asciidocQuotedboldAttributeList"       : [ "#8B8B8B", "",  "italic"],
    \   "asciidocQuotedDoubleQuoted"            : [ "SeaGreen3", "#1E4959",  "italic"],
    \   "asciidocQuotedEmphasized"              : [ "DarkSeaGreen2","#1E4959", "italic"],
    \   "asciidocQuotedEmphasized2"             : [ "#C19EFF", "#1E4959",  "italic"],
    \   "asciidocQuotedMonospaced"              : [ "Khaki3", "#1E4959",  "italic"],
    \   "asciidocQuotedMonospaced2"             : [ "#A08FF5", "",  "italic"],
    \   "asciidocQuotedSingleQuoted"            : [ "Green3", "#1E4959",  "italic"],
    \   "asciidocQuotedSubscript"               : [ "SlateGray3", "", "italic"],
    \   "asciidocQuotedSuperscript"             : [ "DarkSeaGreen3", "", "italic"],
    \   "asciidocQuotedUnconstrainedBold"       : [ "DarkSeaGreen1","#990024", "italic"],
    \   "asciidocQuotedUnconstrainedEmphasized" : [ "DeepSkyBlue2", "",  ""],
    \   "asciidocQuotedUnconstrainedMonospaced" : [ "#00B780", "",  "italic"],
    \   "asciidocRefMacro"                      : [ "#7FA2E6", "",  "italic"],
    \   "asciidocRuler"                         : [ "DeepSkyBlue2", "",  ""],
    \   "asciidocSect0"                         : [ "FireBrick1", "#112A33", "bold,italic,underline"],
    \   "asciidocSect0Old"                      : [ "#9B91F6", "",  "bold,italic"],
    \   "asciidocSect1"                         : [ "FireBrick1", "#112A33", "bold,underline"],
    \   "asciidocSidebarDelimiter"              : [ "#009F6F", "MidnightBlue",  "italic,underline"],
    \   "asciidocTableBlock"                    : [ "#FF88AA", "#573D8C", ""],
    \   "asciidocTableDelimiter"                : [ "Maroon", "",  "bold"],
    \   "asciidocTableDelimiter2"               : [ "#779DB2", "",  ""],
    \   "asciidocTablePrefix"                   : [ "Maroon", "",  "bold"],
    \   "asciidocTablePrefix2"                  : [ "SeaGreen2", "",  ""],
    \   "asciidocToDo"                          : [ "Wheat2", "#345FA8",  ""],
    \   "asciidocTriplePlusPassthrough"         : [ "#88CB35", "",  ""],
    \   "asciidocTwoLineTitle"                  : [ "Green2", "#3A5022",  ""],
    \   "asciidocURL"                           : [ "Turquoise", "", "italic"],
            \ }

" Awk                                               {{{2
let s:dict_hi_awk = {
    \   "awkArrayElement"                       : [ "AquaMarine3", "", ""],
    \   "awkComma"                              : [ "#009F6F","",""],
    \   "awkFieldVars"                          : [ "#009F6F","",""],
    \   "awkFunction"                           : [ "#2FBBA6", "", ""],
    \   "awkParen"                              : [ "Red", "",  ""],
    \   "awkPatterns"                           : [ "PaleGreen2", "", ""],
    \   "awkRegExp"                             : [ "#009F6F","",""],
    \   "awkSearch"                             : [ "#009F6F","",""],
    \   "awkSpecialCharacter"                   : [ "Red", "", ""],
    \   "awkSpecialPrintf"                      : [ "#9FCBD0", "DarkSlateGrey", ""],
    \   "awkStatement"                          : [ "PowderBlue", "#1C3644", ""],
    \   "awkString"								: [ "#9A85FF", "",  ""],
    \   "awkVariables"                          : [ "#8870FF","",""],
            \ }

" Buffergator, Buffersaurus, ls/DirList (Vim plugin)        {{{2
let s:dict_hi_plugin_bufX = {
    \   "bufferGatorModifiedFileName"           : [ "PaleGreen2", "DarkSlateGray",  "bold,italic"],
    \   "bufferGatorTabpageLine"                : [ "#009F6F", "", "bold"],
    \   "bufferGatorUnmodifiedFileName"         : [ "#99ad6a", "",  ""],
    \   "BufferSaurusCurrentEntry"              : [ "", "", "reverse"],
    \   "BufferSaurusSyntaxContextedKeyDesc"    : [ "#779DB2", "", "italic,undercurl"],
    \   "bufferSaurusSyntaxContextedKeyFilename": [ "#808080", "",  ""],
    \   "BufferSaurusSyntaxContextedKeyLines"   : [ "#808080", "",  ""],
    \   "BufferSaurusSyntaxContextedKeyRow"     : [ "#808080", "",  "italic"],
    \   "BufferSaurusSyntaxContextLineNum"      : [ "#808080", "",  ""],
    \   "BufferSaurusSyntaxContextLineText"     : [ "#77996C", "",  "italic"],
    \   "BufferSaurusSyntaxFileGroupTitle"      : [ "#009F6F", "", "bold,italic"],
    \   "bufferSaurusSyntaxKey"                 : [ "#CC4455",      "",  ""],
    \   "BufferSaurusSyntaxMatchedLineNum"      : [ "#2FBBA6", "bg", ""],
    \   "BufferSaurusSyntaxMatchedLineText"     : [ "#D6B883", "bg", "italic"],
    \   "BufferSaurusSyntaxUncontextedLineNum"  : [ "#2FBBA6", "", ""],
    \   "BufferSaurusSyntaxUncontextedLineText" : [ "#C6B6FE", "bg", ""],
    \   "lsTag"                                 : [ "#009F6F", "", "bold,italic"],
            \ }

" C adn C++                                         {{{2
let s:dict_hi_c_cpp = {
    \   "_Block"                                : [ "#009F6F","","bold"],
    \   "_Bracket"                              : [ "#B89467", "",  ""],
    \   "_Comment"                              : [ "#5D8B9C", "",  ""],
    \   "_Operator"                             : [ "#00B880", "", ""],
    \   "cAnsiFunction"                         : [ "#2DB3A0", "", "bold"],
    \   "cAnsiName"                             : [ "#009F6F", "",  "italic"],
    \   "cBlock"                                : [ "seagreen3", "",  ""],
    \   "cBoolean"                              : [ "CadetBlue2", "",  ""],
    \   "cBraces"                               : [ "#779DB2", "",  "italic"],
    \   "cBracket"                              : [ "Green","",""],
    \   "cCharacter"                            : [ "#5780CC","","bold,italic"],
    \   "cComment"                              : [ "#8b8b8b","","italic"],
    \   "cConditional"                          : [ "#00B880","","bold"],
    \   "cConstant"                             : [ "#6B8FCC","",""],
    \   "cCppString"                            : [ "#9A85FF", "", "italic"],
    \   "cDefine"                               : [ "#00B880","",""],
    \   "cDefined"                              : [ "#00B880", "",  "italic"],
    \   "cDelimiter"                            : [ "#779DB2", "",  "italic"],
    \   "cDoxygenComment"                       : [ "LightSeaGreen","","italic"],
    \   "cFloat"                                : [ "AquaMarine2", "", ""],
    \   "cFunction"                             : [ "#C6B6FE", "",  ""],
    \   "cIdentifier"                           : [ "#009F6F", "",  "italic"],
    \   "cInclude"                              : [ "#00B880","",""],
    \   "cIncluded"                             : [ "#77996C", "",  ""],
    \   "cLabel"                                : [ "PaleGreen3","",""],
    \   "cMakeOperators"                        : [ "SpringGreen1", "",  ""],
    \   "cMakeVariableValue"                    : [ "DeepSkyBlue2", "",  ""],
    \   "cMulti"                                : [ "Red","","bold"],
    \   "cNumber"                               : [ "#99C4CC", "",  ""],
    \   "cOperator"                             : [ "LightSeaGreen", "",  "bold"],
    \   "cParen"                                : [ "Red","",""],
    \   "cppAccess"                             : [ "PaleGreen3", "",  "italic"],
    \   "cppBoolean"                            : [ "#8870FF", "", "bold"],
    \   "cppCast"                               : [ "#CC4455","",""],
    \   "cppOperator"                           : [ "#00B880", "", ""],
    \   "cppSTL"                                : [ "#009F6F","","bold"],
    \   "cppSTLtype"                            : [ "SkyBlue2", "",  "underline"],
    \   "cppStructure"                          : [ "PaleGreen3","","underline"],
    \   "cppType"                               : [ "#00B880", "", "bold"],
    \   "cPreCondit"                            : [ "PaleGreen3","","italic"],
    \   "cPreConditMatch"                       : [ "PaleGreen3","","italic"],
    \   "cPreProc"                              : [ "#00B880","",""],
    \   "cRepeat"                               : [ "#00B880","","bold"],
    \   "cSpecial"                              : [ "#8870FF", "", "italic"],
    \   "cSpecialCharacter"                     : [ "RoyalBlue", "", "italic"],
    \   "cStatement"                            : [ "#00B880","",""],
    \   "cStorageClass"                         : [ "#00B880","","bold"],
    \   "cString"                               : [ "#9A85FF", "", ""],
    \   "cStructure"                            : [ "SeaGreen3",  "#1C3644",  ""],
    \   "cTodo"                                 : [ "Wheat2", "#345FA8",  "italic"],
    \   "cType"                                 : [ "#00B880","",""],
    \   "cUserFunction"                         : [ "#009F6F","","bold"],
    \   "cUserFunctionPointer"                  : [ "LimeGreen", "",  "bold"],
    \   "cUserLabel"                            : [ "PaleGreen3","",""],
            \ }

" CSS                                               {{{2
let s:dict_hi_css = {
    \   "cssAnimationAttr"                      : [ "#8870FF", "",  ""],
    \   "cssAuralAttr"                          : [ "PowderBlue", "",  "italic"],
    \   "cssAuralProp"                          : [ "#C59F6F", "",  ""],
    \   "cssBackgroundAttr"                     : [ "#C59F6F", "",  ""],
    \   "cssBorderOutlineAttr"                  : [ "#A191F5", "",  "italic"],
    \   "cssBorderOutlineProp"                  : [ "#C59F6F", "",  ""],
    \   "cssBoxProp"                            : [ "#C59F6F", "",  ""],
    \   "cssClassName"                          : [ "SeaGreen3",  "#1C3644",  "bold,italic"],
    \   "cssColor"                              : [ "#9A85FF", "",  "italic"],
    \   "cssColorProp"                          : [ "#C59F6F","","italic"],
    \   "cssComment"                            : [ "#5D8B9C", "",  "italic"],
    \   "cssCommonAttr"                         : [ "#8870FF", "",  "italic"],
    \   "cssDefinition"                         : [ "PowderBlue", "",  "italic"],
    \   "cssDeprecated"                         : [ "", "#3D2B6B", ""],
    \   "cssFontAttr"                           : [ "#8870FF", "",  "italic"],
    \   "cssFontDescriptorProp"                 : [ "#C59F6F", "",  ""],
    \   "cssFontProp"                           : [ "#C59F6F", "",  "italic"],
    \   "cssFunction"                           : [ "#8870FF", "",  ""],
    \   "cssFunctionName"                       : [ "Turquoise3", "",  "underline"],
    \   "cssGeneratedContentProp"               : [ "#C59F6F", "",  ""],
    \   "cssIdentifier"                         : [ "Turquoise3", "",  ""],
    \   "cssImportant"                          : [ "DeepSkyBlue2", "",  ""],
    \   "cssInclude"                            : [ "Turquoise3", "",  ""],
    \   "cssMarginProp"                         : [ "#C59F6F", "",  ""],
    \   "cssMedia"                              : [ "SeaGreen3",  "#1C3644",  "bold,italic"],
    \   "cssMediaType"                          : [ "SeaGreen2","","italic"],
    \   "cssPaddingProp"                        : [ "#C59F6F", "",  ""],
    \   "cssPagingProp"                         : [ "#C59F6F", "",  ""],
    \   "cssPositioningAttr"                    : [ "#C59F6F", "",  ""],
    \   "cssPositioningProp"                    : [ "#C59F6F", "",  ""],
    \   "cssPseudoClassId"                      : [ "SeaGreen3",  "#1C3644",  "italic"],
    \   "cssRenderProp"                         : [ "#C59F6F", "",  ""],
    \   "cssSelectorOp"                         : [ "#8B8B8B", "",  ""],
    \   "cssStringQ"                            : [ "#9A85FF", "",  "italic"],
    \   "cssStringQQ"                           : [ "#9A85FF", "",  "italic"],
    \   "cssTableProp"                          : [ "#C59F6F", "",  ""],
    \   "cssTagName"                            : [ "SeaGreen3",  "#1C3644",  "bold,italic"],
    \   "cssTextProp"                           : [ "#C59F6F", "",  "italic"],
    \   "cssUIattr"                             : [ "#C59F6F", "",  ""],
    \   "cssUIProp"                             : [ "#C59F6F", "",  ""],
    \   "cssURL"                                : [ "SlateGray3", "",  "bold,underline"],
    \   "cssValueLength"                        : [ "#8870FF", "",  ""],
    \   "cssValueNumber"                        : [ "DeepSkyBlue1", "",  ""],
    \   "cssVendor"                             : [ "#C59F6F", "",  ""],
            \ }
"
" GTK or '.desktop' files                           {{{2
let s:dict_hi_desktop = {
    \   "dtALocale"                             : [ "#CC4455", "",  "bold"],
    \   "dtBooleanKey"                          : [ "#009F6F", "",  "bold"],
    \   "dtBooleanValue"                        : [ "CadetBlue2", "",  "bold"],
    \   "dtComment"                             : [ "#5D8B9C", "",  ""],
    \   "dtDelim"                               : [ "#5DDD9C", "",  ""],
    \   "dtExecKey"                             : [ "#009F6F", "",  "underline"],
    \   "dtExecParam"                           : [ "#5DDD9C", "",  "bold"],
    \   "dtGroup"                               : [ "#FF0044", "Black",  ""],
    \   "dtLocaleKey"                           : [ "#009F6F", "",  ""],
    \   "dtStringKey"                           : [ "#009F6F", "",  ""],
    \   "dtTypeKey"                             : [ "#009F6F", "",  "italic"],
    \   "gtkRcInclude"                          : [ "#009F6F", "",  "bold"],
    \   "gtkRcString"                           : [ "#7fa2e6", "",  "italic"],
    \ }

" Unix / Debian / network / FSTAB etc               {{{2
let s:dict_hi_unixtools = {
    \   "debChangeLogCloses"                    : [ "#8870FF", "",  "italic"],
    \   "debChangeLogEmail"                     : [ "SlateGray3", "",  "italic"],
    \   "debChangeLogEntry"                     : [ "#7EB49C", "", ""],
    \   "debChangeLogFooter"                    : [ "#009F6F", "",  ""],
    \   "debChangeLogHeader"                    : [ "#A8C2EF", "DarkSlateGrey",  "italic"],
    \   "debChangeLogLP"                        : [ "#8870FF", "",  ""],
    \   "debChangeLogName"                      : [ "AquaMarine", "#880C0E",  ""],
    \   "fsDeviceKeyword"                       : [ "#009F6F", "",  "bold"],
    \   "fsFreqPassNumber"                      : [ "#7DB3FF", "", ""],
    \   "fsMountPoint"                          : [ "#009F6F", "",  ""],
    \   "fsMountPointKeyword"                   : [ "AquaMarine3", "",  ""],
    \   "fsOperator"                            : [ "#8B8B8B", "",  ""],
    \   "fsOptions"                             : [ "#9A85FF", "",  ""],
    \   "fsOptionsExt2Errors"                   : [ "#9A85FF", "",  ""],
    \   "fsOptionsGeneral"                      : [ "#9A85FF", "",  ""],
    \   "fsOptionsKeywords"                     : [ "#9A85FF", "",  ""],
    \   "fsOptionsNumber"                       : [ "AquaMarine3", "",  ""],
    \   "fsTypeKeyword"                         : [ "#C59F6F", "",  ""],
    \   "zoneDomain"                            : [ "#A8C2EF",  "",  ""],
    \   "zoneRRtype"                            : [ "#A8C2EF",  "",  ""],
    \   "zoneTTL"                               : [ "#A8C2EF",  "",  ""],
    \   "zoneUnknown"                           : [ "#A8C2EF",  "",  ""],
    \ }

"
" Haskell                                              {{{2
let s:dict_hi_haskell = {
    \   "hsStatement"                           : [ "DarkSlateGray2", "SeaGreen",  ""],
    \   "hsStructure"                           : [ "DarkSlateGray2", "SeaGreen",  ""],
    \   "hsVarSym"                              : [ "red", "",  ""],
    \ }

" Ruby                                             {{{2
let s:dict_hi_ruby = {
    \   "eRubyBlock"                            : [ "#8870FF","","italic"],
    \   "eRubyDelimiter"                        : [ "CadetBlue4", "",  ""],
    \   "eRubyExpression"                       : [ "#00B780","","bold,italic"],
    \   "rubyAccess"                            : [ "#7EB49C", "", "italic"],
    \   "rubyArrayDelimiter"                    : [ "#4A77FF", "",  "bold"],
    \   "rubyBlock"                             : [ "#009F6F","",""],
    \   "rubyBlockParameter"                    : [ "PaleGreen3", "#1c3644", ""],
    \   "rubyBlockParameterList"                : [ "", "#1c3644", "bold"],
    \   "rubyCaseExpression"                    : [ "#8870FF", "",  "italic"],
    \   "rubyClass"                             : [ "#CC4455","","bold"],
    \   "rubyComment"                           : [ "#5B8999", "", "italic"],
    \   "rubyConditional"                       : [ "PaleGreen3", "", "bold"],
    \   "rubyConditionalExpression"             : [ "#009F6F", "", ""],
    \   "rubyConstant"                          : [ "#779DB2", "",  ""],
    \   "rubyControl"                           : [ "#CC4455", "", "underline"],
    \   "rubyCurlyBlock"                        : [ "#978CCC", "",  "bold"],
    \   "rubyDefine"                            : [ "#85B2FE", "", "italic"],
    \   "rubyDoBlock"                           : [ "#009F6F","",""],
    \   "rubyExceptional"                       : [ "LightCyan3", "bg",  "bold"],
    \   "rubyFloat"                             : [ "AquaMarine3", "", ""],
    \   "rubyFunction"                          : [ "#85B2FE", "#1C3644", "italic"],
    \   "rubyGlobalVariable"                    : [ "SkyBlue3", "",  ""],
    \   "rubyIdentifier"                        : [ "#c6b6fe", "",  ""],
    \   "rubyInclude"                           : [ "LightCyan3", "bg",  "bold"],
    \   "rubyInstanceVariable"                  : [ "#2DB3A0", "", ""],
    \   "rubyInteger"							: [ "#85B2FE", "",  ""],
    \   "rubyInterpolation"                     : [ "#CC4455",      "",  ""],
    \   "rubyInterpolationDelimiter"            : [ "FireBrick2", "",  ""],
    \   "rubyKeyword"							: [ "#00B780", "", ""],
    \   "rubyLocalVariableOrMethod"             : [ "SeaGreen3","","bold,italic"],
    \   "rubyMethodBlock"                       : [ "SeaGreen3","",""],
    \   "rubyModule"                            : [ "LightCyan3", "",  "underline"],
    \   "rubyOptionalDoLine"                    : [ "PaleGreen3", "", ""],
    \   "rubyPredefinedConstant"                : [ "#009F6F", "",  ""],
    \   "rubyPredefinedIdentifier"              : [ "#de5577", "",  ""],
    \   "rubyPredefinedVariable"                : [ "PaleGreen3", "",  ""],
    \   "rubyPseudoVariable"                    : [ "#8870FF", "",  ""],
    \   "rubyRegexp"                            : [ "#2DB3A0", "",  ""],
    \   "rubyRegexpAnchor"                      : [ "#2DB3A0", "",  ""],
    \   "rubyRegexpCharClass"                   : [ "#c59f6f", "",  "bold"],
    \   "rubyRegexpDelimiter"                   : [ "SeaGreen2", "", ""],
    \   "rubyRegexpEscape"                      : [ "#2DB3A0", "",  ""],
    \   "rubyRegexpQuantifier"                  : [ "#c59f6f", "",  ""],
    \   "rubyRegexpSpecial"                     : [ "#2DB3A0", "",  "bold"],
    \   "rubyRepeat"                            : [ "#2FBBA6", "",  ""],
    \   "rubyRepeatExpression"                  : [ "#978CCC", "",  "italic"],
    \   "rubySharpBang"                         : [ "#C73648", "", "bold,italic"],
    \   "rubyString"                            : [ "#9A85FF", "",  ""],
    \   "rubyStringDelimiter"                   : [ "#85B2FE", "",  ""],
    \   "rubyStringEscape"                      : [ "#99AD6a", "",  ""],
    \   "rubySymbol"                            : [ "#6E8CBF", "",  ""],
    \   "rubyTodo"                              : [ "Wheat2", "#345FA8",  ""],
            \ }

" Help (Vim Help)                                   {{{2
let s:dict_hi_vimhelp = {
    \   "helpBar"								: [ "FireBrick1", "#880C0E",  ""],
    \   "helpCommand"							: [ "#F3C284", "#880C0E",  ""],
    \   "helpExample"                           : [ "#99AD6A", "",  ""],
    \   "helpHeader"                            : [ "CadetBlue3", "",  "underline"],
    \   "helpHeadline"                          : [ "AquaMarine3", "",  "underline"],
    \   "helpHypertextEntry"                    : [ "AquaMarine2", "#573D8C",  "underline"],
    \   "helpHypertextJump"                     : [ "#00B780", "",  "underline"],
    \   "helpIgnore"							: [ "bg", "",  ""],
    \   "helpNote"                              : [ "#C6B6FE", "",  "bold,underline"],
    \   "helpNotVi"                             : [ "#567F8F", "",  "italic"],
    \   "helpOption"                            : [ "SteelBlue2", "",  "bold"],
    \   "helpSectionDelim"                      : [ "PaleVioletRed3", "",  ""],
    \   "helpSpecial"                           : [ "SkyBlue2", "",  "underline"],
    \   "helpStar"								: [ "FireBrick1", "#880C0E",  ""],
    \   "helpTodo"								: [ "#7EB49C", "", ""],
    \   "helpURL"                               : [ "#8870FF", "",  "bold,underline"],
    \   "helpVim"                               : [ "Wheat", "#2D7067",  "italic,underline"],
            \ }

" Html                                              {{{2
let s:dict_hi_html = {
    \   "htmlArg"                               : [ "AquaMarine3", "",  ""],
    \   "htmlBold"                              : [ "SkyBlue2", "",  "italic"],
    \   "htmlComment"                           : [ "#CC4455",      "",  "italic"],
    \   "htmlCommentPart"                       : [ "#6A6A6A",  "",  "italic"],
    \   "htmlEndTag"                            : [ "SlateGray4", "", "bold"],
    \   "htmlEvent"                             : [ "LightCyan3", "bg",  "bold,italic"],
    \   "htmlEventDQ"                           : [ "Green3",  "#1C3644",  "italic"],
    \   "htmlH1"                                : [ "FireBrick1", "#14332C", "bold,italic"],
    \   "htmlH2"                                : [ "#F4E891", "#14332C",  "italic"],
    \   "htmlH3"                                : [ "RosyBrown1", "#14332C", "italic"],
    \   "htmlH4"                                : [ "White",         "#14332C",  "italic"],
    \   "htmlH5"                                : [ "Aquamarine2","#14332C",  "italic"],
    \   "htmlH6"                                : [ "#A1F195",    "#14332C",  "italic"],
    \   "htmlLink"                              : [ "#A191F5", "", "bold,italic"],
    \   "htmlSpecialChar"                       : [ "#2DB3A0", "",  ""],
    \   "htmlSpecialTagName"                    : [ "Turquoise3", "",  ""],
    \   "htmlString"                            : [ "#66aa99", "", "italic"],
    \   "htmlTag"                               : [ "LightCyan3", "bg",  ""],
    \   "htmlTagN"                              : [ "DarkSeaGreen3", "#1C3644", "italic"],
    \   "htmlTagName"                           : [ "LimeGreen", "#1C3644", "italic"],
            \ }

" Java / JVM / Scala, and related tools             {{{2
let s:dict_hi_javatools = {
    \   "javaAnnotation"                        : [ "#8870FF","","italic"],
    \   "javaAssert"                            : [ "SeaGreen2", "",  ""],
    \   "javaBoolean"                           : [ "#2DB3A0", "",  "italic,bold"],
    \   "javaBranch"                            : [ "#2DB3A0", "",  ""],
    \   "javaCharacter"                         : [ "CornFlowerBlue", "",  ""],
    \   "javaClassDecl"                         : [ "#00B880","","italic,underline"],
    \   "javaComment"                           : [ "#5B8999", "",  "italic"],
    \   "javaComment2String"                    : [ "#5B8999","",""],
    \   "javaCommentCharacter"                  : [ "blue","",""],
    \   "javaCommentStar"                       : [ "AquaMarine4","","bold,italic"],
    \   "javaCommentString"                     : [ "#5B8999","",""],
    \   "javaCommentTitle"                      : [ "SlateGray3", "",  "italic"],
    \   "javaConditional"                       : [ "CadetBlue3", "", "bold"],
    \   "javaConstant"                          : [ "MediumSlateBlue","",""],
    \   "javaDocComment"                        : [ "#5B8999", "",  "italic"],
    \   "javaDocParam"                          : [ "SlateGray4", "",  "italic"],
    \   "javaDocTags"                           : [ "SlateGray4", "",  "bold,italic"],
    \   "javaError"                             : [ "Navy", "#5FD75F",  "undercurl"],
    \   "javaExceptions"                        : [ "SeaGreen3","","italic"],
    \   "javaExternal"                          : [ "LightCyan3", "bg",  ""],
    \   "javaFold"                              : [ "#FFD1FA","","bold"],
    \   "javaFuncBody"                          : [ "PaleGreen2", "DarkSlateGray",  "italic"],
    \   "javaFuncDef"                           : [ "Turquoise2", "",  ""],
    \   "javaLabel"                             : [ "SeaGreen2", "",  ""],
    \   "javaLangObject"                        : [ "#7F9D90", "", "" ],
    \   "javaLineComment"                       : [ "#5B8999", "", "italic"],
    \   "javaMethodDecl"                        : [ "Aquamarine3", "",  "italic"],
    \   "javaNumber"                            : [ "#7DB3FF", "", ""],
    \   "javaOperator"                          : [ "Aquamarine3", "",  "italic"],
    \   "javaParenT"                            : [ "GoldenRod", "DarkCyan",  "bold"],
    \   "javaRepeat"                            : [ "CadetBlue3", "", "bold"],
    \   "javaScopeDecl"                         : [ "#009F6F","","bold,italic"],
    \   "javaSpecial"                           : [ "#88CB35", "",  ""],
    \   "javaSpecialChar"                       : [ "#88CB35", "",  ""],
    \   "javaSpecialCharError"                  : [ "Khaki2", "VioletRed4",  ""],
    \   "javaSpecialError"                      : [ "Navy", "#5FD75F",  "undercurl"],
    \   "javaStatement"                         : [ "#2DB3A0", "",  "italic"],
    \   "javaStorageClass"                      : [ "#7EB49C", "", "italic"],
    \   "javaStringError"                       : [ "Navy", "#5FD75F",  "undercurl"],
    \   "javaTodo"                              : [ "Wheat2", "#345FA8",  "italic"],
    \   "javaType"                              : [ "#00B880","","italic"],
    \   "javaTypeDef"                           : [ "#009F6F","",""],
    \   "javaUserLabel"                         : [ "SeaGreen2", "",  ""],
    \   "javaUserLabelRef"                      : [ "SeaGreen2", "",  ""],
    \   "jPropertiesDelimiter"                  : [ "#A191F5", "",  ""],
    \   "jPropertiesSpecial"                    : [ "#869BCC", "",  "bold"],
    \   "jPropertiesSpecialChar"                : [ "#A191F5", "",  ""],
    \   "jPropertiesString"                     : [ "PowderBlue", "",  ""],
    \   "log4jDate"                             : [ "DeepSkyBlue2", "",  "bold"],
    \   "log4jErrorlevel"                       : [ "SeaGreen2", "",  "italic,underline"],
    \   "log4jLogger"                           : [ "#779DB2", "",  "underline"],
    \   "log4jProcessid"                        : [ "Turquoise2", "",  "bold,italic"],
    \   "scalaClassDecl"                        : [ "#c59f6f", "",  ""],
    \   "scalaFunction"                         : [ "Aquamarine3", "",  "bold,italic"],
    \   "scalaLineComment"                      : [ "#78B37A", "",  ""],
    \   "scalaStorageClass"                     : [ "#c59f6f", "",  "italic"],
    \   "scalaTypeDef"                          : [ "Turquoise2", "",  ""],
            \ }

" Javascript                           {{{2
let s:dict_hi_jscript = {
    \   "javascript"                            : [ "#66A0B0", "", ""],
    \   "javaScriptAjaxMethods"                 : [ "SeaGreen1", "",  ""],
    \   "javaScriptAjaxObjects"                 : [ "#F4E891", "",  "italic"],
    \   "javaScriptAjaxProperties"              : [ "#65C254", "",  ""],
    \   "javascriptBoolean"                     : [ "#8870FF", "",  "italic"],
    \   "javascriptBraces"                      : [ "#009F6F","",""],
    \   "javaScriptBranch"                      : [ "#2FBBA6", "",  ""],
    \   "javaScriptBrowserObjects"              : [ "CadetBlue3", "",  "bold"],
    \   "javaScriptCharacter"                   : [ "SeaGreen2", "",  ""],
    \   "javaScriptComment"                     : [ "#77996C", "",  "italic"],
    \   "javascriptCommentTodo"                 : [ "#C6B6FE", "#345FA8",  "italic"],
    \   "javascriptConditional"                 : [ "SeaGreen2","","italic"],
    \   "javaScriptCssStyles"                   : [ "#2DB3A0", "",  ""],
    \   "javaScriptCvsTag"                      : [ "#85B2FE", "",  "italic"],
    \   "javaScriptDeprecated"                  : [ "#8B8B8B", "",  "bold,italic"],
    \   "javaScriptDocComment"                  : [ "#5D8B9C", "",  "italic"],
    \   "javaScriptDocParam"                    : [ "#009F6F", "",  "bold"],
    \   "javaScriptDocSeeTag"                   : [ "#A191F5", "",  "italic"],
    \   "javaScriptDocTags"                     : [ "#A191F5", "",  "italic"],
    \   "javaScriptDomElemAttrs"                : [ "SkyBlue1", "",  "italic"],
    \   "javaScriptDomElemFuncs"                : [ "#A191F5", "",  "italic"],
    \   "javaScriptDomErrNo"                    : [ "#CC4455", "",  "bold"],
    \   "javaScriptDOMMethods"                  : [ "Aquamarine3", "",  "italic"],
    \   "javaScriptDomNodeConsts"               : [ "SkyBlue2", "",  ""],
    \   "javaScriptDOMObjects"                  : [ "CadetBlue2", "",  "italic"],
    \   "javaScriptDOMProperties"               : [ "#00B880", "",  ""],
    \   "javaScriptEndColons"                   : [ "#7575FA", "",  "bold"],
    \   "javaScriptError"                       : [ "Navy", "#5FD75F",  "undercurl"],
    \   "javaScriptEventListenerKeywords"       : [ "SeaGreen2", "",  ""],
    \   "javaScriptExceptions"                  : [ "#2FBBA6", "",  "italic"],
    \   "javaScriptFloat"                       : [ "#7FA2E6", "",  ""],
    \   "javaScriptFuncName"                    : [ "LimeGreen", "",  "italic"],
    \   "javascriptFunction"                    : [ "LimeGreen", "", "italic"],
    \   "javascriptGlobal"                      : [ "#009F6F","","bold,italic"],
    \   "javaScriptGlobalObjects"               : [ "#009F6F", "",  ""],
    \   "javaScriptHtmlElemAttrs"               : [ "PaleGreen3", "",  "italic"],
    \   "javaScriptHtmlElemFuncs"               : [ "PaleGreen3", "",  "bold"],
    \   "javaScriptHtmlElemProperties"          : [ "Aquamarine3", "",  ""],
    \   "javaScriptHtmlEvents"                  : [ "SlateGray3", "",  "bold"],
    \   "javascriptIdentifier"                  : [ "#2DB3A0", "",  "bold,italic"],
    \   "javaScriptLabel"                       : [ "PaleGreen3", "",  ""],
    \   "javaScriptLineComment"                 : [ "#5D8B9C", "",  ""],
    \   "javaScriptLogicSymbols"                : [ "CadetBlue2", "",  ""],
    \   "javascriptMember"                      : [ "SeaGreen3","","italic"],
    \   "javascriptMessage"                     : [ "SlateGray3", "",  "underline"],
    \   "javascriptNull"                        : [ "CadetBlue3","",""],
    \   "javaScriptNumber"                      : [ "#85B2FE", "",  ""],
    \   "javascriptOperator"                    : [ "#2DB3A0","",""],
    \   "javaScriptOpSymbols"                   : [ "PaleGreen3", "",  "bold"],
    \   "javaScriptParens"                      : [ "#A191F5", "",  "italic"],
    \   "javaScriptParensErrA"                  : [ "SteelBlue2", "",  ""],
    \   "javaScriptParensErrB"                  : [ "SteelBlue2", "",  ""],
    \   "javaScriptParensErrC"                  : [ "SteelBlue2", "",  ""],
    \   "javaScriptParensError"                 : [ "SteelBlue2", "",  ""],
    \   "javaScriptProprietaryObjects"          : [ "#99AD6A", "",  ""],
    \   "javaScriptPrototype"                   : [ "SkyBlue1", "",  ""],
    \   "javascriptRegexpString"                : [ "CadetBlue3", "#1C3644", "italic"],
    \   "javascriptRepeat"                      : [ "SeaGreen3",  "#1C3644",  "italic"],
    \   "javaScriptReserved"                    : [ "#8FBFDC", "",  ""],
    \   "javaScriptSource"                      : [ "#779DB2", "",  ""],
    \   "javascriptSpecial"                     : [ "#7697d6", "",  "italic"],
    \   "javascriptStatement"                   : [ "SeaGreen2",  "",  ""],
    \   "javascriptStringD"                     : [ "#7fa2e6", "",  "italic"],
    \   "javascriptStringS"                     : [ "#66aa99", "", "italic"],
    \   "javascriptType"                        : [ "#00B780","","bold"],
    \   "javaScriptValue"                       : [ "CadetBlue2", "",  ""],
    \   }
"
" Lisp and Scheme                                   {{{2
let s:dict_hi_lisp = {
    \   "lispAtom"                              : [ "#00B780", "",  ""],
    \   "lispAtomList"                          : [ "#8870FF", "",  "bold"],
    \   "lispComment"                           : [ "#5D8B9C", "",  "italic"],
    \   "lispDecl"                              : [ "#009F6F","","bold"],
    \   "lispEscapeSpecial"                     : [ "#779DB2", "",   ""],
    \   "lispFunc"                              : [ "SkyBlue2", "",  ""],
    \   "lispKey"                               : [ "#009F6F", "",  "italic"],
    \   "lispMark"                              : [ "#779DB2", "",  "bold"],
    \   "lispNumber"                            : [ "#85B2FE", "",  ""],
    \   "lispParenError"                        : [ "Wheat2", "#345FA8",  ""],
    \   "lispString"                            : [ "#9A85FF", "",  ""],
    \   "lispSymbol"                            : [ "#2DB3A0", "", "italic"],
    \   "lispTodo"                              : [ "Wheat2", "#345FA8",  ""],
    \   "schemeComment"                         : [ "#5D8B9C", "",  "italic"],
    \   "schemeError"                           : [ "#8870FF", "",  "underline"],
    \   "schemeFunc"                            : [ "#2DB3A0", "", ""],
    \   "schemeOther"                           : [ "AquaMarine3", "",  ""],
    \   "schemeString"                          : [ "#9A85FF","",""],
    \   "schemeStruct"                          : [ "PaleGreen3","",""],
    \   "schemeSyntax"                          : [ "SkyBlue2", "",  ""],
    \   }

" Markdown plugins                                 {{{2
let s:dict_hi_markdown = {
    \   "markdownAutomaticLink"                 : [ "#FFD1FA", "", "underline"],
    \   "markdownBlockquote"                    : [ "#99ad6a", "",  ""],
    \   "markdownBold"                          : [ "PaleGreen2","#082926", "bold" ],
    \   "markdownBoldItalic"                    : [ "RoyalBlue", "bg",  "bold,italic"],
    \   "markdownCode"                          : [ "SeaGreen2", "",  ""],
    \   "markdownCodeBlock"                     : [ "SeaGreen2", "",  ""],
    \   "markdownEscape"                        : [ "DodgerBlue2", "",  ""],
    \   "markdownH1"                            : [ "Black", "LimeGreen",  "bold"],
    \   "markdownH2"                            : [ "PaleGoldenrod", "#0e2628",  ""],
    \   "markdownH3"                            : [ "LightBlue2","PaleTurquoise4",  "bold,italic"],
    \   "markdownH4"                            : [ "LightBlue2", "BurlyWood4", "bold,italic"],
    \   "markdownH5"                            : [ "Wheat", "Maroon4",  ""],
    \   "markdownH6"                            : [ "#FDD99B", "#573D8C",  ""],
    \   "markdownHeadingDelimiter"              : [ "#8B8B8B", "",  "italic"],
    \   "markdownHeadingRule"                   : [ "#8B8B8B", "",  "italic"],
    \   "markdownItalic"                        : [ "PaleGreen2", "DarkSlateGray",  "italic"],
    \   "markdownLineBreak"                     : [ "Wheat2", "Maroon4",  ""],
    \   "markdownLinkDelimiter"                 : [ "#8B8B8B", "",  "italic"],
    \   "markdownLinkText"                      : [ "#FFD1FA", "", "underline"],
    \   "markdownLinkTextDelimiter"             : [ "#8B8B8B", "",  "italic"],
    \   "markdownListMarker"                    : [ "SpringGreen2", "",  ""],
    \   "markdownOrderedListMarker"             : [ "SpringGreen2", "",  ""],
    \   "markdownRule"                          : [ "#8B8B8B", "",  "italic"],
    \   "markdownUrl"                           : [ "#66aa99", "", "italic"],
    \   "markdownUrlDelimiter"                  : [ "#779DB2", "",  ""],
    \   "markdownUrlTitle"                      : [ "SeaGreen2", "",  ""],
    \   "markdownUrlTitleDelimiter"             : [ "#779DB2", "",  ""],
    \   "markdownValid"                         : [ "#C6B6FE", "bg",  ""],
    \   "mkdBlockCode"                          : [ "SeaGreen2", "",  ""],
    \   "mkdBlockquote"                         : [ "#99ad6a", "",  ""],
    \   "mkdCode"                               : [ "SlateGray3", "",  "italic"],
    \   "mkdDelimiter"                          : [ "#779DB2", "",  ""],
    \   "mkdID"                                 : [ "FireBrick1", "Black", ""],
    \   "mkdLineBreak"                          : [ "#8B8B8B", "",  "bold"],
    \   "mkdLineContinue"                       : [ "#8B8B8B", "",  "italic"],
    \   "mkdLink"                               : [ "#71D3B4", "#1E3B31",  ""],
    \   "mkdLinkDef"                            : [ "FireBrick1", "Black", ""],
    \   "mkdLinkDefTarget"                      : [ "#66aa99", "", "italic"],
    \   "mkdLinkTitle"                          : [ "SeaGreen2", "",  ""],
    \   "mkdListCode"                           : [ "#00B780", "",  "italic"],
    \   "mkdListItem"                           : [ "AquaMarine2", "", "italic"],
    \   "mkdRule"                               : [ "#8B8B8B", "",  "italic"],
    \   "mkdString"                             : [ "#99ad6a", "",  ""],
    \   "mkdURL"                                : [ "#66aa99", "", "italic"],
            \ }

" RDF and/or Graph tools                            {{{2
let s:dict_hi_rdf_and_graphs = {
    \   "n3ClassName"                           : [ "DeepSkyBlue2", "",  ""],
    \   "n3Declaration"                         : [ "#009F6F", "", ""],
    \   "n3EndStatement"                        : [ "RosyBrown", "",  "bold"],
    \   "n3Prefix"                              : [ "#009F6F", "",  ""],
    \   "n3PropertyName"                        : [ "#65C254", "",  ""],
    \   "n3Separator"                           : [ "Red","","bold"],
    \   "n3String"                              : [ "DodgerBlue2", "",  ""],
    \   "n3StringDelim"                         : [ "DodgerBlue2", "",  "bold"],
    \   "n3URI"                                 : [ "DeepSkyBlue2", "",  ""],
    \   "plantUMLDirectedOrVerticalArrowRL"     : [ "Green2", "",  "bold"],
    \   "plantUMLHorizontalArrow"               : [ "Orange", "",  "bold"],
    \   "plantUMLKeyword"                       : [ "#00B880","",""],
    \   "plantUMLSpecialString"                 : [ "CadetBlue3", "",  "bold,italic"],
    \   "plantUMLString"                        : [ "#7fa2e6", "",  "italic"],
    \   "plantUMLText"                          : [ "PaleGreen3", "",  ""],
    \   "plantUMLTypeKeyword"                   : [ "#009F6F", "", ""],
            \ }

" NERDTree, Netrw and other directory list plugins  {{{2
let s:dict_hi_nerds = {
    \   "lsDir"                                 : [ "Turquoise", "Gray10",  ""],
    \   "nerdtreeCwd"                           : [ "", "#3D2B6B", "bold"],
    \   "nerdtreeDir"                           : [ "PaleGoldenrod", "#0e2628",  ""],
    \   "nerdtreeDirSlash"                      : [ "PaleGoldenrod", "",  ""],
    \   "nerdtreeExecFile"                      : [ "Red", "",  ""],
    \   "nerdtreeFile"                          : [ "#00B880","",""],
    \   "nerdtreeFlag"                          : [ "#5D8B9C", "",  ""],
    \   "nerdtreeHelp"                          : [ "#8fbfdc", "",  ""],
    \   "nerdtreeHelpKey"                       : [ "#00B880", "",  ""],
    \   "nerdtreeHelpTitle"                     : [ "AquaMarine2", "#880C0E",  ""],
    \   "nerdtreeOpenable"                      : [ "PaleGoldenrod", "",  "bold"],
    \   "nerdtreePart"                          : [ "LightSlateGray", "", "bold"],
    \   "nerdtreePartFile"                      : [ "LightSlateGray", "", "bold"],
    \   "nerdtreeRO"                            : [ "SkyBlue3", "",  ""],
    \   "nerdtreeToggleOff"                     : [ "SlateGray3", "",  "bold"],
    \   "nerdtreeToggleOn"                      : [ "SlateGray3", "",  "bold,underline"],
    \   "nerdtreeUp"                            : [ "LightSlateGray","","bold"],
    \   "netrwClassify"                         : [ "DodgerBlue", "",  ""],
    \   "netrwCmdNote"                          : [ "Wheat", "#2D7067",  ""],
    \   "netrwCmdSep"                           : [ "AquaMarine", "#880C0E",  ""],
    \   "netrwComment"                          : [ "#42A396", "",  ""],
    \   "netrwDir"                              : [ "SkyBlue2", "",  "underline"],
    \   "netrwHelpCmd"                          : [ "AquaMarine", "#880C0E",  "bold"],
    \   "netrwPlain"                            : [ "#00B880","",""],
    \   "netrwQuickHelp"                        : [ "AquaMarine", "#880C0E",  ""],
    \   "netrwSymLink"                          : [ "SkyBlue2", "",  "underline"],
    \   "netrwVersion"                          : [ "#2D7067", "",  "italic"],
            \ }

" Ocaml, Dot, SML                                   {{{2
let s:dict_hi_ocaml = {
    \   "dotBraceEncl"                          : [ "SeaGreen2", "",  ""],
    \   "dotBraceErr"                           : [ "Khaki2", "VioletRed4",  ""],
    \   "dotBrackEncl"                          : [ "SeaGreen2", "",  ""],
    \   "dotBrackErr"                           : [ "Khaki2", "VioletRed4",  ""],
    \   "dotIdentifier"                         : [ "#009F6F", "",  "italic"],
    \   "dotKeyChar"                            : [ "SeaGreen2", "",  ""],
    \   "dotKeyword"                            : [ "SeaGreen2", "",  ""],
    \   "dotParEncl"                            : [ "SeaGreen2", "",  ""],
    \   "dotParErr"                             : [ "Khaki2", "VioletRed4",  ""],
    \   "dotString"                             : [ "#99ad6a", "",  ""],
    \   "dottedName"                            : [ "#57d700", "",  ""],
    \   "dotTodo"                               : [ "Wheat2", "Maroon4",  ""],
    \   "dotType"                               : [ "PaleGreen2", "DarkSlateGray",  "italic"],
    \   "ocamlAnyVar"                           : [ "SeaGreen2", "", "bold"],
    \   "ocamlComment"                          : [ "#5D8B9C", "",  "italic"],
    \   "ocamlConstructor"                      : [ "CadetBlue3", "",  "italic"],
    \   "ocamlFullMod"                          : [ "PowderBlue", "", ""],
    \   "ocamlKeyChar"                          : [ "#7FA2E6", "",  ""],
    \   "ocamlKeyword"                          : [ "SeaGreen3", "", ""],
    \   "ocamlLabel"                            : [ "#2DB3A0", "",  "bold"],
    \   "ocamlLCIdentifier"                     : [ "#009F6F", "", ""],
    \   "ocamlModPath"                          : [ "LightCyan3", "",  ""],
    \   "ocamlModule"                           : [ "PowderBlue", "", "bold"],
    \   "ocamlNumber"                           : [ "#85B2FE", "#1C3644", "italic"],
    \   "ocamlOperator"                         : [ "#4444CC", "", ""],
    \   "ocamlSig"                              : [ "OrangeRed", "", ""],
    \   "ocamlString"                           : [ "#9A85FF","","italic"],
    \   "ocamlType"                             : [ "#2DB3A0", "", "italic"],
    \   "smlEnd"                                : [ "#779DB2", "",   "bold"],
    \   "smlKeyChar"                            : [ "RoyalBlue", "",  ""],
    \   "smlLCIdentifier"                       : [ "#009F6F", "",  "italic"],
    \   "smlString"                             : [ "#8870FF", "",  ""],
            \ }

" Perl                                              {{{2
let s:dict_hi_perl = {
    \   "perlComment"                           : [ "#77996C", "",  "italic"],
    \   "perlConditional"                       : [ "SeaGreen3",  "#1C3644",  "italic"],
    \   "perlControl"                           : [ "SkyBlue", "DarkSlateGrey", "bold"],
    \   "perlFileDescRead"                      : [ "#A08EF8", "",  "bold"],
    \   "perlFileDescStatement"                 : [ "#A08EF8", "",  "bold"],
    \   "perlFloat"                             : [ "#7fa2e6", "", ""],
    \   "perlFunction"                          : [ "#32C5B0", "", "bold"],
    \   "perlFunctionName"                      : [ "Aquamarine3", "",  ""],
    \   "perlIdentifier"                        : [ "OliveDrab3", "",  "underline"],
    \   "perlLabel"                             : [ "PaleGreen2", "DarkSlateGray",  "italic"],
    \   "perlMatch"                             : [ "#8870FF", "",  ""],
    \   "perlMatchStartEnd"                     : [ "#8870FF", "",  ""],
    \   "perlMethod"                            : [ "#67BF54", "#1C3644", "italic"],
    \   "perlNumber"                            : [ "#7fa2e6", "",  ""],
    \   "perlOperator"                          : [ "SpringGreen3", "",  "bold"],
    \   "perlPackageRef"                        : [ "#7fa2e6", "",  "bold"],
    \   "perlRepeat"                            : [ "SeaGreen3",  "#1C3644",  "bold,italic"],
    \   "perlSharpBang"                         : [ "#81A676", "",  ""],
    \   "perlSpecialMatch"                      : [ "#7fa2e6", "",  "italic"],
    \   "perlSpecialString"                     : [ "#CC4455", "",  ""],
    \   "perlStatementControl"                  : [ "Aquamarine3", "",  "italic"],
    \   "perlStatementFileDesc"                 : [ "Aquamarine3", "",  ""],
    \   "perlStatementFiles"                    : [ "Aquamarine3", "",  ""],
    \   "perlStatementFlow"                     : [ "SeaGreen3",  "#1C3644",  "italic"],
    \   "perlStatementList"                     : [ "seagreen3", "",  ""],
    \   "perlStatementScalar"                   : [ "#00CC8A", "",  "italic"],
    \   "perlStatementStorage"                  : [ "#00CC8A", "",  "italic"],
    \   "perlString"                            : [ "#7fa2e6", "",  "italic"],
    \   "perlStringStartEnd"                    : [ "#009F6F","",""],
    \   "perlStringUnexpanded"                  : [ "#00BA83","","italic"],
    \   "perlSubName"                           : [ "#32C5B0", "",  "bold"],
    \   "perlSubPrototype"                      : [ "#CC4455", "",  ""],
    \   "perlTodo"                              : [ "Wheat2", "#345FA8",  "italic"],
    \   "perlVarPlain"                          : [ "#00BA83","","italic"],
    \   "perlVarPlain2"                         : [ "#2DB3A0", "",  "italic"],
    \   "perlVarSimpleMember"                   : [ "#8870FF", "",  ""],
    \   "perlVarSlash"                          : [ "#41E7B5", "",  "bold,italic"],
            \ }

" PL/SQL and SQL plugins                            {{{2
let s:dict_hi_sql = {
    \   "plsqlAttribute"                        : [ "SlateGray3", "",  "bold,underline"],
    \   "plsqlBooleanLiteral"                   : [ "SlateBlue1", "#1C3644", ""],
    \   "plsqlComment"                          : [ "#5D8B9C", "",  "italic"],
    \   "plsqlCommentL"                         : [ "#5D8B9C", "",  ""],
    \   "plsqlConditional"                      : [ "PowderBlue","",""],
    \   "plsqlErrInBracket"                     : [ "RosyBrown", "",  ""],
    \   "plsqlFunction"                         : [ "#CC4455", "",  ""],
    \   "plsqlGarbage"                          : [ "Red", "bg",  "bold"],
    \   "plsqlHostIdentifier"                   : [ "#779DB2", "#1C3644",  ""],
    \   "plsqlIdentifier"                       : [ "#2FBBA6","",""],
    \   "plsqlIntLiteral"                       : [ "#7FAAF2", "#1C3644", ""],
    \   "plsqlKeyword"                          : [ "PowderBlue","",""],
    \   "plsqlOperator"                         : [ "RosyBrown", "",  "bold,italic"],
    \   "plsqlPseudo"                           : [ "SlateBlue1", "",  ""],
    \   "plsqlRepeat"                           : [ "PaleGreen2", "#1c3644",  ""],
    \   "plsqlSQLKeyword"                       : [ "Orange", "DarkSlateGrey", "bold" ],
    \   "plsqlSQLKeyword2"                      : [ "#2FBBA6","","bold"],
    \   "plsqlSQLKeyword3"                      : [ "#7EB49C", "", "italic"],
    \   "plsqlSQLKeyword4"                      : [ "#C59F6F", "bg", "" ],
    \   "plsqlSQLTypeAttribute"                 : [ "#C59F6F", "bg", "underline" ],
    \   "plsqlStorage"                          : [ "CornFlowerBlue","",""],
    \   "plsqlStringError"                      : [ "LemonChiffon2","DodgerBlue3",""],
    \   "plsqlStringLiteral"                    : [ "Aquamarine3", "",  "italic"],
    \   "plsqlSymbol"                           : [ "#8870FF","","bold"],
    \   "sqlHibSnippet"                         : [ "bg", "#7FAAF2", "bold"],
    \   "sqlKeyword"                            : [ "#8FBFDC", "", "italic,underline"],
    \   "sqlNumber"                             : [ "#85B2FE", "#1C3644", "italic"],
    \   "sqlOperator"                           : [ "#99AD6A", "",  ""],
    \   "sqlSnippet"                            : [ "PaleGreen3", "",  ""],
    \   "sqlSpecial"                            : [ "#99AD6A", "",  ""],
    \   "sqlStatement"                          : [ "PaleGreen3","","underline"],
    \   "sqlString"                             : [ "#009F6F","","bold"],
    \   "sqlTodo"                               : [ "Wheat2", "#345FA8",  "italic"],
    \   "sqlType"                               : [ "#00B880","","italic"],
            \ }

" Python                                            {{{2
let s:dict_hi_python = {
    \   "pyNiceStatement"                       : [ "Gold2", "",  ""],
    \   "pythonArithmetic"                      : [ "#009F6F","","bold"],
    \   "pythonAssignment"                      : [ "#009F6F","","bold"],
    \   "pythonBinError"                        : [ "Navy", "#5FD75F",  "undercurl"],
    \   "pythonBinNumber"                       : [ "Aquamarine2", "",  ""],
    \   "pythonBuiltin"                         : [ "#AE5555", "",  ""],
    \   "pythonBuiltinFunc"                     : [ "#48B091", "",  "bold"],
    \   "pythonBuiltinLogic"                    : [ "#729FCF", "",  ""],
    \   "pythonBuiltinObj"                      : [ "#009F6F","",""],
    \   "pythonCalOperator"                     : [ "#af5f00", "",  ""],
    \   "pythonClass"                           : [ "#A191F5",    "",  "italic"],
    \   "pythonClassDef"                        : [ "#2FBBA6",  "",  "bold,italic"],
    \   "pythonClassName"                       : [ "#2FBBA6",  "",  "italic"],
    \   "pythonCoding"                          : [ "SlateGray3", "",  "bold,italic"],
    \   "pythonComment"                         : [ "#557F8F", "",  ""],
    \   "pythonComparison"                      : [ "#2FBBA6", "",  "bold"],
    \   "pythonConditional"                     : [ "#2FBBA6", "",  ""],
    \   "pythonDecorator"                       : [ "#85B2FE", "", "italic"],
    \   "pythonDefaultAssignment"               : [ "#7FC090", "",  "bold"],
    \   "pythonDocstring"                       : [ "#5D8B9C", "",  "italic"],
    \   "pythonDocTest"                         : [ "#8B8B8B", "",  "italic"],
    \   "pythonDocTest2"                        : [ "#6D8C63", "",  "italic"],
    \   "pythonDottedName"                      : [ "#009F6F","",""],
    \   "pythonError"                           : [ "Tomato", "#1B5958",  ""],
    \   "pythonEscape"                          : [ "DodgerBlue2", "",  ""],
    \   "pythonEscapeError"                     : [ "Khaki2", "VioletRed4",  ""],
    \   "pythonException"                       : [ "#2FBBA6", "",  "italic"],
    \   "pythonExceptions"                      : [ "#2FBBA6", "",  ""],
    \   "pythonExClass"                         : [ "#2FBBA6", "",  "italic"],
    \   "pythonFloat"                           : [ "Aquamarine2", "",  "italic"],
    \   "pythonFunc"                            : [ "#A191F5", "",  "italic"],
    \   "pythonFuncDef"                         : [ "#85B2FE", "", "bold,italic"],
    \   "pythonFuncName"                        : [ "#85B2FE", "", "italic"],
    \   "pythonFuncParams"                      : [ "Red", "", ""],
    \   "pythonFunction"                        : [ "PaleGreen3","","bold"],
    \   "pythonHexError"                        : [ "Navy", "#5FD75F",  "undercurl"],
    \   "pythonHexNumber"                       : [ "Aquamarine2", "",  ""],
    \   "pythonInclude"                         : [ "#009F6F", "",  ""],
    \   "pythonIndentError"                     : [ "Khaki2", "#75252F",  ""],
    \   "pythonNumber"                          : [ "#85B2FE", "",  ""],
    \   "pythonObjFunction"                     : [ "#009F6F", "",  ""],
    \   "pythonOctError"                        : [ "Navy", "#5FD75F",  "undercurl"],
    \   "pythonOctNumber"                       : [ "Aquamarine2", "",  ""],
    \   "pythonOperator"                        : [ "#2FBBA6", "",  "bold"],
    \   "pythonParamDefault"                    : [ "SeaGreen2", "",  ""],
    \   "pythonParamName"                       : [ "#99AD6A", "",  "italic"],
    \   "pythonPreCondit"                       : [ "#00B780", "", ""],
    \   "pythonRawString"                       : [ "#7fa2e6", "",  "italic"],
    \   "pythonRepeat"                          : [ "#009F6F", "",  "bold,underline"],
    \   "pythonRun"                             : [ "SlateGray3", "",  "bold,italic"],
    \   "pythonSpaceError"                      : [ "LemonChiffon2","#1D3E3E",""],
    \   "pythonStatement"                       : [ "#2FBBA6", "",  ""],
    \   "pythonStrFormat"                       : [ "#8870FF", "",  ""],
    \   "pythonStrFormatting"                   : [ "#9FCBD0", "DarkSlateGrey", ""],
    \   "pythonString"                          : [ "#9A85FF", "",  ""],
    \   "pythonStrTemplate"                     : [ "PowderBlue", "DarkSlateGrey", "italic"],
    \   "pythonSuperclass"                      : [ "#99AD6A", "", "italic"],
    \   "pythonSync"                            : [ "#AE5555", "",  "italic"],
    \   "pythonTodo"                            : [ "Wheat2", "#345FA8",  "italic"],
    \   "pythonUniEscape"                       : [ "#CC4455", "",  ""],
    \   "pythonUniEscapeError"                  : [ "Khaki2", "VioletRed4",  ""],
    \   "pythonUniRawEscape"                    : [ "#CC4455", "",  ""],
    \   "pythonUniRawEscapeError"               : [ "Khaki2", "VioletRed4",  ""],
    \   "pythonUniRawString"                    : [ "#7fa2e6", "",  ""],
    \   "pythonUniString"                       : [ "#99ad6a", "",  ""],
            \ }

" Rst -- Restructured Text                          {{{2
let s:dict_hi_rst = {
    \   "rstCitation"                           : [ "#9A85FF", "", "italic"],
    \   "rstCitationReference"                  : [ "DarkSeaGreen3", "#1C3644", ""],
    \   "rstCodeBlock"                          : [ "#99ad6a", "",  "italic"],
    \   "rstComment"                            : [ "DodgerBlue2", "",  ""],
    \   "rstDelimiter"                          : [ "#2DB3A0", "", "bold"],
    \   "rstDirective"                          : [ "AquaMarine3", "", "italic"],
    \   "rstEmphasis"                           : [ "", "#3D2B6B", ""],
    \   "rstExDirective"                        : [ "#00B780", "", ""],
    \   "rstExplicitMarkup"                     : [ "Orange", "", "bold"],
    \   "rstFootNote"                           : [ "#9A85FF", "", "italic"],
    \   "rstHyperLinkReference"                 : [ "seagreen3", "",  ""],
    \   "rstInlineLiteral"                      : [ "#9A85FF", "",  "bold,italic"],
    \   "rstInterpretedTextOrHyperlinkReference": [ "#9A85FF", "#14332C", "italic"],
    \   "rstLiteralBlock"                       : [ "#2DB3A0", "",  ""],
    \   "rstSections"                           : [ "#A191F5", "",  "italic"],
    \   "rstSimpleTable"                        : [ "#c59f6f", "",  ""],
    \   "rstSimpleTableLines"                   : [ "#65C254", "",  ""],
    \   "rstStandaloneHyperlink"                : [ "CadetBlue2", "",  "underline"],
    \   "rstStrongEmphasis"                     : [ "DarkSlateGray2","#1E4959", "italic"],
    \   "rstSubstitutionReference"              : [ "#8870FF", "",  ""],
    \   "rstTable"                              : [ "#FF88AA", "#573D8C", ""],
    \   "rstTransition"                         : [ "#A191F5", "DarkSlateGray", ""],
            \ }

" Sed                                               {{{2
let s:dict_hi_sed = {
    \   "sedACI"                                : [ "Red","","bold"],
    \   "sedAddress"                            : [ "#D6B883", "", ""],
    \   "sedBranch"                             : [ "SlateGray3", "",  "bold,italic"],
    \   "sedError"                              : [ "Wheat2", "#345FA8",  ""],
    \   "sedFlag"                               : [ "#8fbfdc", "",  "bold,italic"],
    \   "sedFunction"                           : [ "PowderBlue","","italic"],
    \   "sedLabel"                              : [ "#D6B883", "", "italic,bold,underline"],
    \   "sedRegexp119"                          : [ "#CC4455", "",  ""],
    \   "sedRegExp47"                           : [ "AquaMarine3", "", ""],
    \   "sedRegexpMeta"                         : [ "#009F6F", "", ""],
    \   "sedReplacement119"                     : [ "#CC4455", "",  "bold"],
    \   "sedReplacement44"                      : [ "#65C254", "",  ""],
    \   "sedReplacement47"                      : [ "#85B2FE", "#1C3644", "italic"],
    \   "sedReplacement58"                      : [ "#65C254", "",  ""],
    \   "sedReplaceMeta"                        : [ "SlateGray2", "#1C3644",  "bold,italic"],
    \   "sedSemicolon"                          : [ "RosyBrown", "",  "bold"],
    \   "sedSpecial"                            : [ "SlateGray3", "", "bold"],
    \   "sedST"                                 : [ "SlateGray2","",""],
            \ }

" Shellscripts and Bash                             {{{2
let s:dict_hi_sh = {
    \   "bashStatement"                         : [ "#8870FF", "",  "italic"],
    \   "shAlias"                               : [ "#009F6F", "",  ""],
    \   "shArithmetic"                          : [ "SlateGray3", "",  ""],
    \   "shCase"                                : [ "PaleGreen3", "",  "italic"],
    \   "shCaseDoubleQuote"                     : [ "#A8C2EF", "DarkSlateGrey",  ""],
    \   "shCaseEsac"                            : [ "#009F6F", "",  "italic"],
    \   "shCaseRange"                           : [ "#8870FF", "",  ""],
    \   "shCmdParenRegion"                      : [ "DodgerBlue3", "",  "italic"],
    \   "shCmdSubregion"                        : [ "#8870FF", "",  "italic"],
    \   "shColon"                               : [ "AquaMarine3", "",  ""],
    \   "shCommandSub"                          : [ "#88B4CC", "",  "italic"],
    \   "shComment"                             : [ "#699DB0", "",  "italic"],
    \   "shConditional"                         : [ "Red3", "", "bold,italic"],
    \   "shDblBrace"                            : [ "#009F6F", "", "bold"],
    \   "shDblParen"                            : [ "#009F6F", "", "bold"],
    \   "shDerefOp"                             : [ "#2DB3A0", "",  ""],
    \   "shDeRefPattern"                        : [ "#2DB3A0", "",  ""],
    \   "shDeRefPPSleft"                        : [ "#99AD6A", "",  "italic"],
    \   "shDeRefPPSright"                       : [ "#99AD6A", "",  "italic"],
    \   "shDeRefSimple"                         : [ "AquaMarine3",    "", "italic"],
    \   "shDeRefVar"                            : [ "#9B91F6", "",  "italic"],
    \   "shDerefWordError"                      : [ "Wheat2", "#345FA8",  ""],
    \   "shDo"                                  : [ "#8FBFDC", "",  "italic"],
    \   "shDoubleQuote"                         : [ "#2DB3A0", "",  "italic"],
    \   "shFor"                                 : [ "Aquamarine3", "",  "italic"],
    \   "shFunction"                            : [ "#009F6F","", "bold"],
    \   "shFunctionKey"                         : [ "#009F6F","", "bold"],
    \   "shFunctionOne"                         : [ "#9CC7CC", "",  "italic"],
    \   "shFunctionTwo"                         : [ "SlateBlue2", "", ""],
    \   "shIf"                                  : [ "#9A85FF", "",  "bold,italic"],
    \   "shIfError"                             : [ "Wheat2", "#345FA8",  ""],
    \   "shLoop"                                : [ "#89AEB3", "",  "bold,italic"],
    \   "shNumber"                              : [ "#8870FF", "", ""],
    \   "shOperator"                            : [ "#C59F6F", "",  "italic"],
    \   "shOption"								: [ "#779DB2", "",   "bold"],
    \   "shParen"                               : [ "#009F6F","","bold,italic"],
    \   "shParenError"                          : [ "Red", "Gray35",  ""],
    \   "shQuote"                               : [ "#88B4CC", "",  "bold,italic"],
    \   "shRange"                               : [ "#81AAC0", "",  "bold,italic"],
    \   "shRedir"                               : [ "#C59F6F", "",  "bold"],
    \   "shRepeat"                              : [ "#9B91F6", "",  "bold,italic"],
    \   "shSet"                                 : [ "#009F6F", "",  "bold"],
    \   "shSetIdentifier"                       : [ "#009F6F", "",  "bold"],
    \   "shSetList"                             : [ "#2DB3A0", "",  ""],
    \   "shSingleQuote"							: [ "#9A85FF", "",  ""],
    \   "shSnglCase"                            : [ "Red", "",  ""],
    \   "shSource"                              : [ "PowderBlue", "",  "bold"],
    \   "shSpecial"								: [ "#2DB3A0", "",  "italic"],
    \   "shStatement"                           : [ "#2FBBA6", "",  "italic"],
    \   "shString"								: [ "#9A85FF", "",  ""],
    \   "shTestOpr"                             : [ "#C59F6F", "",  ""],
    \   "shTestPattern"                         : [ "#99ad6a", "", "bold"],
    \   "shTodo"                                : [ "Wheat2", "#345FA8",  "italic"],
    \   "shVariable"                            : [ "PaleGreen3", "", "italic"],
    \   }

" Tex and Postscript                                {{{2
let s:dict_hi_tex = {
    \   "postScrConditional"                    : [ "#009F6F", "", "bold"],
    \   "postScrConstant"                       : [ "#85B2FE", "",  ""],
    \   "postScrDSCcomment"                     : [ "#A08FF5", "",  ""],
    \   "postScrFloat"                          : [ "AquaMarine3", "",  ""],
    \   "postScrIdentifier"                     : [ "Aquamarine3", "",  ""],
    \   "postScrInteger"                        : [ "AquaMarine3", "",  ""],
    \   "postScrL2Operator"                     : [ "#85B2FE", "",  ""],
    \   "postScrOperator"                       : [ "#85B2FE", "",  ""],
    \   "postScrRepeat"                         : [ "#85B2FE", "",  ""],
    \   "texBegin"                              : [ "#009F6F","","bold"],
    \   "texBeginEndName"                       : [ "#009F6F","","bold"],
    \   "texComment"                            : [ "#78B37A", "",  "italic"],
    \   "texDelimiter"                          : [ "Red", "", ""],
    \   "texDocType"                            : [ "#00B780","","bold,italic"],
    \   "texDocZone"                            : [ "#85B2FE", "#1C3644", ""],
    \   "texEnd"                                : [ "#009F6F","","bold"],
    \   "texMathOper"                           : [ "DodgerBlue", "",  ""],
    \   "texMathZone"                           : [ "#8870FF", "",  "bold"],
    \   "texMathZoneV"                          : [ "DodgerBlue", "",  ""],
    \   "texMathZoneW"                          : [ "DodgerBlue", "",  ""],
    \   "texOnlyMath"                           : [ "PowderBlue", "",  ""],
    \   "texSection"                            : [ "#00B780","","italic"],
    \   "texSectionName"                        : [ "#BE00CC",  "", "bold"],
    \   "texSectionZone"                        : [ "PowderBlue", "", ""],
    \   "texSpecialChar"                        : [ "SlateGray2", "",  ""],
    \   "texStatement"                          : [ "#c59f6f", "",  "italic"],
    \   "texSubscripts"                         : [ "DodgerBlue", "",  ""],
    \   "texSuperscripts"                       : [ "DodgerBlue", "",  ""],
    \   "texTitle"                              : [ "PaleGreen2", "#254859", ""],
            \ }

" program transformation tools: TXL, Kelbt, Ragel, COLM etc.          {{{2
let s:dict_hi_pgtransform = {
    \   "cflTypeRegion"                         : [ "#779DB2", "",  "italic"],
    \   "defKeywords"                           : [ "#009F6F","","bold"],
    \   "regionDelimiter"                       : [ "Red", "",  ""],
    \   "rlLiteral"                             : [ "#9A85FF","","italic"],
    \   "rlNumber"                              : [ "#9A85FF","",""],
    \   "rlTypeRegion"                          : [ "SlateBlue1", "",  ""],
    \   "tlComment"                             : [ "#77996C", "",  ""],
    \   "tlIdentifier"                          : [ "#00B880", "",  ""],
    \   "txlComment"                            : [ "#66aa99", "",  "italic"],
    \   "txlFormat"                             : [ "#c59f6f", "",  ""],
    \   "txlKeyword"                            : [ "AquaMarine3", "",  ""],
    \   "txlLiteral"                            : [ "#8870FF","",  "bold"],
    \   "txlPreprocessor"                       : [ "PaleGreen3", "#1c3644", "italic"],
    \   "typeKeywords"                          : [ "#00B880","",""],
    \   "varCapture"                            : [ "#8fbfdc", "",  ""],
            \ }

" Vim Features: diff,folding,hex,quickfix etc.             {{{2
let s:dict_hi_vimfeat = {
    \   "diffDelete"                            : [ "#3D2D6D", "#1E4959",  ""],
    \   "diffFile"                              : [ "#990099", "",  "bold"],
    \   "diffLine"                              : [ "#880088", "",  "bold"],
    \   "diffNewFile"                           : [ "#770077", "",  "bold"],
    \   "iCursor"                               : [ "white", "red",  ""],
    \   "qfFileName"							: [ "Aquamarine2", "",  ""],
    \   "qfLineNr"								: [ "#5D8B9C", "",  ""],
    \   "qfSeparator"							: [ "RosyBrown", "",  ""],
    \   "xxdAddress"                            : [ "#09BA85", "", ""],
    \   "xxdAscii"                              : [ "#9B91F6", "",  ""],
    \   "xxdDot"                                : [ "SlateGray2", "",  "bold,underline"],
    \   "xxdSep"                                : [ "#009F6F","","bold"],
            \ }

" VimL -- Vim script, Vim Language                     {{{2
let s:dict_hi_vimlang = {
    \   "diffRemoved"                           : [ "PaleGoldenRod", "Black",  ""],
    \   "vimAddress"                            : [ "#9FC7FF", "",  ""],
    \   "vimAuGroup"                            : [ "SlateBlue2", "",  "bold"],
    \   "vimAugroupKey"                         : [ "SkyBlue2", "",  "italic,underline"],
    \   "vimAutoCmd"                            : [ "#32C5B0", "",  ""],
    \   "vimAutoCmdSfxList"                     : [ "#32C5B0", "",  ""],
    \   "vimAutoevent"                          : [ "#9A85FF", "",  ""],
    \   "vimAutoeventList"                      : [ "#32C5B0", "",  ""],
    \   "vimBracket"                            : [ "#7EB49C", "",  ""],
    \   "vimCmdSep"                             : [ "RosyBrown", "",  "bold"],
    \   "vimCmplxRepeat"                        : [ "#C6B6FE", "bg",  ""],
    \   "vimCommand"                            : [ "PowderBlue", "",  ""],
    \   "vimComment"                            : [ "#5D8B9C", "",  "italic"],
    \   "vimCommentString"                      : [ "#5D8B9C", "",  "italic"],
    \   "vimCommentTitle"                       : [ "#8B7F4C", "",  "italic"],
    \   "vimContinue"                           : [ "SlateBlue2", "",  "bold"],
    \   "vimCtrlChar"                           : [ "Green", "", ""],
    \   "vimEcho"                               : [ "PaleGreen3", "",  "bold"],
    \   "vimElseIferr"                          : [ "PowderBlue", "",  "underline"],
    \   "vimEnvVar"                             : [ "#85B2FE", "#1C3644", "italic"],
    \   "vimError"                              : [ "Tomato", "#1B5958",  ""],
    \   "vimExecute"                            : [ "SkyBlue", "", "italic"],
    \   "vimFBvar"                              : [ "SteelBlue2", "",  "italic"],
    \   "vimFgBgAttrib"                         : [ "DeepSkyBlue3", "", ""],
    \   "vimFiletype"                           : [ "#779DB2", "",   "italic"],
    \   "vimFirstChar"                          : [ "Orange", "",  ""],
    \   "vimFTOption"                           : [ "#779DB2", "",   "italic"],
    \   "vimFunc"                               : [ "White", "",   "bold"],
    \   "vimFuncBody"                           : [ "#779DB2", "",   "bold"],
    \   "vimFuncKey"                            : [ "PowderBlue", "#1C3644", ""],
    \   "vimFuncName"                           : [ "#2FBBA6", "", "underline,italic"],
    \   "vimFuncSID"                            : [ "SeaGreen3", "#1C4F4F", ""],
    \   "vimFunction"                           : [ "PaleGreen2","#1C4F4F", ""],
    \   "vimFuncVar"                            : [ "SteelBlue3", "",  "underline,italic"],
    \   "vimGroup"                              : [ "SeaGreen3", "#1C3644", ""],
    \   "vimGroupList"                          : [ "#7EB49C", "", "italic"],
    \   "vimGroupName"                          : [ "#7EB49C", "", ""],
    \   "vimGroupSpecial"                       : [ "#7EB49C", "", "italic"],
    \   "vimHiAttrib"							: [ "DeepSkyBlue3", "", ""],
    \   "vimHiClear"                            : [ "#A8C2EF",    "DarkSlateGrey", ""],
    \   "vimHiCterm"                            : [ "DeepSkyBlue3", "", ""],
    \   "vimHiCtermColor"                       : [ "SteelBlue1",   "DarkSlateGrey", ""],
    \   "vimHiCtermFgBg"                        : [ "DodgerBlue2", "",  ""],
    \   "vimHighLight"                          : [ "SeaGreen3", "#1C3644", ""],
    \   "vimHiGroup"                            : [ "SeaGreen3", "#1C3644", ""],
    \   "vimHiGui"                              : [ "DeepSkyBlue3", "", ""],
    \   "vimHiGuiFgBg"                          : [ "DodgerBlue2", "",  ""],
    \   "vimHiGuiRGB"                           : [ "SteelBlue1",    "DarkSlateGrey",  ""],
    \   "vimHiKeyList"                          : [ "#2DB3A0", "",  ""],
    \   "vimHiTerm"                             : [ "DeepSkyBlue3", "", ""],
    \   "vimLastChar"                           : [ "Orange", "",  ""],
    \   "vimLet"                                : [ "PowderBlue", "",  ""],
    \   "vimLineComment"                        : [ "#5D8B9C", "",  ""],
    \   "vimMap"                                : [ "LightCyan3", "",  ""],
    \   "vimMapLHS"                             : [ "SkyBlue2", "",  ""],
    \   "vimMapMod"                             : [ "#2DB3A0", "", ""],
    \   "vimMapModKey"                          : [ "#2DB3A0", "",  "italic"],
    \   "vimMark"                               : [ "#CC4455", "", "bold"],
    \   "vimMarker"                             : [ "Aquamarine1", "",  "bold"],
    \   "vimMenuLHS"                            : [ "SeaGreen4", "",  ""],
    \   "vimMenuName"                           : [ "#85B2FE", "",  ""],
    \   "vimMenuRHS"                            : [ "#85B2FE", "",  "italic"],
    \   "vimNormCmds"                           : [ "#85B2FE", "",  "italic"],
    \   "vimNotation"                           : [ "#7EB49C", "", ""],
    \   "vimNotFunc"                            : [ "PowderBlue", "",  ""],
    \   "vimNumber"                             : [ "#7fa2e6", "",  ""],
    \   "vimOper"                               : [ "#7fa2e6", "",  "bold"],
    \   "vimOperError"                          : [ "SteelBlue2", "",  ""],
    \   "vimOperParen"                          : [ "#7fa2e6", "",  ""],
    \   "vimOption"                             : [ "#AFAFFF", "#1C4F4F", "italic"],
    \   "vimParenSep"                           : [ "#779DB2", "",   "bold"],
    \   "vimPatOneOrMore"                       : [ "red", "",  ""],
    \   "vimPatRegionClose"                     : [ "#32C5B0", "",  "bold"],
    \   "vimPatRegionOpen"                      : [ "#32C5B0", "",  "bold"],
    \   "vimPatSep"                             : [ "#CC4455", "",  ""],
    \   "vimPatSepR"                            : [ "#CC4455", "",  ""],
    \   "vimPatSepZ"                            : [ "#CC4455", "",  ""],
    \   "vimPerlRegion"                         : [ "#C59F6F", "", "" ],
    \   "vimPythonRegion"                       : [ "#C59F6F", "", "" ],
    \   "vimRegister"                           : [ "#C6B6FE", "bg",  ""],
    \   "vimRubyRegion"                         : [ "#C59F6F", "", "" ],
    \   "vimScriptDelim"                        : [ "#76B286", "", "underline"],
    \   "vimSearch"                             : [ "#8B8B8B", "",  "italic"],
    \   "vimSearchDelim"                        : [ "#8B8B8B", "",  "italic"],
    \   "vimSep"                                : [ "SlateBlue2", "", ""],
    \   "vimSet"                                : [ "#85B2FE",    "#1C4F4F", ""],
    \   "vimSetEqual"                           : [ "#85B2FE",    "#1C4F4F", ""],
    \   "vimSetMod"                             : [ "#85B2FE",    "#1C4F4F", "italic"],
    \   "vimSetSep"                             : [ "#85B2FE",    "#1C4F4F", ""],
    \   "vimSpecFile"                           : [ "CornFlowerBlue", "",  "italic"],
    \   "vimSpecial"                            : [ "#7FA2E6", "",  ""],
    \   "vimSubst"                              : [ "DeepSkyBlue2", "",  ""],
    \   "vimSubst1"                             : [ "#93BBBF", "",  ""],
    \   "vimSubstDelim"                         : [ "RoyalBlue", "",  ""],
    \   "vimSubstFlagErr"                       : [ "Turquoise3", "",  ""],
    \   "vimSubstFlags"                         : [ "#009F6F","","bold,italic"],
    \   "vimSubstPat"                           : [ "PaleGreen3", "",  "bold"],
    \   "vimSubstRep4"                          : [ "SteelBlue2","","bold"],
    \   "vimSubstSubstr"                        : [ "SkyBlue3", "",  ""],
    \   "vimSynCase"                            : [ "#009F6F","","bold"],
    \   "vimSyncKey"                            : [ "#009F6F","",""],
    \   "vimSyncLines"                          : [ "#009F6F","",""],
    \   "vimSyncMatch"                          : [ "#90CFB3","",""],
    \   "vimSynContains"                        : [ "#009F6F","",""],
    \   "vimSynError"                           : [ "#2FBBA6", "", "italic,undercurl"],
    \   "vimSynKeyOpt"                          : [ "#8870FF","",""],
    \   "vimSynKeyRegion"                       : [ "SkyBlue2","",""],
    \   "vimSynMtchGrp"                         : [ "#009F6F","",""],
    \   "vimSynMtchOpt"                         : [ "#8870FF","",""],
    \   "vimSynNextGroup"                       : [ "#009F6F","","italic"],
    \   "vimSynOption"                          : [ "#009F6F","","italic"],
    \   "vimSynPatMod"                          : [ "#6B9999", "",  "underline"],
    \   "vimSynRegion"                          : [ "#8870FF","",""],
    \   "vimSynRegOpt"                          : [ "#8870FF","",""],
    \   "vimSynRegPat"                          : [ "#8870FF","",""],
    \   "vimSyntax"                             : [ "#009F6F","","bold"],
    \   "vimSynType"                            : [ "#009F6F","",""],
    \   "vimTodo"                               : [ "Wheat2", "#345FA8",  ""],
    \   "vimUserAttrbCmpltFunc"                 : [ "#7FA2E6", "",  "underline"],
    \   "vimUserAttrbKey"                       : [ "#32C5B0", "",  "italic"],
    \   "vimUserCmd"                            : [ "#CC4455", "", "bold"],
    \   "vimUserCmdError"                       : [ "PaleGreen3","#1C4F4F", ""],
    \   "vimUserFunc"                           : [ "#32C5B0", "", "italic"],
    \   "vimVar"                                : [ "#2FBBA6", "", "italic"],
            \ }

" Vim Plugins:  other plugins, having few customized highlights, come into this bucket {{{2
let s:dict_hi_other_plugins = {
    \   "dbgBreakPt"                            : [ "", "FireBrick",  ""],
    \   "dbgCurrent"                            : [ "Tomato", "#573d8c",  ""],
    \   "dosIniLabel"                           : [ "SlateGray3", "",  "bold"],
    \   "dosIniNumber"                          : [ "SlateGray3", "",  ""],
    \   "fountainBold"                          : [ "LightCyan3", "#573D8C", ""],
    \   "fountainCentered"                      : [ "#E7F56B", "#AD2728", ""  ],
    \   "fountainCharacter"                     : [ "#FF88AA", "#573D8C", "italic"],
    \   "fountainDialogue"                      : [ "#8ecfbe", "", "italic"],
    \   "fountainPageBreak"                     : [ "#556b2f", "", ""],
    \   "fountainParenthetical"                 : [ "#8B8B8B", "", ""],
    \   "fountainTitlePage"                     : [ "#bfaf69", "", "bold"],
    \   "fountainTransition"                    : [ "#BAB585", "#573D8C", ""],
    \   "indentGuidesEven"                      : [ "", "#3D2B6B", ""],
    \   "indentGuidesOdd"                       : [ "", "#1c3644", ""],
    \   "listmaps_filename"					    : [ "#CBD234", "#564227",  ""],
    \   "listmaps_underline"			    	: [ "#CBD234", "#564227",  ""],
    \   "neocomplcacheexpandsnippets"			: [ "PaleGoldenRod", "",  ""],
    \   "quickfixsignsMarksTexthl"              : [ "White", "#3A5022", ""],
    \   "snipKeyword"                           : [ "#2FBBA6", "",  ""],
    \   "snippetComment"                        : [ "SlateGray3", "",  "italic"],
    \   "snippetEval"                           : [ "PowderBlue",  "#1C3644",  "italic"],
    \   "snippetExpand"                         : [ "#779DB2", "",   "italic"],
    \   "snippetKeyword"                        : [ "#2FBBA6", "",  "underline"],
    \   "snippetName"                           : [ "#2FBBA6", "",  ""],
    \   "snippetWord"                           : [ "#78B37A", "", ""],
    \   "snipPythonCommand"                     : [ "#65C254", "",  ""],
    \   "snipStart"                             : [ "SeaGreen2", "",  ""],
    \   "snipString"                            : [ "#2FBBA6", "",  "italic"],
    \   "snipVar"                               : [ "DeepSkyBlue2", "",  ""],
    \   "snipVarExpansion"                      : [ "DeepSkyBlue1", "",  ""],
    \   "snipVarPythonCommand"                  : [ "Tomato", "",  ""],
    \   "tabLine"                               : [ "CornflowerBlue", "Gray26",  "italic"],
    \   "tabLineClose"                          : [ "CornflowerBlue",    "Gray26",           "bold"],
    \   "tabLineFill"                           : [ "CornflowerBlue", "Gray20",  "underline"],
    \   "tabLineNumber"                         : [ "#3CEEB3",    "Gray26",           "bold"],
    \   "tabLineSel"                            : [ "RoyalBlue", "bg",  "bold,italic"],
    \   "tabManHelp"                            : [ "#5D8B9C", "",  "italic"],
    \   "tabManHKey"                            : [ "LimeGreen", "", "italic"],
    \   "tabManHSpecial"                        : [ "RoyalBlue", "bg",  "italic"],
    \   "tabManTName"                           : [ "#CC4455", "",  ""],
    \   "tagListComment"                        : [ "#66aa99", "bg",  ""],
    \   "tagListFileName"                       : [ "SeaGreen3", "#473273", "bold,italic"],
    \   "tagListTagScope"                       : [ "#66aa99",  "",  ""],
    \   "tagListTitle"                          : [ "SeaGreen3",  "#1C3644",  "bold,italic"],
            \ }

" XML and DTD                                               {{{2
let s:dict_hi_xml = {
    \   "dtdFunction"                           : [ "SlateGray4", "",  "bold"],
    \   "dtdTag"                                : [ "#cda8c9", "",  "italic"],
    \   "xmlAttrib"                             : [ "#7EB49C", "", ""],
    \   "xmlCDATA"                              : [ "PaleGreen2", "DarkSlateGrey",  "bold,italic"],
    \   "xmlCDATAcdata"                         : [ "Khaki4", "DarkSlateGrey",  "italic"],
    \   "xmlCDATAend"                           : [ "Khaki4", "DarkSlateGrey",  "italic"],
    \   "xmlCDATAstart"                         : [ "Khaki4", "DarkSlateGrey",  "italic"],
    \   "xmlComment"                            : [ "#CC4455",      "",  "italic"],
    \   "xmlCommentPart"                        : [ "#6A6A6A", "",  "italic"],
    \   "xmlCommentStart"                       : [ "#CC4455",      "",  "italic"],
    \   "xmlDocType"                            : [ "#cda8c9", "",  "italic"],
    \   "xmlDocTypeDecl"                        : [ "SlateGray3", "",  ""],
    \   "xmlDocTypeKeyword"                     : [ "SlateGray3", "",  "italic"],
    \   "xmlEndTag"                             : [ "SlateGray4", "", "bold"],
    \   "xmlEntityPunct"                        : [ "#00B880","",""],
    \   "xmlEqual"                              : [ "#00B780","","bold"],
    \   "xmlNameSpace"                          : [ "#00B880","","italic"],
    \   "xmlProcessingDelim"                    : [ "#CC4455", "",  ""],
    \   "xmlString"                             : [ "#7C9DD4", "",  "italic"],
    \   "xmlTag"                                : [ "SlateGray3", "", ""],
    \   "xmlTagName"                            : [ "SlateGray3", "", ""],
    \   "xmlValue"                              : [ "Navy", "#BDCA51",  "italic"],
            \ }

" YAML                                              {{{2
let s:dict_hi_yaml = {
    \   "yamlAlias"                             : [ "#8870FF", "",  "italic,underline"],
    \   "yamlAnchor"                            : [ "#8870FF", "",  "italic"],
    \   "yamlBlockCollectionItemStart"          : [ "SeaGreen2", "",  "bold"],
    \   "yamlBlockMappingKey"                   : [ "#2DB3A0", "",  ""],
    \   "yamlDocumentStart"                     : [ "Red", "",  "bold"],
    \   "yamlFlowIndicator"                     : [ "SeaGreen2", "",  ""],
    \   "yamlFlowMappingKey"                    : [ "seagreen3", "",  ""],
    \   "yamlInteger"                           : [ "#8870FF", "",  ""],
    \   "yamlKeyValueDelimiter"                 : [ "RosyBrown", "",  "bold"],
    \   "yamlPlainScalar"                       : [ "SeaGreen2", "",  ""],
    \   "yamlTimestamp"                         : [ "#8870FF", "",  ""],
            \ }

" Manpages and nroff                                {{{2
let s:dict_hi_manpage = {
    \   "manLongOptionDesc"                     : [ "#DAD085", "Black",  ""],
    \   "manOptionDesc"                         : [ "#DAD085", "Black",  ""],
    \   "manReference"                          : [ "PaleGreen1", "",  "bold,underline"],
    \   "manSectionHeading"                     : [ "LimeGreen", "Black", "bold"],
    \   "manSubHeading"                         : [ "#7EB49C", "", "bold"],
    \   "manTitle"                              : [ "#93AAD1", "Black",  "underline"],
    \   "nroffEscape"							: [ "#00B880","","bold"],
    \   "nroffEscRegArg"						: [ "AquaMarine", "#880C0E",  "bold"],
    \   "nroffIdent"							: [ "SkyBlue3", "",  "underline"],
    \   "nroffRequest"							: [ "SeaGreen3", "",  "bold"],
    \   "nroffSpecialChar"						: [ "AquaMarine", "#880C0E",  ""],
    \   }

" Lua                                              {{{2
let s:dict_hi_lua = {
    \   "luaConstant"                           : [ "#85B2FE", "",  ""],
    \   "luaFunc"                               : [ "#009F6F", "", "bold,italic"],
    \   "luaFunction"                           : [ "#85B2FE", "", "bold"],
    \   "luaNumber"                             : [ "#85B2FE", "",  ""],
    \   "luaOperator"                           : [ "PaleGreen3","","bold,underline"],
    \   "luaParen"                              : [ "Red", "",  ""],
    \   "luaRepeat"                             : [ "SeaGreen2", "",  "underline"],
    \   "luaSpecial"                            : [ "AquaMarine4", "",  "bold"],
    \   "luaStatement"                          : [ "SeaGreen2", "",  ""],
    \   "luaString"                             : [ "#9A85FF", "",  ""],
    \   "luaTable"                              : [ "#00B880","","bold"],
    \   "luaTodo"                               : [ "Wheat2", "#345FA8",  "italic"],
    \   }

" Make, config and similar build tools                      {{{2
let s:dict_hi_build_tools = {
    \   "aapCommand"                            : [ "#65C254", "",  ""],
    \   "automakeClean"                         : [ "AquaMarine2", "", ""],
    \   "automakeComment1"                      : [ "#77996C", "",  "italic"],
    \   "automakeConditional"                   : [ "Aquamarine3","","bold,italic"],
    \   "automakeExtra"                         : [ "AquaMarine2", "", "italic"],
    \   "automakeMakeBString"                   : [ "#9A85FF","","italic"],
    \   "automakeSecondary"                     : [ "#009F6F","",""],
    \   "automakeSubDirs"                       : [ "#00B880","",""],
    \   "CfgComment"                            : [ "#7EB49C", "", "italic"],
    \   "CfgOnOff"                              : [ "Aquamarine3", "",  "bold"],
    \   "CfgSection"                            : [ "#7EB49C", "", "italic"],
    \   "CfgString"                             : [ "#65C254", "", "italic"],
    \   "CfgValues"                             : [ "SkyBlue1", "",  ""],
    \   "confComment"                           : [ "#66aa99", "",  "italic"],
    \   "configFunction"                        : [ "#65C254", "",  ""],
    \   "configString"                          : [ "#9A85FF", "",  ""],
    \   "confTodo"                              : [ "Wheat2", "#345FA8",  "italic"],
    \   "m4Command"                             : [ "#009F6F", "",  ""],
    \   "m4Comment"                             : [ "#557F8F", "",  ""],
    \   "m4Function"                            : [ "#65C254", "",  ""],
    \   "m4Preproc"                             : [ "SeaGreen3",  "#1C3644",  ""],
    \   "m4Special"                             : [ "#65C254", "",  "bold"],
    \   "m4Statement"                           : [ "PaleGreen1", "",  ""],
    \   "m4String"                              : [ "#9A85FF","","italic"],
    \   "m4Type"                                : [ "Aquamarine2", "",  "bold"],
    \   "m4Variable"                            : [ "", "#3D2B6B", ""],
    \   "makeBstring"                           : [ "Turquoise3", "",  ""],
    \   "makeCommandError"                      : [ "#8870FF", "",  "bold"],
    \   "makeComment"                           : [ "#77996C", "",  "italic"],
    \   "makeConfig"                            : [ "#7FA2E6", "",  ""],
    \   "makeDstring"                           : [ "#9A85FF", "",  ""],
    \   "makeIdent"                             : [ "Aquamarine3", "",  ""],
    \   "makePreCondit"                         : [ "#8870FF", "",  "italic"],
    \   "makeSpecial"                           : [ "#CC4455", "",  ""],
    \   "makeSString"                           : [ "#9A85FF", "",  "italic"],
    \   "makeTarget"                            : [ "#00B880","","underline"],
    \ }

" PHP                                              {{{2
let s:dict_hi_php = {
    \   "phpArrayPair"                          : [ "#2DB3A0", "",  "italic"],
    \   "phpBoolean"                            : [ "MediumSlateBlue","",""],
    \   "phpFunctions"                          : [ "#85B2FE", "#1C3644", ""],
    \   "phpNull"                               : [ "MediumSlateBlue","",""],
    \   "phpQuoteDouble"                        : [ "#8CA854", "",  ""],
    \   "phpQuoteSingle"                        : [ "#8CA854", "",  ""],
    \   "phpSuperGlobal"                        : [ "#2DB3A0", "",  "bold,italic"],
    \ }

" Other - highlights dict for a mix of syntax files {{{2
let s:dict_hi_other = {
    \   "adaAssignment"                         : [ "Red", "",  ""],
    \   "adaAttribute"                          : [ "DodgerBlue3", "",  "italic"],
    \   "adaSpecial"                            : [ "RosyBrown", "",  "bold"],
    \   "Assignment"                            : [ "#F3DB8E", "",  ""],
    \   "Boolean"                               : [ "#88AEB2", "",  ""],
    \   "builtinFunc"                           : [ "#dad085", "",  "underline"],
    \   "builtinObj"                            : [ "#7F9D90", "", "" ],
    \   "calOperator"                           : [ "#af5f00", "",  ""],
    \   "Character"                             : [ "CadetBlue2", "",  ""],
    \   "cobolLine"                             : [ "DodgerBlue2", "",  ""],
    \   "cobolString"                           : [ "#66aa99", "", "italic"],
    \   "Comment"                               : [ "#8B8B8B", "",  "italic"],
    \   "Conditional"                           : [ "SeaGreen2", "",  ""],
    \   "Constant"                              : [ "CadetBlue2", "",  ""],
    \   "Cursor"                                : [ "#8700ff", "orange",  "italic,bold"],
    \   "cursorIM"                              : [ "Black", "OrangeRed",  ""],
    \   "Debug"                                 : [ "#88CB35", "",  ""],
    \   "Decorator"                             : [ "#57d700", "",  ""],
    \   "Define"                                : [ "DodgerBlue2", "",  ""],
    \   "Definition"                            : [ "#f8ed97", "",  ""],
    \   "Delimiter"                             : [ "#779DB2", "",  "bold"],
    \   "Directory"                             : [ "DarkOliveGreen2", "",  "bold"],
    \   "Entity"                                : [ "#F4E891", "CadetBlue4",  ""],
    \   "Error"                                 : [ "Tomato", "#1B5958",  ""],
    \   "errorMsg"                              : [ "LightGoldenRod", "Firebrick",  ""],
    \   "Exception"                             : [ "SeaGreen2", "",  ""],
    \   "Float"                                 : [ "Aquamarine2", "",  ""],
    \   "Function"                              : [ "Turquoise3", "",  ""],
    \   "Identifier"                            : [ "#009F6F", "",  "italic"],
    \   "Ignore"                                : [ "Gray24", "",  ""],
    \   "Import"                                : [ "#cda869", "",  ""],
    \   "Include"                               : [ "DodgerBlue2", "",  ""],
    \   "incSearch"                             : [ "Firebrick1", "",  "bold"],
    \   "Keyword"                               : [ "SeaGreen2", "",  ""],
    \   "Label"                                 : [ "#009F6F", "", ""],
    \   "Macro"                                 : [ "DodgerBlue2", "",  ""],
    \   "matchParen"                            : [ "GoldenRod", "DarkCyan",  "bold"],
    \   "modeMsg"                               : [ "OliveDrab4", "",  ""],
    \   "moreMsg"                               : [ "Navy", "#C59F6F", ""],
    \   "nonText"                               : [ "#0F450F", "",  ""],
    \   "Number"                                : [ "Aquamarine2", "",  ""],
    \   "Operator"                              : [ "SpringGreen2", "", ""],
    \   "paramName"                             : [ "#5f87d7", "",  ""],
    \   "plibuiltin"                            : [ "steelblue2", "", ""],
    \   "plidelimiter"                          : [ "red", "", ""],
    \   "pMenu"                                 : [ "BurlyWood1", "Gray30",  ""],
    \   "pMenuSbar"                             : [ "LightSeaGreen", "Gray20",  ""],
    \   "pMenuSel"                              : [ "Red", "Black",  "bold"],
    \   "pMenuThumb"                            : [ "Turquoise", "Gray10",  ""],
    \   "preciseJumpTarget"                     : [ "#8700ff", "orange",  ""],
    \   "preCondit"                             : [ "DodgerBlue2", "",  ""],
    \   "preProc"                               : [ "#A191F5", "",  ""],
    \   "Question"                              : [ "#65C254", "",  ""],
    \   "rcInclude"                             : [ "#65C254", "",  ""],
    \   "rcString"                              : [ "#7fa2e6", "",  "italic"],
    \   "Repeat"                                : [ "SeaGreen2", "",  ""],
    \   "rexxLineContinue"                      : [ "#65C254", "",  ""],
    \   "sasStatement"                          : [ "#009F6F", "", ""],
    \   "signColor"                             : [ "#C59F6F", "bg", "" ],
    \   "signColumn"                            : [ "PaleGoldenrod", "#0e2628",  ""],
    \   "specialChar"                           : [ "#88CB35", "",  ""],
    \   "specialKey"                            : [ "#869BCC", "",  "italic"],
    \   "Statement"                             : [ "#009F6F", "", ""],
    \   "storageClass"                          : [ "#c59f6f", "",  ""],
    \   "String"                                : [ "#99ad6a", "",  ""],
    \   "stringDelimiter"                       : [ "#8CA854", "",  ""],
    \   "Structure"                             : [ "#8fbfdc", "",  ""],
    \   "superclass"                            : [ "#6A84AD", "#FFD1FA",  "reverse"],
    \   "Tag"                                   : [ "#88CB35", "",  ""],
    \   "Test"                                  : [ "#88AEB2", "",  "italic"],
    \   "Title"                                 : [ "#009F6F", "", "bold,italic"],
    \   "Todo"                                  : [ "Wheat2", "Maroon4",  ""],
    \   "Type"                                  : [ "DeepSkyBlue2", "",  ""],
    \   "Typedef"                               : [ "DeepSkyBlue2", "",  ""],
    \   "Underlined"                            : [ "SkyBlue2", "",  "underline"],
    \   "UtlTag"                                : [ "RoyalBlue", "",  "italic"],
    \   "UtlURL"                                : [ "#8870FF",  "",  "underline"],
    \   "vertSplit"                             : [ "#71D3B4", "#1E3B31",  "bold"],
    \   "Visual"                                : [ "Navy", "DarkSeaGreen3", "bold"],
    \   "visualNOS"                             : [ "SlateGray3", "",  "bold,underline"],
    \   "warningMsg"                            : [ "Gold", "",  ""],
    \   "wildMenu"                              : [ "Black", "LimeGreen",  "bold"],
    \ }

" Call ParseAllSyntaxes To Set All Highlights:  {{{1
let s:lst_dict_hi = [
        \  s:dict_hi_asciidoc,
		\  s:dict_hi_awk,
		\  s:dict_hi_plugin_bufX,
		\  s:dict_hi_c_cpp,
		\  s:dict_hi_css,
		\  s:dict_hi_desktop,
		\  s:dict_hi_unixtools,
		\  s:dict_hi_haskell,
		\  s:dict_hi_ruby,
		\  s:dict_hi_vimhelp,
		\  s:dict_hi_html,
		\  s:dict_hi_javatools,
		\  s:dict_hi_jscript,
		\  s:dict_hi_lisp,
		\  s:dict_hi_markdown,
		\  s:dict_hi_rdf_and_graphs,
		\  s:dict_hi_nerds,
		\  s:dict_hi_ocaml,
		\  s:dict_hi_perl,
		\  s:dict_hi_sql,
		\  s:dict_hi_python,
		\  s:dict_hi_rst,
		\  s:dict_hi_sed,
		\  s:dict_hi_sh,
		\  s:dict_hi_tex,
		\  s:dict_hi_pgtransform,
		\  s:dict_hi_vimfeat,
		\  s:dict_hi_vimlang,
		\  s:dict_hi_other_plugins,
		\  s:dict_hi_xml,
		\  s:dict_hi_yaml,
		\  s:dict_hi_manpage,
		\  s:dict_hi_lua,
		\  s:dict_hi_build_tools,
		\  s:dict_hi_php,
		\  s:dict_hi_other,
    \ ]
call s:ParseAllSyntaxes(s:lst_dict_hi)
"

" Statusline:   {{{1
if s:dict_conf_options.statusline[0]
    highlight StatusLine   guifg=LemonChiffon2 guibg=#334680        gui=bold
    highlight StatusLineNC guifg=#A8C2EF       guibg=DarkSlateGrey  gui=NONE
endif
"
" Undercurl: a few colors are set here, outside of the color dictionary  {{{1
highlight SpellCap             guifg=fg         guibg=bg      gui=undercurl      guisp=#CCFFCC
highlight SpellBad             guifg=fg         guibg=bg      gui=undercurl      guisp=Yellow
highlight SpellLocal           guifg=fg         guibg=bg      gui=undercurl      guisp=fg
highlight SpellRare            guifg=fg         guibg=bg      gui=undercurl      guisp=#C59F6F
highlight netrwList            guifg=AquaMarine guibg=#880C0E gui=bold,undercurl guisp=SkyBlue2
highlight fountainSceneHeading guifg=#D6B883    guibg=Grey40  gui=undercurl      guisp=SeaShell3
"
" Default highlights follow the non-default ones, below {{{1
" Search Color: selection logic per global parameter briofita_choice_for_search {{{2
" ------------------   SEARCH COLOR ------------------------------------------
if (s:dict_conf_options.search[0]==1)
    highlight DiffText    gui=NONE      guifg=BurlyWood1     guibg=#902E3A
    highlight diffChange  gui=NONE	    guifg=DarkSlateGray2 guibg=#25453D
    highlight diffAdd     gui=NONE      guifg=#CC4455        guibg=Black
    highlight Search      gui=underline guifg=#E7F56B        guibg=#AD2728
elseif (s:dict_conf_options.search[0]==2)
    highlight DiffText    gui=bold,underline guifg=DarkBlue guibg=SlateGray3
    highlight diffChange  gui=underline	guifg=#88CB35 guibg=#1E4959
    highlight diffAdd     gui=underline guifg=#88CB35 guibg=#1E4959
    highlight Search      gui=underline guifg=#FF88AA guibg=bg
elseif (s:dict_conf_options.search[0]==3)
    highlight DiffText    gui=underline guifg=DarkSlateGrey guibg=khaki2
    highlight diffChange  gui=NONE		guifg=#88CB35       guibg=#1E4959
    highlight diffAdd     gui=NONE      guifg=#88CB35       guibg=#1E4959
    highlight Search      gui=bold      guifg=FireBrick1    guibg=bg
elseif (s:dict_conf_options.search[0]==4)
    highlight DiffText    gui=undercurl guifg=Black   guibg=LimeGreen
    highlight diffChange  gui=NONE      guifg=#CC4455 guibg=#1E4959
    highlight diffAdd     gui=NONE      guifg=#CC4455 guibg=#1E4959
    highlight Search      gui=underline guifg=#556B2F guibg=#E7F56B
elseif (s:dict_conf_options.search[0]==5)
    highlight DiffText    gui=NONE      guifg=Wheat3         guibg=#AD2728
    highlight diffChange  gui=NONE	    guifg=DarkSlateGray2 guibg=#25453D
    highlight diffAdd     gui=NONE      guifg=#CC4455        guibg=Black
    highlight Search      gui=underline guifg=#E7F56B        guibg=#E22A37
else " if extraneous value is detected, it is changed to default (zero)
    let s:dict_conf_options.search[0]=0   " make it easier to create a rotation scheme
endif
if (s:dict_conf_options.search[0]==0) " DEFAULT
    highlight DiffText    gui=NONE      guifg=Black   guibg=Bisque2
    highlight diffChange  gui=underline guifg=#C59F6F guibg=#1E4959
    highlight diffAdd     gui=NONE      guifg=#88CB35 guibg=#1E4959
    highlight Search      gui=underline guifg=#FF88AA guibg=bg
endif
highlight! link diffChanged diffChange
highlight! link diffAdded   diffAdd
"
" Normal Color: selection logic per global parm for normal color  {{{2
" ------------------   NORMAL COLOR ------------------------------------------
if (s:dict_conf_options.normal[0]==1)
    highlight Normal        guifg=#C6B6FE     guibg=#062926 gui=NONE
elseif (s:dict_conf_options.normal[0]==2)
    highlight Normal       guifg=#D6B883        guibg=#062926 gui=NONE
elseif (s:dict_conf_options.normal[0]==3)
    highlight Normal       guifg=#D6B883        guibg=#062926 gui=NONE
elseif (s:dict_conf_options.normal[0]==4)
    highlight Normal       guifg=#D6B883      guibg=#062926 gui=NONE
else
    let s:dict_conf_options.normal[0]=0 " make it easier to create a rotation scheme
endif
if (s:dict_conf_options.normal[0]==0)
    " DEFAULT normal foreground
    highlight Normal       guifg=PowderBlue    guibg=#062926 gui=NONE
endif

" conceal
if (s:dict_conf_options.conceal[0] > s:dict_conf_options.conceal[1])
    let s:dict_conf_options.conceal[0] = 0
endif
let lstconceal = s:lst_hi_conceal[s:dict_conf_options.conceal[0]]
execute 'highlight Conceal  guifg='
     \  . lstconceal[0] . ' guibg='
     \  . lstconceal[1] . ' gui=bold'

" special
if (s:dict_conf_options.special[0] > s:dict_conf_options.special[1])
    let s:dict_conf_options.special[0] = 0
endif
let lstspecial = s:lst_hi_specialopt[s:dict_conf_options.special[0]]
execute 'highlight Special  guifg='
     \  . lstspecial[0] . ' guibg='
     \  . lstspecial[1] . ' gui=NONE'

" vimgroup -- hand chosen for just a few highlights
if (s:dict_conf_options.vimgroup[0] > s:dict_conf_options.vimgroup[1])
    let s:dict_conf_options.vimgroup[0] = 0
endif
if s:dict_conf_options.vimgroup[0] == 0
    highlight vimString    guifg=#9A85FF       guibg=NONE    gui=NONE
    highlight vimMapRHS    guifg=LightCyan3    guibg=NONE    gui=NONE
    highlight vimIsCommand guifg=SkyBlue2      guibg=NONE    gui=italic
elseif s:dict_conf_options.vimgroup[0] == 1
    highlight vimString     guifg=#9A85FF     guibg=NONE    gui=NONE
    highlight vimMapRHS     guifg=#CC4455     guibg=NONE    gui=NONE
    highlight vimIsCommand  guifg=SkyBlue2    guibg=NONE    gui=italic
elseif s:dict_conf_options.vimgroup[0] == 2
    highlight vimString    guifg=CadetBlue3     guibg=NONE    gui=NONE
    highlight vimMapRHS    guifg=LightCyan3     guibg=NONE    gui=NONE
    highlight vimIsCommand guifg=#32C5B0        guibg=NONE    gui=italic
elseif s:dict_conf_options.vimgroup[0] == 3
    highlight vimString    guifg=#8870FF        guibg=NONE    gui=NONE
    highlight vimMapRHS    guifg=LightCyan3     guibg=NONE    gui=NONE
    highlight vimIsCommand guifg=SkyBlue2       guibg=NONE    gui=italic
elseif s:dict_conf_options.vimgroup[0] == 4
    highlight vimString    guifg=CadetBlue3   guibg=NONE    gui=NONE
    highlight vimMapRHS    guifg=#CC4455      guibg=NONE    gui=NONE
    highlight vimIsCommand guifg=#32C5B0      guibg=NONE    gui=italic
endif

highlight! link javaString    vimString
highlight! link vimFilter     vimIsCommand
highlight! link vimEchoHLNone vimIsCommand
"
" LineNr And CursorLineNr: selection logic per global parm for cursor line number  {{{2
" ------------------   CURSOR LINE NR COLOR ----------------------------------
if s:dict_conf_options.cursorlinenr[0]==1
    highlight lineNr       guifg=DarkSeaGreen4 guibg=#0C2628 gui=NONE
    highlight CursorLineNr guifg=Yellow        guibg=bg      gui=bold
elseif s:dict_conf_options.cursorlinenr[0]==2
    highlight lineNr       guifg=#7586AA guibg=#0C2628 gui=NONE
    highlight CursorLineNr guifg=Orange  guibg=bg      gui=bold
elseif s:dict_conf_options.cursorlinenr[0]==3
    highlight lineNr       guifg=#7586AA guibg=#0C2628 gui=NONE
    highlight CursorLineNr guifg=Yellow  guibg=bg      gui=bold
else " change to default zero
    let s:dict_conf_options.cursorlinenr[0]=0 " make it easier to create a rotation scheme
endif
if s:dict_conf_options.cursorlinenr[0]==0 " DEFAULT; orange
    highlight lineNr       guifg=DarkSeaGreen4 guibg=#0C2628 gui=NONE
    highlight CursorLineNr guifg=Orange        guibg=bg      gui=bold
endif
"
" CursorLine And Cursorcolumn Auxiliary Function:              {{{2
if !exists ("*s:DefineCulCuc")
	function! s:DefineCulCuc(cul1)
		let hiindexed = s:dict_hi_cul[a:cul1]
		if (a:cul1 >= 1) &&
		 \ (a:cul1 <= 5)
			execute 'let thecolor = "' . hiindexed . '"'
			execute "highlight CursorLine   gui=bold guifg=NONE guibg=" . thecolor
			execute "highlight CursorColumn gui=NONE guifg=NONE guibg=" . thecolor
			return a:cul1
		elseif (a:cul1 == 6) || (a:cul1 == 7)
			execute 'let thecolor = "' . hiindexed . '"'
			execute "highlight CursorLine   gui=bold guifg=white guibg=" . thecolor
			execute "highlight CursorColumn gui=NONE guifg=NONE  guibg=" . thecolor
			return a:cul1
		elseif (a:cul1 == 8)
			execute 'let thecolor = "' . hiindexed . '"'
			execute "highlight CursorLine   gui=underline guifg=green guibg=" . thecolor
			execute "highlight CursorColumn gui=NONE      guifg=NONE  guibg=" . thecolor
			return a:cul1
		else " default: highlights will be set by the caller
			return 0
		endif
	endfunction
endif

" CursorLine And Cursorcolumn: selection logic                     {{{2
" ------------------   CURSOR LINE + CURSOR COLUMN COLORS -----------------------------
if (exists("t:briofita_choice_for_cursorline"))
	" tab local settings prevails
	let s:cul = s:DefineCulCuc(t:briofita_choice_for_cursorline)
	let t:briofita_choice_for_cursorline = s:cul
else
	let s:cul = s:DefineCulCuc(s:dict_conf_options.cursorline[0])
	let s:dict_conf_options.cursorline[0] = s:cul
endif
if (s:cul == 0) " DEFAULT
    execute 'let thecolor = "' . s:dict_hi_cul[0] . '"'
    execute "highlight CursorLine   gui=bold guifg=NONE guibg=" . thecolor
    execute "highlight CursorColumn gui=NONE guifg=NONE guibg=" . thecolor
endif
"
" ColorColumn Color: selection logic per global parm for color column     {{{2
" ------------------   COLOR COLUMN COLOR -------------------------------------
if s:dict_conf_options.colorcolumn[0] != 3
    if s:dict_conf_options.colorcolumn[0]==1
         if (s:cul >= 0) && (s:cul <= 7)
            execute 'let thecolor = "' . s:dict_hi_cul[s:cul] . '"'
            execute "highlight ColorColumn gui=NONE guifg=NONE  guibg=".thecolor
         else
            highlight ColorColumn   gui=NONE guifg=NONE guibg=bg
         endif
    elseif s:dict_conf_options.colorcolumn[0]==2
         highlight ColorColumn gui=NONE guifg=NONE guibg=#004F4F
    else " back to default zero
        let s:dict_conf_options.colorcolumn[0]=0 " make it easier to create a rotation scheme
    endif
endif
if s:dict_conf_options.colorcolumn[0]==0 " DEFAULT
     highlight ColorColumn gui=NONE guifg=PaleGreen2 guibg=#294C44
endif

" No Distraction Mode: tab-parameter variable is tested here             {{{2
if s:dict_conf_options.nodistractionmode[0]
    if exists("t:briofita_nodistractionmode")
        call s:BriofitaNoDistraction(t:briofita_nodistractionmode)
    endif
endif

if s:dict_conf_options.folded[0]==1
    highlight Folded guifg=PaleGreen2 guibg=DarkSlateGray gui=italic
elseif s:dict_conf_options.folded[0]==2
    highlight Folded guifg=YellowGreen guibg=DarkSlateGray gui=italic
elseif s:dict_conf_options.folded[0]==3
    highlight Folded guifg=DarkSeaGreen3 guibg=DarkSlateGray gui=italic
elseif s:dict_conf_options.folded[0]==4
    highlight Folded guifg=DarkOliveGreen3 guibg=DarkSlateGray gui=italic
else " change to default zero
    let s:dict_conf_options.folded[0]=0
endif
if s:dict_conf_options.folded[0]==0 " DEFAULT -- from Moss
    highlight Folded guifg=LightSeaGreen guibg=DarkSlateGray gui=italic
endif

if s:dict_conf_options.foldcolumn[0]==1
   highlight FoldColumn guifg=#15736D     guibg=#082926 gui=bold
elseif s:dict_conf_options.foldcolumn[0]==2
   highlight FoldColumn guifg=#1A8C85     guibg=#082926 gui=bold
elseif s:dict_conf_options.foldcolumn[0]==3
   highlight FoldColumn guifg=#178079     guibg=#082926 gui=bold
elseif s:dict_conf_options.foldcolumn[0]==4
   highlight FoldColumn guifg=DodgerBlue3 guibg=#082926 gui=bold
else " change to default zero
    let s:dict_conf_options.foldcolumn[0]=0
endif
if s:dict_conf_options.foldcolumn[0]==0
   highlight FoldColumn guifg=ForestGreen guibg=#082926 gui=bold
endif

if exists ("*s:ColorDictParser")
 delfunction s:ColorDictParser
 delfunction s:DefineCulCuc
endif

let &cpo = save_cpo


" ICursor: forced here to avoid a noxious hidden cursor I sometimes get with other colorschemes  {{{1
set guicursor+=i-ci:ver30-iCursor-blinkwait300-blinkon200-blinkoff150

"----------------------------------------------------------------------------
"
" Modeline:    {{{1
"
" vim: et:ts=4:sw=4:fdm=marker:fdl=0:ft=vim:
