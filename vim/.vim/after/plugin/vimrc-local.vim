" Load .vimrc.local if it's available

function! GetCurrentGitProject() abort
  return substitute(system('git rev-parse --show-toplevel 2>/dev/null'), '\n$', '', '')
endfunction

function! ReloadLocalVimrc(warn) abort
  let l:git_path = GetCurrentGitProject()
  let l:git_vimrc = substitute(l:git_path, '\n', '', '') . '/.vimrc.local'
  if !empty(glob(l:git_vimrc))
    sandbox exec ':source ' . l:git_vimrc
  else
    if a:warn
      call ErrorMessage('.vimrc.local not found in this repo')
    endif
  endif
endfunction

command! ReloadLocalVimrc call ReloadLocalVimrc(1)

call ReloadLocalVimrc(0)
