function lsd 
  eza --icons -alh $argv
end
function ra; tmux attach-session -d -t base; end
function ran; tmux new-session -d -s base; end
function glow; GLOW -p; end
function latexindent.pl; latexindent; end

function ls
  command eza $argv --icons 
end

if not set -q TMUX 
   and test "$TERM_PROGRAM" != "vscode" 
   and test "$TERM_PROGRAM" != "Jetbrains.Fleet"
   and test "$TERM_PROGRAM" != "intellij"
   and test "$TERM_PROGRAM" != "\"intellij\""
   and test "$TERM_PROGRAM" != "OpenLens"
    set -g TMUX ran
    eval $TMUX
	ra
end


set -gx CPATH "/Library/Developer/CommandLineTools/SDKs/MacOSX11.1.sdk/System/Library/Perl/5.28/darwin-thread-multi-2level/CORE"
set -gx EDITOR "nvim"

# jfrog env settings 
set -gx EMAIL "charlie.aylott@matillion.com"
set -gx JFROG_PLATFORM_READ_USER "$EMAIL"
set -gx JFROG_PLATFORM_READ_TOKEN "eyJ2ZXIiOiIyIiwidHlwIjoiSldUIiwiYWxnIjoiUlMyNTYiLCJraWQiOiJoaHEweEZza1dpaElFdUNscFozamJZM0Z2cUthMndYUkJMWVl3eDdoN19rIn0.eyJzdWIiOiJqZmFjQDAxZmp2OHM0OHEyNGRuMXhuN2pyYW0wMjZ6L3VzZXJzL2NoYXJsaWUuYXlsb3R0QG1hdGlsbGlvbi5jb20iLCJzY3AiOiJhcHBsaWVkLXBlcm1pc3Npb25zL3VzZXIiLCJhdWQiOiIqQCoiLCJpc3MiOiJqZmFjQDAxZmp2OHM0OHEyNGRuMXhuN2pyYW0wMjZ6IiwiZXhwIjoxNzIxMzEyODYwLCJpYXQiOjE2ODk3NzY4NjAsImp0aSI6IjRkZGY3ZDIwLTc3OTktNDIzNC1iMTcwLWZlYWI3NDQzNjk3MyJ9.cQdY93_JORid-i7QDMRZwvKuzd_rbeiWoR_GPrqcJ-EgqTpoVyf3r87hWMOHohgj7Wodyvc8QdRo77tYTFjlt_Om6e7N7qta29__uLoOQNUHxCYVLz_zi_Z7M0bNTt942VzU8p8d5BM0wn-U-eZhL7dzsOJ7nJPHsq4IgA8pvEgSWcs1q_Kj454RZCK9ysi_5vxf5m1PckV0arkIAvODz2RZiGlHI3T_e6VP8efp0_weMYf0fFw5H_8SEpqmQNB9hLgmPRb3jRODZGXrjKJeKue5fzX8JN9cpTSQvW8UaEv5sApVnzZ_ur1jKgn7ef06yFYzav3KsccRsvPKypyYyA"
set -gx JFROG_PLATFORM_READ_TOKEN_BASE64 "$(echo -n $JFROG_PLATFORM_READ_TOKEN | base64)" 

set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin

fish_add_path /Users/charlie/.spicetify

oh-my-posh --init --shell fish --config ~/mytheme.omp.json | source
pyenv init - | source
source (pack completion --shell fish)

# pnpm
set -gx PNPM_HOME "/Users/charlie/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
