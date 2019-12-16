" ============================================================================
" Filename: 
" Author: Fumiya Shibamata (@shibafumi)
" Licence: MIT LICENCE
" Last Change: 17-Dec-2019.
" ============================================================================
" -------------------------------------
" ウィンドウの操作を行う
" -------------------------------------
" OpenNewWindow
"   新しいウィンドウを開く
" OpenNewOutsideWindow
"   新しいウィンドウを外側に開く
" CloseWindowByWindowno
"   与えたウィンドウ番号をクローズする
" MoveWindow
"   指定したウィンドウへ移動
"
"
"
" ----------------------------------
" 現在地から新規にウィンドウを開く
" 　開いたウィンドウに自動的にカーソルが合う
function! windowControlAssist#window#Open(method)
  if a:method == 'v'
    vsplit
  elseif a:method == 's'
    split
  elseif a:method == 't'
    tabnew
  endif
endfunction

" 外周に新しいウィンドウを開く
function! windowControlAssist#window#OpenOutside(direction, size)
  " 開ける方向に合わせてオプションを用意する
  if a:direction == 't'
    let l:direc = 'topleft '
  elseif a:direction == 'b'
    let l:direc = 'botright '
  elseif a:direction == 'r'
    let l:direc = 'botright vertical '
  elseif a:direction == 'l'
    let l:direc = 'topleft vertical '
  endif
  silent! execute l:direc . a:size . ' split' 
  return 1
endfunction


" 指定したウィンドウ番号を閉じる
function! windowControlAssist#window#CloseByWindowno(windowNumber, lastOneClose)
  if a:lastOneClose == 1 && winnr("$") == 1
    return 0
  endif
  let l:win_backup = win_getid()
  call windowControlAssist#etc#SilentCommand(a:windowNumber . "wincmd w")
  close
  call windowControlAssist#etc#SilentCommand("call win_gotoid(" . l:win_backup . ")")
  return 1
endfunction


" 指定したウィンドウ番号に移動します
function! windowControlAssist#window#Move(windowNumber)
  call windowControlAssist#etc#SilentCommand(a:windowNumber . "wincmd p")
endfunction



