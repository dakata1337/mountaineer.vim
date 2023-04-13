" Initialization: {{{
highlight clear
if exists('syntax_on')
  syntax reset
endif
set background=dark

let s:t_Co = exists('&t_Co') && !empty(&t_Co) && &t_Co > 1 ? &t_Co : 2

let g:colors_name = 'mountaineer-grey'
" }}}
" Configuration: {{{
let s:configuration = {}
let s:configuration.palette = get(g:, 'mountaineer-grey_palette', 'soft')
let s:configuration.transparent_background = get(g:, 'mountaineer-grey_transparent_background', 0)
let s:configuration.disable_italic_comment = get(g:, 'mountaineer-grey_disable_italic_comment', 0)
let s:configuration.enable_italic = get(g:, 'mountaineer-grey_enable_italic', 0)
let s:configuration.cursor = get(g:, 'mountaineer-grey_cursor', 'auto')
let s:configuration.current_word = get(g:, 'mountaineer-grey_current_word', get(g:, 'mountaineer-grey_transparent_background', 0) == 0 ? 'grey background' : 'bold')
" }}}
" Palette: {{{
let s:palette = {
      \ 'bg0':        ['#191919',   '235',  'Black'],
      \ 'bg1':        ['#222222',   '236',  'DarkGrey'],
      \ 'bg2':        ['#222222',   '237',  'DarkGrey'],
      \ 'bg3':        ['#191919',   '238',  'DarkGrey'],
      \ 'bg4':        ['#191919',   '239',  'Grey'],
      \ 'bg_red':     ['#222222',   '52',   'DarkRed'],
      \ 'bg_green':   ['#222222',   '22',   'DarkGreen'],
      \ 'bg_blue':    ['#222222',   '17',   'DarkBlue'],
      \ 'fg':         ['#f0f0f0',   '223',  'White'],
      \ 'red':        ['#AC8A8C',   '167',  'Red'],
      \ 'orange':     ['#AC9D8A',   '208',  'Red'],
      \ 'yellow':     ['#ACA98A',   '214',  'Yellow'],
      \ 'green':      ['#8AAC8B',   '108',  'Green'],
      \ 'cyan':       ['#8AABAC',   '108',  'Cyan'],
      \ 'blue':       ['#8F8AAC',   '109',  'Blue'],
      \ 'purple':     ['#AC8AAC',   '175',  'Magenta'],
      \ 'grey':       ['#363636',   '245',  'LightGrey'],
      \ 'light_grey': ['#4c4c4c',   '245',  'LightGrey'],
      \ 'gold':       ['#2f4243',   '214',  'Yellow'],
      \ 'none':       ['NONE',      'NONE', 'NONE']
      \ }
" }}}
" Function: {{{
" call s:HL(group, foreground, background)
" call s:HL(group, foreground, background, gui, guisp)
"
" E.g.:
" call s:HL('Normal', s:palette.fg, s:palette.bg0)

if (has('termguicolors') && &termguicolors) || has('gui_running')  " guifg guibg gui cterm guisp
  function! s:HL(group, fg, bg, ...)
    let hl_string = [
          \ 'highlight', a:group,
          \ 'guifg=' . a:fg[0],
          \ 'guibg=' . a:bg[0],
          \ ]
    if a:0 >= 1
      if a:1 ==# 'undercurl'
        call add(hl_string, 'gui=undercurl')
        call add(hl_string, 'cterm=underline')
      else
        call add(hl_string, 'gui=' . a:1)
        call add(hl_string, 'cterm=' . a:1)
      endif
    else
      call add(hl_string, 'gui=NONE')
      call add(hl_string, 'cterm=NONE')
    endif
    if a:0 >= 2
      call add(hl_string, 'guisp=' . a:2[0])
    endif
    execute join(hl_string, ' ')
  endfunction
