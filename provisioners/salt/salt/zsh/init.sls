Install the Z Shell:
  cmd.run:
    - name: brew install zsh zsh-completions

Install OMZ using insecure method:
  cmd.run:
    - name: |
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

Enable OMZ plugins:
  file.line:
    - name: "/Users/{{ salt['environ.get']('USER') }}/.zshrc"
    - match: 'plugins=\([a-zA-Z0-9\-\ ]*\)'
    - mode: Replace
    - content: "plugins=({{ pillar['zsh']['omz']['plugins'] | join(' ') }})"
    - show_changes: True
