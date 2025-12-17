alias lsd "eza --icons -alh $argv"
alias comp "cd ~/code/RHUL/year-3/dissertation-work/final-year-project/"

git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

function rhul_comp
    gcc -Wall -Werror -Wpedantic $argv
end

function progress-commit
    set -f commit_name (git rev-parse --abbrev-ref HEAD | tr '/' '\n' | sed -n 2p)
    read -p "set_color green; echo -n 'commit description'; set_color normal; echo -n ': '" commit_description
    git add .

    if not [ "$commit_description" ]
        set -f commit_description "progress commit"
    end

    if [ "$commit_name" ]
        set -f commit_name "($commit_name)"
    else
        set -f commit_name ""
    end
    git commit -am "feat$commit_name: $commit_description"
end

function ra
    tmux attach-session -d -t base
end
function ran
    tmux new-session -d -s base
end

function ls
    command eza $argv --icons
end

if not set -q TMUX
    and test "$TERM_PROGRAM" != vscode
    and test "$TERM_PROGRAM" != "Jetbrains.Fleet"
    and test "$TERM_PROGRAM" != intellij
    and test "$TERM_PROGRAM" != "\"intellij\""
    and test "$TERM_PROGRAM" != OpenLens
    and test "$TERMINAL_EMULATOR" != JetBrains-JediTerm
    set -g TMUX ran
    eval $TMUX
    ra
end

set -gx EDITOR nvim

set -Ux PYENV_ROOT $HOME/.pyenv

fish_add_path $PYENV_ROOT/bin
fish_add_path $HOME/bin

oh-my-posh --init --shell fish --config ~/mytheme.omp.json | source
pyenv init - | source
fnm env --use-on-cd | source

# aws completions
complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'

source (fnm completions --shell fish | psub)

# hold key to repeat system setting on macos
set -g sysName (uname)
if test "$sysName" = Darwin
    defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
end

glow completion fish | source

bind \cw backward-kill-word

set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME
set -gx PATH $HOME/.cabal/bin /Users/chazzox/.ghcup/bin $PATH # ghcup-env
