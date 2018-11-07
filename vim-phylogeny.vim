function s:edit_comment()
  let index = line('.') - 1
  let view = winsaveview()
  silent split `=tempname()`
  resize 3
  setlocal nobuflisted
  setlocal statusline=[Comment]
  call setline(1, s:comments[index])
  let id = win_getid()
  call win_gotoid(1000)
  call winrestview(view)
  call win_gotoid(id)
  let b:index = index
  autocmd BufWriteCmd <buffer> let s:comments[b:index] = join(getline(0, '$'), ' ') | call s:update_names() | close!
endfunction

function s:main()
  call s:setup_windows()
  autocmd BufReadCmd *.fa,*.faa,*.fas,*.fasta,*.ffn,*.fna,*.frn,*.fsa,*.seq call s:read_fasta()
  autocmd VimEnter * nmap <silent> gc :call <SID>edit_comment()<CR>
endfunction

function s:read_fasta()
  let s:comments = []
  let sequences = []
  for line in readfile(expand('%'))
    if line !~ '^\s*$'
      if line =~ '^[>;]'
        call add(s:comments, substitute(line, '^[>;]\s*', '', ''))
        call add(sequences, '')
      else
        let sequences[len(s:comments) - 1] .= line
      endif
    endif
  endfor
  call s:update_names()
  call s:update_window(1000, sequences)
  setlocal filetype=fasta
  autocmd BufWriteCmd <buffer> call s:write_fasta()
endfunction

function s:setup_windows()
  highlight VertSplit cterm=NONE gui=NONE term=NONE
  set fillchars+=vert:│
  set laststatus=0
  vnew
  vertical resize 10
  setlocal nobuflisted
  setlocal statusline=[Comments]
  setlocal winfixwidth
  autocmd VimEnter * wincmd l
  autocmd WinEnter * if !win_id2win(1000) || !win_id2win(1001) | quitall! | endif
endfunction

function s:update_names()
  call s:update_window(1001, map(s:comments, 'split(v:val, "\s", 1)[0]'))
endfunction

function s:update_window(id, lines)
  let id = win_getid()
  call win_gotoid(a:id)
  setlocal nowrap
  setlocal scrollbind
  if a:id == 1001
    setlocal modifiable
    setlocal readonly
    vertical resize 10
  endif
  %delete _
  call setline(1, a:lines)
  if a:id == 1001
    setlocal nomodifiable
  endif
  call win_gotoid(id)
endfunction

function s:write_fasta()
  echo 'TODO'
endfunction

call s:main()
