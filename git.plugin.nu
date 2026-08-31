###################################
#         Git shortcuts           #
###################################

def g [...args] {
    git ...$args
}

def ga [...args] {
    git add ...$args
}

def gaa [] {
    git add --all
}

def gai [...args] {
    git add --interactive ...$args
}

def gam [message] {
    # Amend commit; modify commit message, optionally 'git add' files
    git commit --amend -m $message
}

def gama [message] {
    # Amend commit; modify commit message, and add all modified files
    git commit --amend -am $message
}

def gan [] {
    # Amend commit; keep commit message, optionally 'git add' files
    git commit --amend --no-edit
}

def gana [] {
    # Amend commit; keep commit message, and add all modified files
    git commit --amend --no-edit -a
}

def gap [...args] {
    git add --patch ...$args
}

def gb [...args] {
    git branch ...$args
}

def gba [] {
    # List all branches
    git branch --all
}

def gbd [...args] {
    git branch --delete ...$args
}

def gbdf [...args] {
    git branch --delete --force ...$args
}

def gbl [...args] {
    git blame ...$args
}

def gbls [] {
    # List all branches
    git branch --all
}

def gbs [...args] {
    git bisect ...$args
}

def gbsb [...args] {
    git bisect bad ...$args
}

def gbsg [...args] {
    git bisect good ...$args
}

def gbsr [] {
    git bisect reset
}

def gbss [] {
    git bisect start
}

def gc [...args] {
    git commit --verbose ...$args
}

def gcam [...args] {
    git commit -am ...$args
}

def gcame [] {
    git commit --allow-empty-message -am ""
}

def gcamg [...args] {
    git commit --gpg-sign -am ...$args
}

def gcams [...args] {
    git commit --signoff -am ...$args
}

def gcamu [] {
    git commit -am "Update"
}

def gcem [...args] {
    # Create empty commit for testing CI/CD
    git commit --allow-empty -m ...$args
}

def gcf [...args] {
    git config ...$args
}

def gcfg [...args] {
    git config --global ...$args
}

def gcfl [...args] {
    git config --local ...$args
}

def gcfls [...args] {
    git config --list ...$args
}

def gcl [url, path?] {
    # Git clone and cd into project
    if ($path != null) {
        git clone --recurse-submodules $url $path
        cd $path
    } else {
        git clone --recurse-submodules $url
        cd ($url | path parse | get stem)
    }
}

def gcm [...args] {
    git commit -m ...$args
}

def gcmg [...args] {
    git commit --gpg-sign -m ...$args
}

def gcms [...args] {
    git commit --signoff -m ...$args
}

def gcnt [] {
    # Count commits on current branch
    git shortlog -sn
    echo "  + ___________________________________"
    echo "    (git rev-list --count HEAD) commits total up to current HEAD"
}

def gco [...args] {
    git checkout ...$args
}

def gcob [...args] {
    git checkout -b ...$args
}

def gcobb [] {
    # Checkout previous branch
    git checkout -
}

def gcoc [count = 1] {
    # Checkout child commit
    # Usage: gcoc = gcoc 1 => direct child; gcoc 2 => grandchild
    let children = (git log --all --ancestry-path ^HEAD --format=format:%H | lines)
    if ($children | is-empty) {
        echo "This commit does not have any children, HEAD remains at:"
        git log -1 --oneline
        return
    }

    mut child = ($children | last $count | first)
    if ($children | length) <= $count {
        let branches = (git branch --contains $child | each { |it| $it | str trim | str replace '*' '' } | str join ' ')
        if ($branches | str contains ' ') == false {
            $child = $branches
        }
    }

    git checkout $child
}

def gcod [] {
    git checkout develop
}

def gcof [...args] {
    git checkout -f ...$args
}

def gcom [] {
    git checkout (git_main_branch)
}

def gcop [count = 1] {
    # Checkout parent commit
    # Usage: gcop = gcop 1 => direct parent; gcop 2 => grandparent
    git checkout $"HEAD~($count)"
}

def gcp [...args] {
    git cherry-pick ...$args
}

def gcpa [] {
    git cherry-pick --abort
}

def gcpc [] {
    git cherry-pick --continue
}

def gcpq [] {
    git cherry-pick --quit
}

def gcps [] {
    git cherry-pick --skip
}