elseif s:t_Co >= 256  " ctermfg ctermbg cterm
  function! s:HL(group, fg, bg, ...)
    let hl_string = [
          \ 'highlight', a:group,
          \ 'ctermfg=' . a:fg[1],
          \ 'ctermbg=' . a:bg[1],
          \ ]
    if a:0 >= 1
      if a:1 ==# 'undercurl'
        call add(hl_string, 'cterm=underline')
      else
        call add(hl_string, 'cterm=' . a:1)
      endif
    else
      call add(hl_string, 'cterm=NONE')
    endif
    execute join(hl_string, ' ')
  endfunction
else  " ctermfg ctermbg cterm
  function! s:HL(group, fg, bg, ...)
    let hl_string = [
          \ 'highlight', a:group,
          \ 'ctermfg=' . a:fg[2],
          \ 'ctermbg=' . a:bg[2],
          \ ]
    if a:0 >= 1
      if a:1 ==# 'undercurl'
        call add(hl_string, 'cterm=underline')
      else
        call add(hl_string, 'cterm=' . a:1)
      endif
    else
      call add(hl_string, 'cterm=NONE')
    endif
    execute join(hl_string, ' ')
  endfunction
endif
" }}}

" Common Highlight Groups: {{{
" UI: {{{
if s:configuration.transparent_background
  call s:HL('Normal', s:palette.fg, s:palette.none)
  call s:HL('Terminal', s:palette.fg, s:palette.none)
  call s:HL('EndOfBuffer', s:palette.bg0, s:palette.none)
  call s:HL('FoldColumn', s:palette.grey, s:palette.none)
  call s:HL('Folded', s:palette.grey, s:palette.none)
  call s:HL('SignColumn', s:palette.fg, s:palette.none)
else
  call s:HL('Normal', s:palette.fg, s:palette.bg0)
  call s:HL('Terminal', s:palette.fg, s:palette.bg0)
  call s:HL('EndOfBuffer', s:palette.bg0, s:palette.bg0)
  call s:HL('FoldColumn', s:palette.grey, s:palette.bg1)
  call s:HL('Folded', s:palette.grey, s:palette.bg1)
  call s:HL('SignColumn', s:palette.fg, s:palette.bg0)
endif
call s:HL('ColorColumn', s:palette.none, s:palette.bg1)
call s:HL('Conceal', s:palette.grey, s:palette.none)
if s:configuration.cursor ==# 'auto'
  call s:HL('Cursor', s:palette.none, s:palette.none, 'reverse')
  call s:HL('lCursor', s:palette.none, s:palette.none, 'reverse')
elseif s:configuration.cursor ==# 'red'
  call s:HL('Cursor', s:palette.bg0, s:palette.red)
  call s:HL('lCursor', s:palette.bg0, s:palette.red)
elseif s:configuration.cursor ==# 'green'
  call s:HL('Cursor', s:palette.bg0, s:palette.green)
  call s:HL('lCursor', s:palette.bg0, s:palette.green)
elseif s:configuration.cursor ==# 'blue'
  call s:HL('Cursor', s:palette.bg0, s:palette.blue)
  call s:HL('lCursor', s:palette.bg0, s:palette.blue)
elseif s:configuration.cursor ==# 'purple'
  call s:HL('Cursor', s:palette.bg0, s:palette.purple)
  call s:HL('lCursor', s:palette.bg0, s:palette.purple)
endif
call s:HL('CursorColumn', s:palette.none, s:palette.bg1)
call s:HL('CursorLine', s:palette.none, s:palette.bg1)
call s:HL('LineNr', s:palette.grey, s:palette.none)
if &relativenumber == 1 && &cursorline == 0
  call s:HL('CursorLineNr', s:palette.fg, s:palette.none)
else
  call s:HL('CursorLineNr', s:palette.fg, s:palette.bg0)
