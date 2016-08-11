Set Github token for Homebrew:
  file.blockreplace:
    - name: "/Users/{{ salt['environ.get']('USER') }}/.zshrc"
    - marker_start: "# SALT BLOCK TOP : userenv : zshrc"
    - marker_end: "# SALT BLOCK BOT : userenv : zshrc"
    - content: |
        export HOMEBREW_GITHUB_API_TOKEN='{{ pillar['userenv']['HOMEBREW_GITHUB_API_TOKEN'] }}'
    - append_if_not_found: True

Set global Git user name and email:
  file.blockreplace:
    - name: "/Users/{{ salt['environ.get']('USER') }}/.gitconfig"
    - content: |
        [user]
            name = "{{ pillar['git']['user']['name'] }}"
            email = "{{ pillar['git']['user']['email'] }}"
    - append_if_not_found: True
    - show_changes: True

Set global Git ignore:
  file.managed:
    - name: "/Users/{{ salt['environ.get']('USER') }}/.gitignore_global"
    - contents: {{ pillar['git']['ignore'] }}
    - show_changes: True
    - create: True
