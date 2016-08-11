Install the Z Shell:
  cmd.run:
    - name: brew install zsh zsh-completions

Install OMZ using insecure method:
  cmd.run:
    - name: |
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

Enable OMZ plugins:
  file.blockreplace:
    - name: "/Users/{{ salt['environ.get']('USER') }}/.zshrc"
    - marker_start: "# SALT BLOCK TOP : omz_plugins"
    - marker_end: "# SALT BLOCK BOT : omz_plugins"
    - content: |
        plugins=({{ pillar['zsh']['omz']['plugins'] | join(' ') }})
    - show_changes: True
    - append_if_not_found: True