endif
call s:HL('DiffAdd', s:palette.none, s:palette.bg_green)
call s:HL('DiffChange', s:palette.none, s:palette.bg_blue)
call s:HL('DiffDelete', s:palette.none, s:palette.bg_red)
call s:HL('DiffText', s:palette.none, s:palette.bg0, 'reverse')
call s:HL('Directory', s:palette.green, s:palette.none)
call s:HL('ErrorMsg', s:palette.red, s:palette.none, 'bold,underline')
call s:HL('WarningMsg', s:palette.yellow, s:palette.none, 'bold')
call s:HL('ModeMsg', s:palette.fg, s:palette.none, 'bold')
call s:HL('MoreMsg', s:palette.blue, s:palette.none, 'bold')
call s:HL('IncSearch', s:palette.none, s:palette.none, 'reverse')
call s:HL('Search', s:palette.none, s:palette.bg3)
call s:HL('MatchParen', s:palette.none, s:palette.bg4)
call s:HL('NonText', s:palette.grey, s:palette.none)
call s:HL('Pmenu', s:palette.fg, s:palette.bg2)
call s:HL('PmenuSbar', s:palette.none, s:palette.bg2)
call s:HL('PmenuThumb', s:palette.none, s:palette.grey)
call s:HL('PmenuSel', s:palette.bg0, s:palette.fg)
call s:HL('WildMenu', s:palette.bg0, s:palette.fg)
call s:HL('Question', s:palette.yellow, s:palette.none)
call s:HL('SpellBad', s:palette.red, s:palette.none, 'undercurl', s:palette.red)
call s:HL('SpellCap', s:palette.yellow, s:palette.none, 'undercurl', s:palette.yellow)
call s:HL('SpellLocal', s:palette.blue, s:palette.none, 'undercurl', s:palette.blue)
call s:HL('SpellRare', s:palette.purple, s:palette.none, 'undercurl', s:palette.purple)
call s:HL('StatusLine', s:palette.fg, s:palette.bg3)
call s:HL('StatusLineTerm', s:palette.fg, s:palette.bg3)
call s:HL('StatusLineNC', s:palette.grey, s:palette.bg1)
call s:HL('StatusLineTermNC', s:palette.grey, s:palette.bg1)
call s:HL('TabLine', s:palette.fg, s:palette.bg4)
call s:HL('TabLineFill', s:palette.grey, s:palette.bg1)
call s:HL('TabLineSel', s:palette.bg0, s:palette.green)
call s:HL('VertSplit', s:palette.bg4, s:palette.none)
call s:HL('Visual', s:palette.fg, s:palette.gold)
call s:HL('VisualNOS', s:palette.bg0, s:palette.gold, 'underline')
call s:HL('CursorIM', s:palette.none, s:palette.fg)
call s:HL('ToolbarLine', s:palette.none, s:palette.grey)
call s:HL('ToolbarButton', s:palette.fg, s:palette.bg0, 'bold')
call s:HL('QuickFixLine', s:palette.blue, s:palette.bg1)
call s:HL('Debug', s:palette.yellow, s:palette.none)
" }}}
" Syntax: {{{
call s:HL('Boolean', s:palette.purple, s:palette.none)
call s:HL('Number', s:palette.purple, s:palette.none)
call s:HL('Float', s:palette.purple, s:palette.none)
if s:configuration.enable_italic
  call s:HL('PreProc', s:palette.purple, s:palette.none, 'italic')
  call s:HL('PreCondit', s:palette.purple, s:palette.none, 'italic')
  call s:HL('Include', s:palette.purple, s:palette.none, 'italic')
  call s:HL('Define', s:palette.purple, s:palette.none, 'italic')
  call s:HL('Conditional', s:palette.red, s:palette.none, 'bold,italic')
  call s:HL('Repeat', s:palette.red, s:palette.none, 'italic')
  call s:HL('Keyword', s:palette.red, s:palette.none, 'italic')
  call s:HL('Typedef', s:palette.red, s:palette.none, 'italic')
  call s:HL('Exception', s:palette.red, s:palette.none, 'italic')
  call s:HL('Statement', s:palette.red, s:palette.none, 'italic')
else
  call s:HL('PreProc', s:palette.purple, s:palette.none)
  call s:HL('PreCondit', s:palette.purple, s:palette.none)
  call s:HL('Include', s:palette.purple, s:palette.none)
  call s:HL('Define', s:palette.purple, s:palette.none)
  call s:HL('Conditional', s:palette.red, s:palette.none)
  call s:HL('Repeat', s:palette.red, s:palette.none)
  call s:HL('Keyword', s:palette.red, s:palette.none)
  call s:HL('Typedef', s:palette.red, s:palette.none)
  call s:HL('Exception', s:palette.red, s:palette.none)
  call s:HL('Statement', s:palette.red, s:palette.none)
