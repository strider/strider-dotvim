" ----------------------------------------------------------------------------
"   Plugin:    briofita-support
"   Author:    Sergio O. Nobre
"   Date:      May 14, 2013
"   Version:   2.0.2
"   Purpose:   Interface for the use and customization of the Briofita colorscheme.
"              This plugin makes it easier for the user to make
"              a rotation scheme ("cycle") with the colorscheme options.
"   Note:      This plugin serves as an example of how the user's plugins,
"              maps or menus may customize Briofita's behavior.
"              Although other options are supported, the plugin was tested
"              only for the cycling of the cursorline/cursorcolumn option.
"              This is an early
"   Copyright: Copyright (C) 2013 Sergio O. Nobre
"   Licence:   The same as Vim licence.
" ----------------------------------------------------------------------------

" check whether this script is already loaded
if exists("g:briofita_support_version")
    finish
endif

let g:briofita_support_version = "2.0.2"

let s:briofita_root_menu = 'Plugin.Briofita\ Colorscheme\ Support.'

" function!   g:BriofitaVersion()   " {{{1
if !exists ("*g:BriofitaVersion")
    function! g:BriofitaVersion()
        " this function returns an string with Briofita version # and other information.
        " USAGE: echo g:BriofitaVersion(), or echomsg g:BriofitaVersion()
        if exists('g:briofitaversion')
            let s:briofitainfo  = "'Briofita v" . g:briofitaversion
        else
            let s:briofitainfo  = "'Briofita colorscheme is not loaded.'"
            return(s:briofitainfo)
        endif
        if !exists('g:colors_name')
            let s:briofitainfo .= "'"
            return(s:briofitainfo)
        endif
        let t:briofitainitialtabcolor = "(unknown color)"
        try
            if exists('t:colorscheme')
                let t:briofitainitialtabcolor = t:colorscheme
            else
                if exists('g:colors_name')
                    let t:briofitainitialtabcolor = g:colors_name
                endif
            endif
        catch
            let t:briofitainitialtabcolor = "(undefined color?)"
        endtry
        let s:briofitafirst = 0
        if g:colors_name =~ "briofita"
            let s:briofitafirst = 1
        elseif exists('t:colorscheme')
            if t:colorscheme =~ "briofita"
                let s:briofitafirst = 2
            endif
        endif
        if !s:briofitafirst
            if (tabpagenr("$") == 1)
                let s:briofitainfo .= " -- non-Briofita color currently loaded="
            else
                let s:briofitainfo .= " -- current tab (".tabpagenr().") has non-Briofita color="
            endif
            let s:briofitainfo .= t:briofitainitialtabcolor
            let s:briofitainfo .= "'"
            " Briofita is not the current colorscheme: just return name and version
            return(s:briofitainfo)
        endif

        let s:briofitainfo .= " Curr.Settings{"

        if g:briofita_parms.colorcolumn[0] == 3
            " NOTE: 3 means distractionless editing
            let s:briofitainfo .= " *NoDistractionMode* "
        else
            let s:briofitainfo .= " *ColorColumn[0-"
                         \      . g:briofita_parms.colorcolumn[1] .  "]="
                         \      . g:briofita_parms.colorcolumn[0]
            if g:briofita_parms.colorcolumn[0] == 1
                let s:briofitainfo .= " (cc will use cul color) "
            endif
            let s:briofitainfo .= " *CursorLine[0-"
                         \      . g:briofita_parms.cursorline[1] .  "]="
                         \      . g:briofita_parms.cursorline[0]
            if exists("t:briofita_choice_for_cursorline")
                let s:briofitainfo .= " CurTab(CursorLine)="
                             \ . t:briofita_choice_for_cursorline
            endif
        endif

        let s:briofitainfo .= " *CursorLineNr[0-"
                         \      . g:briofita_parms.cursorlinenr[1] .  "]="
                         \      . g:briofita_parms.cursorlinenr[0]

        let s:briofitainfo .= " *Normal[0-"
                         \      . g:briofita_parms.normal[1] .  "]="
                         \      . g:briofita_parms.normal[0]

        let s:briofitainfo .= " *Search[0-"
                         \      . g:briofita_parms.search[1] .  "]="
                         \      . g:briofita_parms.search[0]

        let s:briofitainfo .= " *Folded[0-"
                         \      . g:briofita_parms.folded[1] .  "]="
                         \      . g:briofita_parms.folded[0]

        let s:briofitainfo .= " }"

        let t:briofitanumtabs = tabpagenr("$")
        if (t:briofitanumtabs == 1)
            let s:briofitainfo .= " -- curr.color=" . t:briofitainitialtabcolor
            let s:briofitainfo .= "'"
        endif
        let s:briofitainfo .= "'"
        unlet! s:briofitafirst
        return(s:briofitainfo)
        " end of function BriofitaVersion()
    endfunction
endif

function! g:BriofitaParmSet(strKey, strValue)    " {{{1
    " sets one briofita interface parameter (a key within the g:briofita_parms dictionary)
    if !exists("g:briofita_parms")
        let cmd = "let g:briofita_parms = { '" .
                    \  a:strKey . "': " .
                    \  a:strValue . ' }'
        execute cmd
        return
    endif
    let l:allowedkeys = g:briofita_allowed_parms
    let l:ixk = index(l:allowedkeys, a:strKey)
    if l:ixk >= 0
        if has_key(g:briofita_parms,a:strKey)
            let cmd = "let g:briofita_parms." .
                \    a:strKey . " = " .
                \    a:strValue
            execute cmd
        else
            let cmd = "let g:briofita_parms['" .
                \    a:strKey . "'] = " .
                \    a:strValue
            execute cmd
        endif
    endif
    if     (a:strKey == 'localcursorline') && (a:strValue == 0)
        unlet! t:briofita_choice_for_cursorline
    endif
    if (a:strKey == 'cursorline')
       if has_key(g:briofita_parms,'localcursorline')
            if g:briofita_parms.localcursorline
                let t:briofita_choice_for_cursorline = a:strValue
            endif
        endif
    endif
endfunction

function! g:BriofitaGlobal(highlight,startpoint)    " {{{1
    if exists("t:briofita_choice_for_cursorline")
        unlet! t:briofita_choice_for_cursorline
    endif
    call g:BriofitaParmSet('localcursorline', 0) " REQD KEY: disable tablocal operation of cul/cuc
    call g:BriofitaParmSet('cursorline', a:startpoint)
    call g:BriofitaCycleCL(a:startpoint)
endfunction

function! g:BriofitaLocal(highlight,startpoint)    " {{{1
    call g:BriofitaParmSet('localcursorline', 1) " REQD KEY: enable tablocal operation of cul/cuc
    let t:briofita_choice_for_cursorline = a:startpoint
    call g:BriofitaCycleCL(a:startpoint)
endfunction


function! g:BriofitaCycle(highlightname)    " {{{1
    let l:colorisloaded = 0
    let l:cname = ''
    if exists("g:colors_name")
        let l:colorisloaded = (g:colors_name=='briofita')
        let l:cname = g:colors_name
    endif
    if (!l:colorisloaded) || (len(l:cname)==0)
        if exists("colors_name")
            let l:colorisloaded = (colors_name=='briofita')
            let l:cname = colors_name
        endif
    endif
    if (!l:colorisloaded) || (len(l:cname)==0)
        return
    endif
    if a:highlightname != 'cursorline'
        "echomsg 'NOT IMPLEMENTED YET: cycling of non-cursorline option'
        return
    endif
    let l:globalnewvalue = -1
    if exists('g:briofita_parms')
        if ! has_key(g:briofita_parms,"localcursorline")
            " NOTE: whatever the operation, 'localcursorline' is a REQUIRED key in the dictionary!
            "echomsg 'WARN: missing key in the g:briofita_parms dict: localcursorline'
            return
        endif
        if has_key(g:briofita_parms,"cursorline")
            let increasedvalue = g:briofita_parms.cursorline
            let increasedvalue += 1
            let l:globalnewvalue = increasedvalue
        else
            let l:globalnewvalue = 0
        endif
    else
        let g:briofita_parms = { 'cursorline': 0, 'localcursorline': 0}
    endif
    if g:briofita_parms.localcursorline
        " local cul/cuc
        let t:briofita_choice_for_cursorline += 1
        let let5cmd = "let g:briofita_parms['" . a:highlightname . "'] = " .
                         \ t:briofita_choice_for_cursorline
        execute let5cmd
    else
        " global cul/cuc
        let g:briofita_parms['cursorline'] = l:globalnewvalue
    endif
    call g:SourceColorscheme(l:cname,0)
endfunction

function! g:BriofitaCycleCL(...)    " {{{1
    " ciclying for the cursorline (or cursorcolumn) options
    if exists("g:colors_name")
        let s:isbriofita = 0
        if g:colors_name =~ "briofita"
            let s:isbriofita = 1
        elseif exists('t:colorscheme')
            if t:colorscheme =~ "briofita"
                let s:isbriofita = 2
            endif
        endif
        if s:isbriofita
            let l:isglobaloption = 1
            if exists("g:briofita_parms")
               if has_key(g:briofita_parms,'localcursorline')
                    if  g:briofita_parms.localcursorline
                        let l:isglobaloption = 0
                    endif
                else
                    "echomsg "REQUIRED g:dicttionary localcursorline key is missing"
                    return
                endif
            else
                "echomsg "Missing briofita_parms dictionary"
                return
            endif
            if a:0 > 0
                let l:initval = a:1
            else
                let l:initval = 0
            endif
            if ! l:isglobaloption
                if exists("t:briofita_choice_for_cursorline")
                    return
                else
                    let t:briofita_choice_for_cursorline = l:initval
                endif
            else " RESET global non-tabpage-local cursorline
                let g:briofita_parms.localcursorline = l:initval
            endif
        endif
    endif
endfunction

function! g:BriofitaInterfaceVars()    " {{{1
    " shows g: or t: variables which the user uses to set the colorscheme options
    if exists("g:briofita_parms") ||
     \ exists("t:briofita_choice_for_cursorline")
        echomsg '*** Briofita Colorscheme Interface Variables:'
        if exists("g:briofita_parms")
            echomsg '  * g:briofita_parms:'
            echomsg '   ' . string(g:briofita_parms)
        endif
        if exists("t:briofita_choice_for_cursorline")
            echomsg '  * t:briofita_choice_for_cursorline = ' .
                \ string(t:briofita_choice_for_cursorline)
        endif
        echomsg '--------------------------------------------------------------------------'
    else
        echomsg '*** currently there are no briofita state variables '
    endif
endfunction

function! g:CursorlineCommander(be_local,cycle_start_point)
    " this is just an example of how the user may set various Briofita parameters
    if a:be_local
        call g:BriofitaSetOneParm('localcursorline', 1)
    else
        call g:BriofitaSetOneParm('localcursorline', 0)
    endif
    call g:BriofitaParmSet('cursorline', a:cycle_start_point)
    call g:BriofitaParmSet('search', 5)
    call g:BriofitaParmSet('vimgroup', 0)
    call g:BriofitaParmSet('conceal', 0)
    call g:BriofitaParmSet('foldcolumn', 0)
    call g:BriofitaParmSet('folded', 0)
    call g:BriofitaParmSet('nodistractionmode', 0)
    call g:BriofitaParmSet('statusline', 0)
    call g:BriofitaParmSet('colorcolumn', 0)
    call g:BriofitaParmSet('normal', 0)
    call g:BriofitaParmSet('special', 0)
    call g:BriofitaParmSet('cursorlinenr', 0)
    call g:BriofitaCycleCL(a:cycle_start_point)
    return
endfunction

function! g:BriofitaMenu() " {{{1
    if exists("g:briofita_root_menu")
        let s:briofita_root_menu = g:briofita_root_menu
    endif
    let lstmenuops = ['-sep00-	<nop>',
        \ '\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Briofita\ Colorscheme\ Support\ \ \ \ \ \ \ \ \ \ \ \ \ \ \   <nop>',
        \ '-sep01-       <nop>',
        \ 'Load\ Briofita\ via\ \:color\ command  :color briofita<CR>',
        \ 'Load\ Briofita\ locally\ on\ current\ tabpage\ via\ TabPageColorscheme\ plugin  :Tcolorscheme briofita<CR>',
        \ '-sep02-       <nop>',
        \ 'cursorline\/cursorcolumn\:  <nop>',
        \ '\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Switch\ to\ global\ style      :call g:BriofitaGlobal7("cursorline")<cr>',
        \ '\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Switch\ to\ tabpage\-local\ style      :call g:BriofitaLocal5("cursorline")<cr>',
        \ '\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Rotation\ cycle      :call g:BriofitaCycle("cursorline")<cr>',
        \ '-sep05-       <nop>',
        \ 'Show\ Briofita\ interface\ variables      :call g:BriofitaInterfaceVars()<cr>',
        \ 'Show\ Briofita\ version\ and\ settings      :echo g:BriofitaVersion()<cr>',
        \ '-sep07-       <nop>',
        \ 'Display\ Briofita\ help\ and\ release\ notes      :tab help briofita<cr>',
        \ '-sep08-       <nop>']
    for menuentry in lstmenuops
        let menucmd = 'amenu  <silent> ' .
            \ s:briofita_root_menu .
            \ menuentry
        execute menucmd
    endfor

endfunction

"
"----------------------------------------------------------------------------
" modeline {{{1
"
" vim: et:ts=4:sw=4:fdm=marker:fdl=0:ft=vim:
