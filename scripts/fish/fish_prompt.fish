
# Fish function
function my_git
    set GIT_BRANCH (git branch --all 2>/dev/null | egrep "^\*" | cut -d ' ' -f 2)

    if test -z "$GIT_BRANCH"
        echo ""  # not in a Git repo
    else
        if test (git status | egrep "^Untracked" -c) -ge 1
            # ANSI code: Red
            echo -e "(\033[0;31m$GIT_BRANCH\033[0m) "
        else if test (git status | egrep "^Changes" -c) -ge 1
            # ANSI code: Yellow
            echo -e "(\033[0;33m$GIT_BRANCH\033[0m) "
        else
            # ANSI code: Green
            echo -e "(\033[0;32m$GIT_BRANCH\033[0m) "
        end
    end
end

# Prompt function (fish doesn't use PS1 — it uses fish_prompt)

function fish_prompt
    set_color normal
    echo -n (whoami)"@"(hostname)":"(prompt_pwd)"\$ "(my_git)
end
