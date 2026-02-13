alias lsd "eza --icons -alh $argv"
alias comp "cd ~/code/RHUL/year-3/cs3920-final-year-project/source-code"
alias rhul "cd ~/code/RHUL/year-3/"
alias sc "source ~/.config/fish/config.fish"
alias dots_path "cd ~/code/dotfiles/"
alias dots "cd ~/code/dotfiles/"

git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias catimg "kitten icat $argv"

function rhul_comp
    gcc -Wall -Werror -Wpedantic $argv
end

function progress-commit
    # matches matillion ticket name i belive?
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

set -e ENABLE_TMUX

if set -q ENABLE_TMUX and not set -q TMUX and test "$TERM_PROGRAM" != vscode
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
fish_add_path $HOME/hlint-3.10/
# completions
oh-my-posh --init --shell fish --config ~/code/dotfiles/mytheme.omp.json | source

#path stuff

bind \cw backward-kill-word

# pnpm
set -gx PNPM_HOME /Users/chazzox/Library/pnpm
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

set -gx PATH "/Users/chazzox/.cargo/bin" $PATH

if set -q KITTY_INSTALLATION_DIR
    set --global KITTY_SHELL_INTEGRATION enabled
    source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
    set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"
end

# TokyoNight Color Palette
set -l foreground c0caf5
set -l selection 283457
set -l comment 565f89
set -l red f7768e
set -l orange ff9e64
set -l yellow e0af68
set -l green 9ece6a
set -l purple 9d7cd8
set -l cyan 7dcfff
set -l pink bb9af7

if test -d $HOME/.ghcup
    set --local ghcup $HOME/.ghcup

    if set --query GHCUP_INSTALL_BASE_PREFIX
        set ghcup $GHCUP_INSTALL_BASE_PREFIX/.ghcup
    end

    if test -f $ghcup/env && not contains -- $ghcup/bin $fish_user_paths
        fish_add_path --prepend --move --path $ghcup/bin
    end
end

contains -- $HOME/.cabal/bin $fish_user_paths
or fish_add_path --prepend --move --path $HOME/.cabal/bin

contains -- $HOME/.local/bin $fish_user_paths
or fish_add_path --prepend --move --path $HOME/.local/bin

# hold key to repeat system setting on macos
set -g sysName (uname)
if test "$sysName" = Darwin
    defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
    pyenv init - | source
    fnm env --use-on-cd | source
    source (fnm completions --shell fish | psub)
    glow completion fish | source
end
if test "$sysName" = MSys
    set -Ux XDG_CONFIG_HOME "$HOME/.config"
    source /c/ghcup/env
end

source ~/.config/fish/colors.fish