def gd [...args] {
    git diff ...$args
}

def gds [...args] {
    git diff --staged ...$args
}

def gdst [...args] {
    # Show diff between latest stash and working tree
    git diff 'stash@{0}' ...$args
}

def gdsth [] {
    # Show diff between latest stash and HEAD
    git diff 'stash@{0}' HEAD
}

def gdstp [] {
    # Show diff between latest stash and its parent
    git diff 'stash@{0}^' 'stash@{0}'
}

def gf [...args] {
    git fetch ...$args
}

def gfo [...args] {
    git fetch origin ...$args
}

def gg [...args] {
    # Git graph (all commits)
    git log --graph --all --date=format:"%d/%m/%Y" --format=format:"%C(yellow)%h%Creset%x09%C(dim white)%an%Creset%x09%C(bold green)%D%Creset%n%C(white)%ad%Creset%x09%C(bold)%s%Creset%n" ...$args
}

def ggb [...args] {
    # Git graph branches
    gg "--simplify-by-decoration" ...$args
}

def ggbo [...args] {
    # Git graph branches --oneline
    ggo "--simplify-by-decoration" ...$args
}

def ggo [...args] {
    # Git graph --oneline (all commits)
    git log --graph --all --date=format:"%d/%m/%Y" --format=format:"%C(yellow)%h%Creset   %C(white)%ad%Creset   %C(bold)%s   %C(bold green)%D%Creset%n" ...$args
}

def gig [...args] {
    # Ignore tracked files
    git update-index --skip-worktree ...$args
}

def gug [...args] {
    # Unignore files
    git update-index --no-skip-worktree ...$args
}

def glsig [] {
    # List ignored files
    git ls-files -v | where $it =~ '^S'
}

def gl [] {
    # Git log --name-status (defaults to last 10 commits)
    glog 10
}

def glo [] {
    # Git log --oneline
    git log --date=format:"%d/%m/%Y" --format=format:"%C(yellow)%h%Creset   %C(white)%ad%Creset   %C(bold)%s   %C(bold green)%D%Creset"
}

def glog [count?: int, ...args] {
    # Git log with formatting; defaults to full log, pass count for N commits
    echo ""
    if ($count != null) {
        git log $"-($count)" --reverse --name-status --date=format:"%A %B %d %Y at %H:%M" --format=format:"%C(yellow)%H%Creset%x09%C(bold green)%D%Creset%n%<|(40)%C(white)%ad%x09%an%Creset%n%n    %C(bold)%s%Creset%n%w(0,4,4)%n%-b%n" ...$args
    } else {
        git log --reverse --name-status --date=format:"%A %B %d %Y at %H:%M" --format=format:"%C(yellow)%H%Creset%x09%C(bold green)%D%Creset%n%<|(40)%C(white)%ad%x09%an%Creset%n%n    %C(bold)%s%Creset%n%w(0,4,4)%n%-b%n" ...$args
    }
    echo ""
}

def glsb [] {
    # List all branches
    git branch --all
}

def glsf [] {
    # List tracked files
    git ls-files
}

def glsr [] {
    # List remotes
    git remote -v
}

def glss [] {
    # List submodules
    git config --file .gitmodules --name-only --get-regexp path
}

def glsst [...args] {
    # List stashes
    git stash list ...$args
}

def glst [...args] {
    # List tags
    git tag --list ...$args
}

def gm [...args] {
    git merge ...$args
}

def gmnff [...args] {
    git merge --no-ff ...$args
}

def gmom [] {
    git merge $"origin/(git_main_branch)"
}

def gmum [] {
    git merge $"upstream/(git_main_branch)"
}

def gmv [...args] {
    git mv ...$args
}

def gph [...args] {
    git push ...$args
}

def gphd [...args] {
    # Delete remote branch
    git push --delete ...$args
}

def gphdo [...args] {
    # Delete branch from origin
    git push --delete origin ...$args
}

def gphf [...args] {
    git push --force-with-lease ...$args
}

def gphff [...args] {
    git push --force ...$args
}

def gpht [] {
    git push
    if ($env.LAST_EXIT_CODE == 0) {
        git push --tags
    }
}

def gphu [...args] {
    # Set upstream branch
    git push -u ...$args
}

