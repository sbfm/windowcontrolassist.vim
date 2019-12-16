" ============================================================================
" Filename: 
" Author: Fumiya Shibamata (@shibafumi)
" Licence: MIT LICENCE
" Last Change: 17-Dec-2019.
" ============================================================================

if exists('g:WindowControlAssist') || v:version < 700
  finish
endif
let s:windowControl = {}
let g:WindowControlAssist = s:windowControl

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
"
"winnr("#")

" ----------------------------------
" sideMenu
" ----------------------------------
function! s:windowControl.OpenSideMenu(menuName, width)
  " タブに名前が設定されているか確認
  if !exists('t:sideMenu_' . a:menuName)
    " バッファ名が指定されていない場合、名前を取得し、設定 
    let l:hoge = 1
    silent! execute 'let t:sideMenu_' . a:menuName . ' = "' . a:menuName . '_SM' . windowControlAssist#etc#GetSequence() . '"'
  else 
    let l:hoge = 2
  endif

  silent! execute 'let t:sideMenuTemp = t:sideMenu_' . a:menuName
  call windowControlAssist#window#OpenOutside('l', a:width)
  call windowControlAssist#file#OpenPreview(t:sideMenuTemp)
  unlet t:sideMenuTemp
  return l:hoge
endfunction

function! s:windowControl.CheckActiveSideMenu(menuName)
  if exists('t:sideMenu_' . a:menuName)
    silent! execute 'let t:sideMenuTemp = t:sideMenu_' . a:menuName
    let l:ans = windowControlAssist#search#WindownoByFilename(t:sideMenuTemp)
    unlet t:sideMenuTemp
  else
    let l:ans = -1
  endif
  return l:ans
endfunction

function! s:windowControl.SetActionSideMenu(key, methodName)
  silent! execute 'nnoremap <silent> <buffer> ' . a:key . ' :call ' .  a:methodName . '(line(".")) <CR>'
  return 1
endfunction

function! s:windowControl.CloseSideMenu(menuName)
  silent! execute 'let t:sideMenuTemp = t:sideMenu_' . a:menuName
  let l:sideMenuWindowno = windowControlAssist#search#WindownoByFilename(t:sideMenuTemp)
  if l:sideMenuWindowno == -1
    return -1
  endif
  if !windowControlAssist#window#CloseByWindowno(l:sideMenuWindowno, 0)
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
  call windowControlAssist#window#OpenOutside('b', a:height)
  call windowControlAssist#file#OpenEditArea(a:menuName)
endfunction

function! s:windowControl.SetActionEditArea(key, methodName, menuName)
  silent! execute 'nnoremap <silent> <buffer> ' . a:key . ' :call ' .  a:methodName . '("' . a:menuName . '") <CR>'
  return 1
endfunction

function! s:windowControl.CloseEditArea(menuName)
  let l:sideMenuWindowno = windowControlAssist#search#WindownoByFilename(a:menuName)
  if !windowControlAssist#window#CloseByWindowno(l:sideMenuWindowno, 0)
    "閉じれなかった場合
    return -1
  endif
endfunction


" ----------------------------------------------------------------
" testcode
function! Hog()
  if g:WindowControlAssist.CheckActiveSideMenu("sample") == -1
    call g:WindowControlAssist.OpenSideMenu("sample", 30)
  else
    call g:WindowControlAssist.CloseSideMenu("sample")
  endif
endfunction

function! Fog()
  if windowControlAssist#search#WindownoByFilename("mai") == -1
    call g:WindowControlAssist.OpenEditArea("mai", 6)
    let hoggg="<CR>"
    let hoho = "ho"
    silent! execute 'nnoremap <silent> <buffer> ' . l:hoggg . ' :call Foi("' . l:hoho . '") <CR>'
  else
    call g:WindowControlAssist.CloseEditArea("mai")
  endif
endfunction

function! Foi(momo)
  echo "mozyamozya"
endfunction