endif
call s:HL('Error', s:palette.red, s:palette.none)
call s:HL('StorageClass', s:palette.orange, s:palette.none, 'bold')
call s:HL('Tag', s:palette.orange, s:palette.none)
call s:HL('Label', s:palette.orange, s:palette.none)
call s:HL('Structure', s:palette.orange, s:palette.none)
call s:HL('Operator', s:palette.orange, s:palette.none)
call s:HL('Title', s:palette.orange, s:palette.none, 'bold')
call s:HL('Special', s:palette.yellow, s:palette.none)
call s:HL('SpecialChar', s:palette.yellow, s:palette.none)
call s:HL('Type', s:palette.yellow, s:palette.none, 'bold')
call s:HL('Function', s:palette.green, s:palette.none, 'bold')
call s:HL('String', s:palette.green, s:palette.none)
call s:HL('Character', s:palette.green, s:palette.none)
call s:HL('Constant', s:palette.cyan, s:palette.none, 'bold')
call s:HL('Macro', s:palette.cyan, s:palette.none)
call s:HL('Identifier', s:palette.blue, s:palette.none)
call s:HL('SpecialKey', s:palette.blue, s:palette.none)
if s:configuration.disable_italic_comment
  call s:HL('Comment', s:palette.light_grey, s:palette.none)
  call s:HL('SpecialComment', s:palette.light_grey, s:palette.none)
  call s:HL('Todo', s:palette.purple, s:palette.none)
else
  call s:HL('Comment', s:palette.light_grey, s:palette.none, 'italic')
  call s:HL('SpecialComment', s:palette.light_grey, s:palette.none, 'italic')
  call s:HL('Todo', s:palette.purple, s:palette.none, 'italic')
endif
call s:HL('Delimiter', s:palette.fg, s:palette.none)
call s:HL('Ignore', s:palette.grey, s:palette.none)
call s:HL('Underlined', s:palette.none, s:palette.none, 'underline')
" }}}
" Predefined Highlight Groups: {{{
call s:HL('Fg', s:palette.fg, s:palette.none)
call s:HL('Grey', s:palette.grey, s:palette.none)
call s:HL('Yellow', s:palette.yellow, s:palette.none)
call s:HL('Blue', s:palette.blue, s:palette.none)
if s:configuration.enable_italic
  call s:HL('RedItalic', s:palette.red, s:palette.none, 'italic')
  call s:HL('OrangeItalic', s:palette.orange, s:palette.none, 'italic')
  call s:HL('PurpleItalic', s:palette.purple, s:palette.none, 'italic')
else
  call s:HL('RedItalic', s:palette.red, s:palette.none)
  call s:HL('OrangeItalic', s:palette.orange, s:palette.none)
  call s:HL('PurpleItalic', s:palette.purple, s:palette.none)
endif
call s:HL('Red', s:palette.red, s:palette.none)
call s:HL('Orange', s:palette.orange, s:palette.none)
call s:HL('Purple', s:palette.purple, s:palette.none)
call s:HL('Green', s:palette.green, s:palette.none)
call s:HL('Cyan', s:palette.cyan, s:palette.none)
if s:configuration.transparent_background
  call s:HL('RedSign', s:palette.red, s:palette.none)
  call s:HL('OrangeSign', s:palette.orange, s:palette.none)
  call s:HL('YellowSign', s:palette.yellow, s:palette.none)
  call s:HL('GreenSign', s:palette.green, s:palette.none)
  call s:HL('CyanSign', s:palette.cyan, s:palette.none)
  call s:HL('BlueSign', s:palette.blue, s:palette.none)
  call s:HL('PurpleSign', s:palette.purple, s:palette.none)
