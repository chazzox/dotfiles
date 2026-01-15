alias lsd "eza --icons -alh $argv"
alias comp "cd ~/code/RHUL/year-3/cs3920-final-year-project/source-code"

git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

alias catimg "kitten icat $argv"

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
# complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'

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

# Syntax Highlighting Colors
set -g fish_color_normal $foreground
set -g fish_color_command $cyan
set -g fish_color_keyword $pink
set -g fish_color_quote $yellow
set -g fish_color_redirection $foreground
set -g fish_color_end $orange
set -g fish_color_option $pink
set -g fish_color_error $red
set -g fish_color_param $purple
set -g fish_color_comment $comment
set -g fish_color_selection --background=$selection
set -g fish_color_search_match --background=$selection
set -g fish_color_operator $green
set -g fish_color_escape $pink
set -g fish_color_autosuggestion $comment

# Completion Pager Colors
set -g fish_pager_color_progress $comment
set -g fish_pager_color_prefix $cyan
set -g fish_pager_color_completion $foreground
set -g fish_pager_color_description $comment
set -g fish_pager_color_selected_background --background=$selection
