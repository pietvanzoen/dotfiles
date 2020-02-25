
function! CurrentWorkingDir()
  return split(getcwd(), '/')[-1]
endfunction