else
  call s:HL('RedSign', s:palette.red, s:palette.bg1)
  call s:HL('OrangeSign', s:palette.orange, s:palette.bg1)
  call s:HL('YellowSign', s:palette.yellow, s:palette.bg1)
  call s:HL('GreenSign', s:palette.green, s:palette.bg1)
  call s:HL('CyanSign', s:palette.cyan, s:palette.bg1)
  call s:HL('BlueSign', s:palette.blue, s:palette.bg1)
  call s:HL('PurpleSign', s:palette.purple, s:palette.bg1)
endif
" }}}
" }}}
" Plugins: {{{
" airblade/vim-gitgutter{{{
highlight! link GitGutterAdd GreenSign
highlight! link GitGutterChange BlueSign
highlight! link GitGutterDelete RedSign
highlight! link GitGutterChangeDelete PurpleSign
" }}}
" junegunn/fzf.vim{{{
let g:fzf_colors = {
      \ 'fg':      ['fg', 'Normal'],
      \ 'bg':      ['bg', 'Normal'],
      \ 'hl':      ['fg', 'Green'],
      \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
      \ 'hl+':     ['fg', 'Cyan'],
      \ 'info':    ['fg', 'Cyan'],
      \ 'prompt':  ['fg', 'Orange'],
      \ 'pointer': ['fg', 'Blue'],
      \ 'marker':  ['fg', 'Yellow'],
      \ 'spinner': ['fg', 'Yellow'],
      \ 'header':  ['fg', 'Grey']
      \ }
" }}}
" APZelos/blamer.nvim {{{
highlight! link Blamer Grey
" }}}
" }}}
" Terminal: {{{
if (has('termguicolors') && &termguicolors) || has('gui_running')
  " Definition
  let s:terminal = {
        \ 'black':    s:palette.fg,
        \ 'red':      s:palette.red,
        \ 'yellow':   s:palette.yellow,
        \ 'green':    s:palette.green,
        \ 'cyan':     s:palette.cyan,
        \ 'blue':     s:palette.blue,
        \ 'purple':   s:palette.purple,
        \ 'white':    s:palette.grey
        \ }
  " Implementation: {{{
  if !has('nvim')
    let g:terminal_ansi_colors = [s:terminal.black[0], s:terminal.red[0], s:terminal.green[0], s:terminal.yellow[0],
          \ s:terminal.blue[0], s:terminal.purple[0], s:terminal.cyan[0], s:terminal.white[0], s:terminal.black[0], s:terminal.red[0],
          \ s:terminal.green[0], s:terminal.yellow[0], s:terminal.blue[0], s:terminal.purple[0], s:terminal.cyan[0], s:terminal.white[0]]
  else
    let g:terminal_color_0 = s:terminal.black[0]
    let g:terminal_color_1 = s:terminal.red[0]
    let g:terminal_color_2 = s:terminal.green[0]
    let g:terminal_color_3 = s:terminal.yellow[0]
    let g:terminal_color_4 = s:terminal.blue[0]
    let g:terminal_color_5 = s:terminal.purple[0]
    let g:terminal_color_6 = s:terminal.cyan[0]
    let g:terminal_color_7 = s:terminal.white[0]
    let g:terminal_color_8 = s:terminal.black[0]
    let g:terminal_color_9 = s:terminal.red[0]
    let g:terminal_color_10 = s:terminal.green[0]
    let g:terminal_color_11 = s:terminal.yellow[0]
    let g:terminal_color_12 = s:terminal.blue[0]
    let g:terminal_color_13 = s:terminal.purple[0]
    let g:terminal_color_14 = s:terminal.cyan[0]
    let g:terminal_color_15 = s:terminal.white[0]
  endif
  " }}}
endif
" }}}

highlight RedSign guibg=#191919
highlight GreenSign guibg=#191919
highlight BlueSign guibg=#191919
highlight VertSplit guifg=#343434
highlight FloatBorder guibg=#222222 guifg=#f0f0f0
highlight LineNr guifg=#d0d0d0
highlight LineNrAbove guifg=#363636
highlight LineNrBelow guifg=#363636

" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
