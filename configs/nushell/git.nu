
# Small git-based productivity functions
alias branch = git branch
alias checkout = git checkout
alias status = git status 
alias ga = git add 
def pull [] {git branch --show-current | git pull origin $in}
alias gc = git commit -m
alias git_reset = git reset --hard HEAD
alias clean = git clean -fd
alias log = git log --oneline --decorate -n 5

def update_main [] { 
    git stash push;
    git checkout main; 
    git pull origin main; 
} 

def rebase_branch [] {
    git fetch origin main;
    git rebase FETCH_HEAD;
}

def print_git_user [] {
  git config user.email 
  git config user.name
}

def git_email [$email] {
  git config --worktree user.email $email
  echo "Updated to - "
  print_git_user 
}

def git_id [$type] {
  if $type == "versa" {
    git_email "sidhin.t@versa-networks.com"
  }
  if $type == "gmail" {
    git_email "sidhin.thomas@gmail.com" 
  }
  if $type == "outlook" {
    git_email "thomas.sidhin@outlook.com"
  }
}
