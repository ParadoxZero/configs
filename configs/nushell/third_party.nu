
# Third Party tools
zoxide init nushell | save -f ~/.zoxide.nu
source ~/.zoxide.nu

# 
# The Following alias expects a couple of dependencies
# fzf, ripgrep and chromium/edge checkout

# Set your preferred editor for opening files

# Function for efficient fzf usage
def f [$query] { fzf -q $query }
def fc [$query] { fzf -q $query --preview "type {}" | str trim | ^($env.EDITOR) $in }
def fbranch [] { git branch | fzf | str trim | git checkout  $in }
def dbranch [] { git branch | fzf | str trim | git branch -D $in }
def fcd [$query] { fzf -q $query --preview "dir {}" | str trim | ^($env.EDITOR) $in }

# Combine ripgrep with fzf to search and open files in huge codebases
def frg [$query] { rg --files-with-matches $query | fzf --preview "batcat {}" }
def fnv [$query] { fzf -q $query | nvim $in }
alias rcpp =  rg -tcpp 
alias rjs =  rg -tjs 
