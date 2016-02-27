let $PLUGIN_ROOT = expand("<sfile>:p:h:h")

function! SerializeToFile(var, file)
  call writefile([string(a:var)], a:file)
endfunction

function! DeserializeFromFile(file)
  let payload = readfile(a:file)[0]
  execute "let deserialized = " . payload
  return deserialized 
endfunction

let current_git_root = system("git rev-parse --show-toplevel")
if strlen(current_git_root)
  let repo_vimrc = current_git_root[:-2] . "/.vimrc"
  if filereadable(repo_vimrc)
    let repo_vimrc = fnamemodify(repo_vimrc, ":p")
    let state_file_path = $PLUGIN_ROOT . "/statefile"
    if filereadable(state_file_path)
      let ok_files = DeserializeFromFile(state_file_path) 
    else
      let ok_files = []
    endif

    if index(ok_files, repo_vimrc) != -1
      execute "source " . repo_vimrc
    else
      let choice = confirm("Load " . repo_vimrc, "&Yes\n&No")
      if choice == 1 
        call add(ok_files, repo_vimrc)
        call SerializeToFile(ok_files, state_file_path)
        execute "source " . repo_vimrc
      endif
    endif
  endif
endif
