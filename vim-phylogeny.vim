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

function s:on_read_file(filetype, comments, sequences)
  let &l:filetype = a:filetype
  let s:comments = a:comments
  call s:update_names()
  call s:update_window(1000, a:sequences)
  execute 'autocmd BufWriteCmd <buffer> call s:write_' . a:filetype . '()'
endfunction

function s:read_fasta()
  let comments = []
  let sequences = []
  for line in readfile(expand('%'))
    if line !~ '^\s*$'
      if line =~ '^[>;]'
        call add(comments, substitute(line, '^[>;]\s*', '', ''))
        call add(sequences, '')
      else
        let sequences[len(comments) - 1] .= line
      endif
    endif
  endfor
  call s:on_read_file('fasta', comments, sequences)
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
  call s:update_window(1001, map(copy(s:comments), 'split(v:val, "", 1)[0]'))
endfunction

function s:update_window(id, lines)
  let id = win_getid()
  call win_gotoid(a:id)
  setlocal nowrap
  setlocal scrollbind
  if a:id == 1001
    setlocal modifiable
    setlocal readonly
  endif
  %delete _
  call setline(1, a:lines)
  if a:id == 1001
    setlocal nomodifiable
  endif
  call win_gotoid(id)
endfunction

function s:write_fasta()
  call writefile([], expand('%'))
  for index in range(0, len(s:comments) - 1)
    call writefile(['>' . s:comments[index]], expand('%'), 'a')
    let sequence = getline(index + 1)
    for index in range(0, len(sequence) - 1, 70)
      call writefile([sequence[index:index + 70 - 1]], expand('%'), 'a')
    endfor
  endfor
  setlocal nomodified
endfunction

call s:main()
