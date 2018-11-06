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
  call win_gotoid(1000)
  call setline(1, sequences)
  call win_gotoid(1001)
  call setline(1, comments)
  call win_gotoid(id)
endfunction

function s:setup_splits()
  vnew
  vertical resize 10
  windo setlocal nowrap scrollbind
  autocmd VimEnter * wincmd l
  autocmd WinEnter * if !win_id2win(1000) || !win_id2win(1001) | quitall! | endif
endfunction

call s:main()
