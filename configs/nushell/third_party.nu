
source ./ubuntu_alias.nu

# Third Party tools

$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional

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

#
# Kubernetes utils
#

alias kget = kubectl get
alias kpods = kubectl get pods --all-namespaces
def klogs [$pod] {
  
  let pod_details = kubectl get pods --all-namespaces -o json 
      | from json 
      | get items 
      | where {|x| $x.metadata.name | str contains $pod} 
      | first
  kubectl logs -n $pod_details.metadata.namespace -f $pod_details.metadata.name
}

#
# Quality of Life shortcuts to make development easier
#

alias ac = autoninja chrome
alias aclow = autoninja chrome -j 300
alias a = autoninja 

alias gen_clangd = vpython3 "tools/clang/scripts/generate_compdb.py" -o "compile_commands.json" -p

def ehost [] {
  let path = (
    if ($nu.os-info.name == "windows") {
      "C:\\Windows\\System32\\drivers\\etc\\hosts"
    } else {
      "/etc/hosts"
    }
  )
  sudo nvim $path
}
