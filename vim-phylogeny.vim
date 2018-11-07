function s:edit_comment(index)
  let view = winsaveview()
  silent split `=tempname()`
  resize 3
  setlocal nobuflisted
  setlocal statusline=[Comment]
  call setline(1, s:comments[a:index])
  let id = s:select_window(1000)
  call winrestview(view)
  call win_gotoid(id)
  let b:index = a:index
  autocmd BufWriteCmd <buffer> call s:update_comment(b:index, join(getline(0, '$'), ' ')) | close!
endfunction

function s:main()
  call s:setup_windows()
  autocmd BufReadCmd *.fa,*.faa,*.fas,*.fasta,*.ffn,*.fna,*.frn,*.fsa,*.seq call s:read_fasta(expand('%'))
  autocmd VimEnter * nmap <silent> gc :call <SID>edit_comment(line('.') - 1)<CR>
endfunction

function s:on_read_file(filetype, comments, sequences)
  let &l:filetype = a:filetype
  call s:update_comments(a:comments)
  call s:update_window(1000, a:sequences)
  execute 'autocmd BufWriteCmd <buffer> call s:write_' . a:filetype . '(expand("%"), s:comments)'
endfunction

function s:on_write_file(path)
  setlocal nomodified
  echomsg '"' . a:path . '" written'
endfunction

function s:read_fasta(path)
  let comments = []
  let sequences = []
  if filereadable(a:path)
    for line in readfile(a:path)
      if line !~ '^\s*$'
        if line =~ '^[>;]'
          call add(comments, substitute(line, '^[>;]\s*', '', ''))
          call add(sequences, '')
        else
          let sequences[len(comments) - 1] .= line
        endif
      endif
    endfor
  endif
  call s:on_read_file('fasta', comments, sequences)
endfunction

function s:select_window(id)
  let id = win_getid()
  call win_gotoid(a:id)
  return id
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

function s:update_comment(index, comment)
  let s:comments[a:index] = a:comment
  call s:update_comments(s:comments)
  let id = s:select_window(1000)
  setlocal modified
  call win_gotoid(id)
endfunction

function s:update_comments(comments)
  let s:comments = a:comments
  call s:update_window(1001, map(copy(a:comments), 'split(v:val, "", 1)[0]'))
endfunction

function s:update_window(id, lines)
  let id = s:select_window(a:id)
  setlocal nowrap
  setlocal scrollbind
  if a:id == 1000
    let undo_levels = &undolevels
    setlocal undolevels=-1
  elseif a:id == 1001
    setlocal modifiable
    setlocal readonly
  endif
  %delete _
  call setline(1, a:lines)
  if a:id == 1000
    let &l:undolevels = undo_levels
  elseif a:id == 1001
    setlocal nomodifiable
  endif
  call win_gotoid(id)
endfunction

function s:write_fasta(path, comments)
  call writefile([], a:path)
  for index in range(0, len(a:comments) - 1)
    call writefile(['>' . a:comments[index]], expand('%'), 'a')
    let sequence = getline(index + 1)
    for index in range(0, len(sequence) - 1, 70)
      call writefile([sequence[index:index + 70 - 1]], a:path, 'a')
    endfor
  endfor
  call s:on_write_file(a:path)
endfunction

call s:main()
