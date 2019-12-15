" ============================================================================
" Filename: 
" Author: Fumiya Shibamata (@shibafumi)
" Last Change: 16-Dec-2019.
" ============================================================================

let s:windowControl = {}
let g:WindowControlAssist = s:windowControl

" -------------------------------------
" ファイル名から居場所を検索する
" -------------------------------------
" SearchForTabnoByFilename
"   与えたファイル名のタブ番号を取得する
" SearchForWindownoByFilename
"   与えたファイル名のウィンドウ番号を取得する
" SearchBuffnoByFilename
"   与えたファイル名のバッファ番号を取得する
"  
" -------------------------------------
" ウィンドウの操作を行う
" -------------------------------------
" OpenNewWindow
"   新しいウィンドウを開く
" OpenNewOutsideWindow
"   新しいウィンドウを外側に開く
" CloseWindowByWindowno
"   与えたウィンドウ番号をクローズする
" SearchUsableWindow
"   重要でないなウィンドウを探す
" MoveWindow
"   指定したウィンドウへ移動
"
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
" -------------------------------------
"  サイドメニュー操作
" -------------------------------------
" OpenSideMenu
" CheckActiveSideMenu
" SetActionSideMenu
" CloseSideMenu
"
" -------------------------------------
"  文字入力を行うエリアの作成
" -------------------------------------
"
" -------------------------------------
" 便利機能
" -------------------------------------
" GetSequence
"   呼び出す度に重複しない数字を返却する
" SilentCommand
"   自動実行される機能を無視してコマンドを流す
"
"
"
"winnr("#")

"
" MoveJustBeforeWindow
"   
"
"
"
"
"

" 指定したウィンドウ番号を閉じる
function! s:windowControl.CloseWindowByWindowno(windowNumber, lastOneClose)
  if a:lastOneClose == 1 && winnr("$") == 1
    return 0
  endif
  let l:win_backup = win_getid()
  call SilentCommand(a:windowNumber . "wincmd w")
  close
  call SilentCommand("call win_gotoid(" . l:win_backup . ")")
  return 1
endfunction

" 外周に新しいウィンドウを開く
function! s:windowControl.OpenNewOutsideWindow(direction, size)
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


" ファイル名からバッファ番号を取得
" -1以外 : バッファ番号
" -1     : バッファが存在しない
function! s:windowControl.SearchBuffnoByFilename(fileName)
  return bufwinnr(a:fileName)
endfunction

" ---------------------------------
" 呼び出す度に重複しない数値を返却する
function! s:windowControl.GetSequence()
  if !exists("s:SequenceNumber")
    let s:SequenceNumber = 1
  else
    let s:SequenceNumber += 1
  endif
  return s:SequenceNumber
endfunction

" 編集許可されていないファイルの更新
function! s:windowControl.InsertSystemFile(setLine)
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
function! s:windowControl.OpenNewSystemFile(fileName)
  if SearchBuffnoByFilename(a:fileName) == -1
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

" 保存しないシステム用のファイルを開く
function! s:windowControl.OpenNewEditFile(fileName)
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

" ------------------------
" testcode
" -----------------------
" 与えたファイル名のタブ番号を先頭から探索する
" 最初に発見したタブ番号を返却する
" 0     : どのタブにも存在しない
" 0以外 : タブ番号
function! s:windowControl.SearchForTabnoByFilename(filename)
  " 全てのタブを順番に探索
  for tab in range(tabpagenr('$'))
    for buf in tabpagebuflist(tab + 1)
      "一致するファイル名を探索
      if a:filename == expand('#' . buf . ':p')
        return tab + 1
      endif
    endfor
  endfor
  return -1
endfunction

"------------------------------
"与えたファイル名が現在のタブにいるとき
"与えたファイル名のウィンドウ番号を返却する
" -1以外 : ウィンドウ番号
" -1     : 対象なし
function! s:windowControl.SearchForWindownoByFilename(filename)
  return bufwinnr('^' . a:filename . '$')
endfunction

"------------------------------
" 自動実行を禁止してコマンドを流す
function! s:windowControl.SilentCommand(command)
  let ei_backup = &ei
  set ei=BufEnter,BufLeave,VimEnter
  execute a:command
  let &ei = ei_backup
endfunction