def gphuo [...args] {
    # Set origin as upstream
    git push -u origin ...$args
}

def gphuom [] {
    # Set origin/main as upstream
    git push -u origin main
}

def gpl [...args] {
    git pull ...$args
}

def gpla [...args] {
    # Pull with autostash
    git pull --autostash ...$args
}

def gplr [...args] {
    git pull --rebase ...$args
}

def gplrs [...args] {
    git pull --recurse-submodules ...$args
}

def gr [...args] {
    git reset ...$args
}

def grh [count, ...args] {
    # git reset HEAD
    # Usage: grh 1 => reset HEAD to previous commit; grh 2 => 2 commits back
    git reset $"HEAD~($count)" ...$args
}

def grhard [...args] {
    # Hard reset (dangerous: removes uncommitted changes)
    git reset --hard ...$args
}

def grhhard [count = 1] {
    # Hard reset HEAD
    grh $count "--hard"
}

def grhk [count = 1] {
    # Keep reset HEAD (aborts if dirty files)
    grh $count "--keep"
}

def grhs [count = 1] {
    # Soft reset HEAD
    grh $count "--soft"
}

def grk [...args] {
    # Keep reset (safer than --hard; aborted if dirty files)
    git reset --keep ...$args
}

def grs [...args] {
    # Soft reset
    git reset --soft ...$args
}

def grb [...args] {
    git rebase ...$args
}

def grbm [] {
    git rebase (git_main_branch)
}

def gre [...args] {
    git restore ...$args
}

def grea [] {
    # Restore all (throw away uncommitted changes)
    git restore .
}

def greh [path, count = 1] {
    # Restore from HEAD
    git restore $"--source=HEAD~($count)" $path
}

def grem [...args] {
    git remote ...$args
}

def grema [...args] {
    # Add remote
    git remote add ...$args
}

def gremao [...args] {
    # Add origin remote
    git remote add origin ...$args
}

def gremls [] {
    # List remotes
    git remote -v
}

def gremrm [...args] {
    # Remove remote
    git remote rm ...$args
}

def gremrmo [] {
    # Remove origin
    git remote rm origin
}

def gremset [...args] {
    # Set remote URL
    git remote set-url ...$args
}

def gremseto [...args] {
    # Set origin URL
    git remote set-url origin ...$args
}

def gremsh [...args] {
    git remote show ...$args
}

def gremv [] {
    # List remotes
    git remote -v
}

def grl [...args] {
    git reflog ...$args
}

def grm [...args] {
    git rm ...$args
}

def gs [...args] {
    git status ...$args
}

def gsh [...args] {
    git show ...$args
}

def gss [] {
    git status --short
}

def gst [...args] {
    git stash ...$args
}

def gsta [...args] {
    git stash apply ...$args
}

def gstd [...args] {
    git stash drop ...$args
}

def gstls [...args] {
    git stash list ...$args
}

def gstph [...args] {
    git stash push ...$args
}

def gstpp [...args] {
    git stash pop ...$args
}

def gstshl [] {
    # Show stash diff
    git stash show -l
}

def gstshp [] {
    # Show stash patch
    git stash show -p
}

def gsub [...args] {
    git submodule ...$args
}

def gsuba [...args] {
    git submodule add ...$args
}

def gsubi [...args] {
    # Initialize submodules
    git submodule update --init ...$args
}

def gsubf [...args] {
    git submodule foreach ...$args
}

def gsubfpl [] {
    git submodule foreach git pull
}

def gsubfplom [] {
    git submodule foreach git pull origin (git_main_branch)
}

def gsubs [...args] {
    git submodule status ...$args
}

def gsubu [...args] {
    # Update submodules
    git submodule update --remote --merge ...$args
}

def gt [...args] {
    git tag ...$args
}

def gtam [...args] {
    # Annotated tag with message
    git tag -am ...$args
}

def gtd [...args] {
    git tag --delete ...$args
}

def gtls [...args] {
    git tag --list ...$args
}

def gtsm [...args] {
    # GPG signed tag
    git tag -sm ...$args
}


########################################
#         Git Utility Functions        #
########################################

def git_main_branch [] {
    # Check if main branch exists, otherwise use master branch
    let branches = (git branch --list main | lines)
    if ($branches | length) > 0 {
        "main"
    } else {
        "master"
    }
}
