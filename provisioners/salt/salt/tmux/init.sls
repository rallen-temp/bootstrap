Install tmux:
  cmd.run:
    - name: brew install tmux

Customize tmux:
  file.managed:
    - name: "/Users/{{ salt['environ.get']('USER') }}/.tmux.conf"
    - source: salt://tmux/.tmux.conf
    - show_diff: True
