Install iterm:
  cmd.run:
    - name: "brew cask install iterm2"

Download shell integration script for zsh:
  file.managed:
    - name: "/Users/{{ salt['environ.get']('USER') }}/.iterm2_shell_integration.zsh"
    - source: https://iterm2.com/misc/zsh_startup.in
    - source_hash: sha1=e90a56b3ae519c7241b2012eb37ec762f8f85aa2
    - skip_verify: False
    # - unless: "test -f /Users/{{ salt['environ.get']('USER') }}/.iterm2_shell_integration.zsh"

Add shell integration:
  file.blockreplace:
    - name: "/Users/{{ salt['environ.get']('USER') }}/.zshrc"
    - marker_start: "# SALT BLOCK TOP : iterm2_shell_integration : zshrc"
    - marker_end: "# SALT BLOCK BOT : iterm2_shell_integration : zshrc"
    - content: |
        test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
    - show_changes: True
    - append_if_not_found: True
