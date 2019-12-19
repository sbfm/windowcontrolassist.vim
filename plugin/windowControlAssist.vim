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

function! s:windowControl.OpenSideMenu(menuName, width)
  return windowControlAssist#sidemenu#Open(a:menuName, a:width)
endfunction

function! s:windowControl.CheckActiveSideMenu(menuName)
  return windowControlAssist#sidemenu#CheckActive(a:menuName)
endfunction

function! s:windowControl.CloseSideMenu(menuName)
  return windowControlAssist#sidemenu#Close(a:menuName)
endfunction

function! s:windowControl.SetActionSideMenu(key, methodName)
  silent! execute 'nnoremap <silent> <buffer> ' . a:key . ' :call ' .  a:methodName . '(line(".")) <CR>'
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

