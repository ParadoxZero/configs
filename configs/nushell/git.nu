
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
