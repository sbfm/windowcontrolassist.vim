" ============================================================================
" Filename: 
" Author: Fumiya Shibamata (@shibafumi)
" Licence: MIT LICENCE
" Last Change: 17-Dec-2019.
" ============================================================================
" -------------------------------------
"  ファイルの操作を行う
" -------------------------------------
" OpenFile
"   ファイルを開く
" OpenNewSystemFile
"   保存しないシステム用ファイルを開く
" InsertSystemFile
"   編集許可されていないファイルの更新
" OpenNewEditFile
"   文字入力を行うテキストエリアを作成 
"
" 保存しないシステム用のファイルを開く
"
"windowControlAssist#search#BuffnoByFilename
function!  windowControlAssist#file#OpenPreview(fileName)
  if windowControlAssist#search#BuffnoByFilename(a:fileName) == -1
    silent! execute "edit " . a:fileName
  else
    silent! execute "buffer " . a:fileName
  endif
  " ウィンドウの幅を保つ
  setlocal winfixwidth
  " 非ファイル
  setlocal buftype=nofile
  " 非表示時バッファを削除しない
  setlocal bufhidden=hide
  " バッファを一覧から消す
  setlocal nobuflisted
  " テキストを折り返さない
  setlocal nowrap
  " スワップファイルを作成しない
  setlocal noswapfile
  " 幅が0のときに非表示にさせる
  setlocal foldcolumn=0
  " アンドゥ用のメモリを確保しない
  setlocal undolevels=-1
  " 行強調を行う
  setlocal cursorline
  " 行数の表示を行わない
  setlocal nonumber
  " 編集を許可しない(modifiableで表示を許可)
  setlocal nomodifiable
endfunction

" 編集許可されていないファイルの更新
function! windowControlAssist#file#InsertPreview(setLine)
  setlocal modifiable
  let l:count = 1
  for tline in a:setLine
    call setline(l:count, l:tline)
    let l:count += 1
  endfor
  " 想定より長いなら削除が必要？ 
  setlocal nomodifiable
endfunction

" 保存しないシステム用のファイルを開く
function! windowControlAssist#file#OpenEditArea(fileName)
  silent! execute "edit " . a:fileName
  " ウィンドウの幅を保つ
  setlocal winfixwidth
  " 非ファイル
  setlocal buftype=nofile
  " 非表示時バッファを削除しない
  setlocal bufhidden=delete
  " バッファを一覧から消す
  setlocal nobuflisted
  " スワップファイルを作成しない
  setlocal noswapfile
  " 幅が0のときに非表示にさせる
  setlocal foldcolumn=0
  " アンドゥ用のメモリを確保しない
  setlocal undolevels=-1
  " 行強調を行う
  setlocal nocursorline
  " 行数の表示を行わない
  setlocal nonumber
endfunction
