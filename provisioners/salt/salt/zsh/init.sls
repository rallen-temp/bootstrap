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

Enable your OMZ theme:
  file.line:
    - name: "/Users/{{ salt['environ.get']('USER') }}/.zshrc"
    - match: ZSH_THEME=["'][a-zA-Z0-9\-]*["']
    - mode: Replace
    - content: "ZSH_THEME='{{ salt['pillar.get']('zsh:omz:theme', 'robbyrussell') }}'"
    - show_changes: True

Set Homebrew Github API Token:
  file.blockreplace:
    - name: "/Users/{{ salt['environ.get']('USER') }}/.zshrc"
    - marker_start: "# SALT BLOCK TOP : userenv : zshrc"
    - marker_end: "# SALT BLOCK BOT : userenv : zshrc"
    - content: |
        export HOMEBREW_GITHUB_API_TOKEN='{{ pillar['userenv']['HOMEBREW_GITHUB_API_TOKEN'] }}'
    - append_if_not_found: True
