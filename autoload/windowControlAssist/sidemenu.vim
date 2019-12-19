
function! windowControlAssist#sidemenu#Open(menuName, width)
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

function! windowControlAssist#sidemenu#CheckActive(menuName)
  if exists('t:sideMenu_' . a:menuName)
    silent! execute 'let t:sideMenuTemp = t:sideMenu_' . a:menuName
    let l:ans = windowControlAssist#search#WindownoByFilename(t:sideMenuTemp)
    unlet t:sideMenuTemp
  else
    let l:ans = -1
  endif
  return l:ans
endfunction


function! windowControlAssist#sidemenu#Close(menuName)
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
