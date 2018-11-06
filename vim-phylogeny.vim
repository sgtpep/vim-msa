function s:main()
  call s:setup_splits()
  autocmd BufReadCmd *.fa,*.faa,*.fas,*.fasta,*.ffn,*.fna,*.frn,*.fsa,*.seq call s:read_fasta(expand('%'))
endfunction

function s:read_fasta(path)
  let comments = []
  let sequences = []
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
  let id = win_getid()
  call s:update_window(1000, sequences)
  call s:update_window(1001, comments)
  vertical resize 10
  call win_gotoid(id)
endfunction

function s:setup_splits()
  autocmd VimEnter * wincmd l
  autocmd WinEnter * if !win_id2win(1000) || !win_id2win(1001) | quitall! | endif
  highlight VertSplit cterm=NONE gui=NONE term=NONE
  set fillchars+=vert:│
  vnew
endfunction

function s:update_window(id, lines)
  call win_gotoid(a:id)
  setlocal nowrap scrollbind
  %delete _
  call setline(1, a:lines)
endfunction

call s:main()
