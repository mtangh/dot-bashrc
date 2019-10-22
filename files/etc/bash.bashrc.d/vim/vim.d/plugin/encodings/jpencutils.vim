" JP Encoding utilities
" Vim global plugin for JP Encoding Utilities
"
" Maintainer:   MT
" Last Change:  2014 Apr  9
"
if exists( "g:loaded_jpencutils" )
  finish
endif
"
let g:loaded_jpencutils = 1
"
" commands
command! -nargs=1 Renc  :call <SID>ReloadWithEnc( <f-args> )
command! -nargs=0 UTF8  :call <SID>ReloadWithEnc( "utf-8" )
command! -nargs=0 EUCJP :call <SID>ReloadWithEnc( "euc-jp" )
command! -nargs=0 CP932 :call <SID>ReloadWithEnc( "cp932" )
command! -nargs=0 SJIS  :call <SID>ReloadWithEnc( "sjis" )
"
function s:ReloadWithEnc( enc )
  edit ++enc=a:enc ++bad=keep
endfunction
"
"*eof*
