{%- set homebrew = pillar.get("homebrew", {}) %}

{%- for brew in homebrew.get('brews', {}) %}
  "Brew install {{ brew }}":
    cmd.run:
      - name: "brew install {{ brew }}"
{%- endfor %}

{%- for cask in homebrew.get('casks', {}) %}
  "Brew cask install {{ cask }}":
    cmd.run:
      - name: "brew cask install {{ cask }}"
{%- endfor %}
