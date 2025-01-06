function lsd 
  eza --icons -alh $argv
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

function ra; tmux attach-session -d -t base; end
function ran; tmux new-session -d -s base; end

function glow; GLOW -p; end

function ls
  command eza $argv --icons 
end

if not set -q TMUX 
   and test "$TERM_PROGRAM" != "vscode" 
   and test "$TERM_PROGRAM" != "Jetbrains.Fleet"
   and test "$TERM_PROGRAM" != "intellij"
   and test "$TERM_PROGRAM" != "\"intellij\""
   and test "$TERM_PROGRAM" != "OpenLens"
   and test "$TERMINAL_EMULATOR" != "JetBrains-JediTerm"
    set -g TMUX ran
    eval $TMUX
	ra
end

set -gx EDITOR "nvim"

# source $HOME/.config/fish/work-secrets.fish

set -Ux PYENV_ROOT $HOME/.pyenv


fish_add_path $PYENV_ROOT/bin
fish_add_path $HOME/bin


oh-my-posh --init --shell fish --config ~/mytheme.omp.json | source
pyenv init - | source
fnm env --use-on-cd | source

# pnpm
set -gx PNPM_HOME "/Users/charlie/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# aws completions
complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'

# pack completions (docker image build system)
# source (pack completion --shell fish)

source (fnm completions --shell fish | psub)


set -g sysName (uname)
if test "$sysName" = "Darwin"
  defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
end

bind \cw backward-kill-word
