function s:main()
  call s:setup_splits()
  autocmd BufReadCmd * call s:read_fasta(expand('%'))
endfunction

function s:read_fasta(path)
  for line in readfile(a:path)
    if line !~ '^\s*$'
    endif
  endfor
endfunction

function s:setup_splits()
  vsplit
  vertical resize 10
  autocmd VimEnter * wincmd l
endfunction

call s:main()
