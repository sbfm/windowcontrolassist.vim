" ============================================================================
" Filename: 
" Author: Fumiya Shibamata (@shibafumi)
" Licence: MIT LICENCE
" Last Change: 17-Dec-2019.
" ============================================================================
" -------------------------------------
" ファイル名から居場所を検索する
" -------------------------------------
" SearchForTabnoByFilename
"   与えたファイル名のタブ番号を取得する
" SearchForWindownoByFilename
"   与えたファイル名のウィンドウ番号を取得する
" SearchBuffnoByFilename
"   与えたファイル名のバッファ番号を取得する
" SearchUsableWindow
"   重要でないウィンドウを探す
"
"
"
"
" ファイル名からバッファ番号を取得
" -1以外 : バッファ番号
" -1     : バッファが存在しない
function! windowControlAssist#search#BuffnoByFilename(fileName)
  return bufwinnr(a:fileName)
endfunction


" ------------------------
" testcode
" -----------------------
" 与えたファイル名のタブ番号を先頭から探索する
" 最初に発見したタブ番号を返却する
" 0     : どのタブにも存在しない
" 0以外 : タブ番号
"
function! windowControlAssist#search#TabnoByFilename(filename)
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
function! windowControlAssist#search#WindownoByFilename(filename)
  return bufwinnr('^' . a:filename . '$')
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
function! windowControlAssist#search#UsableWindow()
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
