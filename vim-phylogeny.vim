function s:main()
  call s:setup_splits()
  autocmd BufReadCmd *.fa,*.faa,*.fas,*.fasta,*.ffn,*.fna,*.frn,*.fsa,*.seq call s:read_fasta()
endfunction

function s:read_fasta()
  let names = []
  let sequences = []
  for line in readfile(expand('%'))
    if line !~ '^\s*$'
      if line =~ '^[>;]'
        call add(names, substitute(line, '^[>;]\s*', '', ''))
        call add(sequences, '')
      else
        let sequences[len(names) - 1] .= line
      endif
    endif
  endfor
  call s:update_windows(sequences, names)
endfunction

function s:setup_splits()
  autocmd VimEnter * wincmd l
  autocmd WinEnter * if !win_id2win(1000) || !win_id2win(1001) | quitall! | endif
  highlight VertSplit cterm=NONE gui=NONE term=NONE
  set fillchars+=vert:│
  set laststatus=0
  vnew
endfunction

function s:update_window(id, lines)
  call win_gotoid(a:id)
  setlocal nowrap
  setlocal scrollbind
  %delete _
  call setline(1, a:lines)
endfunction

function s:update_windows(sequences, names)
  let id = win_getid()
  call s:update_window(1000, a:sequences)
  call s:update_window(1001, a:names)
  vertical resize 10
  call win_gotoid(id)
endfunction

call s:main()