" ==================================================
" 利用可能なウィンドウを探索
" ==================================================
" ファイルオープンが可能なwindowを探索します。
" 以下の条件を満たす最初のwindowIDを返却します。
" ※windowが存在しなかった場合は-1を返却します。
" 1. 通常のバッファであること
" 2. プレビューウィンドウでないこと
" 3. 変更を行っていないもの、もしくはhiddenのもの
"
" -1以外 : 利用可能なウィンドウID
" -1     : 使えるウィンドウがない
"
function! s:windowControl.SearchUsableWindow()
  let i = 1
  while i <= winnr("$")
    let windowNumber = winbufnr(i)
    if windowNumber != -1 && getbufvar(windowNumber, '&buftype') ==# ''
                        \ && !getwinvar(i, '&previewwindow')
                        \ && (!getbufvar(windowNumber, '&modified') || &hidden)
      return i
    endif
    let i += 1
  endwhile
  return -1
endfunction

" 指定したウィンドウ番号に移動します
function! s:windowControl.MoveWindow(windowNumber)
  call SilentCommand(a:windowNumber . "wincmd p")
endfunction

" ----------------------------------
" 現在地から新規にウィンドウを開く
" 　開いたウィンドウに自動的にカーソルが合う
function! s:windowControl.OpenNewWindow(method)
  if a:method == 'v'
    vsplit
  elseif a:method == 's'
    split
  elseif a:method == 't'
    tabnew
  endif
endfunction

" ----------------------------------
" sideMenu
" ----------------------------------
function! s:windowControl.OpenSideMenu(menuName, width)
  " タブに名前が設定されているか確認
  if !exists('t:sideMenu_' . a:menuName)
    " バッファ名が指定されていない場合、名前を取得し、設定 
    let l:hoge = 1
    silent! execute 'let t:sideMenu_' . a:menuName . ' = "' . a:menuName . '_SM' . GetSequence() . '"'
  else 
    let l:hoge = 2
  endif
  silent! execute 'let t:sideMenuTemp = t:sideMenu_' . a:menuName
  call OpenNewOutsideWindow('l', a:width)
  call OpenNewSystemFile(t:sideMenuTemp)
  unlet t:sideMenuTemp
  return l:hoge
endfunction

function! s:windowControl.CheckActiveSideMenu(menuName)
  silent! execute 'let t:sideMenuTemp = t:sideMenu_' . a:menuName
  let l:ans = s:SearchForWindownoByFilename(t:sideMenuTemp)
  unlet t:sideMenuTemp
  return l:ans
endfunction

function! s:windowControl.SetActionSideMenu(key, methodName)
  silent! execute 'nnoremap <silent> <buffer> ' . a:key . ' :call ' .  a:methodName . '(line(".")) <CR>'
  return 1
endfunction

function! s:windowControl.CloseSideMenu(menuName)
  silent! execute 'let t:sideMenuTemp = t:sideMenu_' . a:menuName
  let l:sideMenuWindowno = s:SearchForWindownoByFilename(t:sideMenuTemp)
  if l:sideMenuWindowno == -1
    return -1
  endif
  if !CloseWindowByWindowno(l:sideMenuWindowno, 0)
    "閉じれなかった場合
    return -1
  endif
  unlet t:sideMenuTemp
  return 1
endfunction

" ----------------------------------
" editEria
" ----------------------------------
function! s:windowControl.OpenEditArea(menuName, height)
  call OpenNewOutsideWindow('b', a:height)
  call OpenNewEditFile(a:menuName)
endfunction

function! s:windowControl.SetActionEditArea(key, methodName, menuName)
  silent! execute 'nnoremap <silent> <buffer> ' . a:key . ' :call ' .  a:methodName . '("' . a:menuName . '") <CR>'
  return 1
endfunction

function! s:windowControl.CloseEditArea(menuName)
  let l:sideMenuWindowno = s:SearchForWindownoByFilename(a:menuName)
  if !CloseWindowByWindowno(l:sideMenuWindowno, 0)
    "閉じれなかった場合
    return -1
  endif
endfunction


" ----------------------------------------------------------------
" testcode
function! Hog()
  if CheckActiveSideMenu("sample") == -1
    call OpenSideMenu("sample", 30)

  else
    call CloseSideMenu("sample")
  endif
endfunction

function! Fog()
  if s:SearchForWindownoByFilename("mai") == -1
    call OpenEditArea("mai", 6)
    let hoggg="<CR>"
    let hoho = "ho"
    silent! execute 'nnoremap <silent> <buffer> ' . l:hoggg . ' :call Foi("' . l:hoho . '") <CR>'
  else
    call CloseEditArea("mai")
  endif
endfunction

function! Foi(momo)
  echo "mozyamozya"
endfunction

