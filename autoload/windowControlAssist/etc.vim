" ============================================================================
" Filename: 
" Author: Fumiya Shibamata (@shibafumi)
" Licence: MIT LICENCE
" Last Change: 17-Dec-2019.
" ============================================================================
" -------------------------------------
" 便利機能
" -------------------------------------
" GetSequence
"   呼び出す度に重複しない数字を返却する
" SilentCommand
"   自動実行される機能を無視してコマンドを流す
" 呼び出す度に重複しない数値を返却する
"
function! windowControlAssist#etc#GetSequence()
  if !exists("s:SequenceNumber")
    let s:SequenceNumber = 1
  else
    let s:SequenceNumber += 1
  endif
  return s:SequenceNumber
endfunction


"------------------------------
" 自動実行を禁止してコマンドを流す
function! windowControlAssist#etc#SilentCommand(command)
  let ei_backup = &ei
  set ei=BufEnter,BufLeave,VimEnter
  execute a:command
  let &ei = ei_backup
endfunction
