# Source this from your .bashrc (or .zshrc, etc.) to get useful functionality
# for doing git stuff.

# NOTE: If you want to change these values, do so in your .bashrc after sourcing
# this file.
export MAIN_REPO_NAME=upstream
export MY_REPO_NAME=origin
export BASE_BRANCH_NAME=main

# Run mainb to check out the latest base branch. The submodule update is
# currently unused, but might be needed in the future.
alias mainb='git checkout $BASE_BRANCH_NAME && git pull --ff-only $MAIN_REPO_NAME $BASE_BRANCH_NAME && git submodule update'

# Run `newbranch name_of_new_branch` to create a new branch with the given name
# which is based off of the latest base.
alias newbranch='mainb && git checkout -b'

# Run `delete name_of_old_branch` to delete the named branch both locally and on
# github.
delete() {
    if [[ "$1" == "$BASE_BRANCH_NAME" ]]; then
        echo "ERROR: Don't delete $BASE_BRANCH_NAME."
        return 1
    else
        git branch -D $1 && git push $MY_REPO_NAME --delete $1
    fi
}

# Run `deletecurrentbranch` to check out the latest main branch and delete the branch that you had
# been on previously.
deletecurrentbranch() {
    tmp_current_branch=$(git symbolic-ref --short HEAD)
	mainb
	delete "$tmp_current_branch"
}

# Run `commit "description of changes"` to create a commit of all modified files
commit() {
    tmp_current_branch=$(git symbolic-ref --short HEAD)
    if [[ "$tmp_current_branch" == "$BASE_BRANCH_NAME" ]]; then
        echo "ERROR: Don't commit things on $BASE_BRANCH_NAME."
        return 1
    else
        git commit -a -m $1
    fi
}

# Run gamend to amend the most recent git commit with all subsequent changes
# and force-push these updates to github.
gamend () {
    tmp_current_branch=$(git symbolic-ref --short HEAD)
    if [[ "$tmp_current_branch" == "$BASE_BRANCH_NAME" ]]; then
        echo "ERROR: Don't commit things on $BASE_BRANCH_NAME."
        return 1
    else
        git commit -a --amend && \
            git push $MY_REPO_NAME $(git symbolic-ref --short HEAD) --force-with-lease
    fi
}

# Run push to push the currently checked-out feature branch to your repo. This
# will force-push local changes unless they'd overwrite someone else's changes
# to the remote server, so you can update the remote branch even if you've
# just gone through a rebase.
push() {
	if [[ "$MY_REPO_NAME" == "$MAIN_REPO_NAME" ]]; then
		tmp_current_branch=$(git symbolic-ref --short HEAD)
		if [[ "$tmp_current_branch" == "$BASE_BRANCH_NAME" ]]; then
			echo "WARNING: Think carefully about pushing $BASE_BRANCH_NAME."
			return 1
		fi
	fi
	git push $MY_REPO_NAME $(git symbolic-ref --short HEAD) --force-with-lease
}

# Pulls the current branch from github, assuming its history has not been
# rewritten (otherwise has an error warning you that pulling might not be a good
# idea). Use this if you're working on the branch on multiple computers (e.g.,
# you forgot to bring your work laptop home).
alias pull='git pull --ff-only $MY_REPO_NAME $(git symbolic-ref --short HEAD) && git submodule update'

# Use rebase to pull the latest base branch into your branch. This rewrites
# the current branch's history, but keeps the merge history very clean so it can
# easily be modified later. If you have already pushed this branch to github,
# you'll need to force-push next time (which is done automatically if you use
# `push`). The submodule update is currently unused but might become important
# in the future.
alias rebase='git pull --rebase $MAIN_REPO_NAME $BASE_BRANCH_NAME && git submodule update'

# Run squash to interactively rebase the current branch, with the option of
# squashing commits together as you go, and then force-push this branch to
# github. This is particularly useful if you want to have `gamend`-like behavior
# for a commit that is not the most recent.
squash() {
    tmp_current_branch=$(git symbolic-ref --short HEAD)
    if [[ "$tmp_current_branch" == "$BASE_BRANCH_NAME" ]]; then
        echo "ERROR: Don't squash $BASE_BRANCH_NAME."
        return 1
    else
        git rebase -i "$MAIN_REPO_NAME/$BASE_BRANCH_NAME" && \
            git push $MY_REPO_NAME --force-with-lease $(git symbolic-ref --short HEAD)
    fi
}

# Run `cherry-pit sha_of_commit_to_remove` to remove a commit from the current
# branch. Note that this rewrites the branch's history, so you'll need to
# force-push to github if you've pushed to github before (this is done
# automatically if you use `push`).
cherry-pit () {
    tmp_current_branch=$(git symbolic-ref --short HEAD)
    if [[ "$tmp_current_branch" == "$BASE_BRANCH_NAME" ]]; then
        echo "ERROR: Don't change the history of $BASE_BRANCH_NAME."
        return 1
    else
        # FMI, https://sethrobertson.github.io/GitFixUm/fixup.html#remove_deep
        git rebase --rebase-merges --onto $1^ $1
    fi
}

# Removes deleted branches from git's tab-completion system.
alias gcleanup='git fetch --prune --all'

# Shorthands for common tools:
alias gd='git difftool' # Shows a diff of the current unstaged changes
alias gst='git status' # Lists files with changes, both staged and unstaged
alias gb='git branch' # Lists valid branches and says which one is checked out
alias gc='git checkout' # e.g., `gc main` to check out the main branch
alias gcont='git rebase --continue' # Use this after you've resolved conflicts
