let current_git_root = system("git rev-parse --show-toplevel")
let repo_vimrc = current_git_root[:-2] . "/.vimrc"
if filereadable(repo_vimrc)
    execute 'sandbox source ' . repo_vimrc
endif
