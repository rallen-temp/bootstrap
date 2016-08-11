iterm:
  # The following shells are supported: tcsh, zsh, bash, and fish 2.2 or later.
  shell_integration:
    - zsh
    - bash

zsh:
  omz:
    # For a list of supported themes see:
    # https://github.com/robbyrussell/oh-my-zsh/wiki/themes
    theme: pygmalion

    # Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
    # Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
    # Example format: plugins=(rails git textmate ruby lighthouse)
    # Add wisely, as too many plugins slow down shell startup.
    #
    # For more plugins see https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins
    plugins:
      # Essential
      - osx
      - git
      - brew
      - ssh-agent
      - vagrant

      # Utilities
      - common-aliases
      - gpg-agent
      - git-extras
      # - docker
      - tmux # https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins#tmux
      - web-search # google oh-my-zsh, ddg foo bar, bing what is github
      - wd # Warp directories. https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins#web-search

      # Project Management
      # - taskwarrior

      # Swag
      - chucknorris
      # - lol

      # Development - Pythonistas
      #- pip
      #- python
      #- pyenv
      #- virtualenvwrapper

      # Development - Hipsters
      #- rvm
      #- npm

      # Development - PHP
      #- scala
      #- symfony2
      #- composer
      #- laravel4
      #- phing
      #- yii2

      # Editors
      #- sublime
      #- textmate



# Unix group for web application files.
web_group: www-data

## COMPOSER

# Replace the commit hash by whatever the last commit hash is on
# https://github.com/composer/getcomposer.org/commits/master
composer_version: e67dc80d23742dd8ad67fa63135d7f8fdf2e2fb6
composer_user: www-data
composer_group: www-data
composer_install_dest: /usr/local/bin

## DRUSH

# Drush 8.x requires PHP 5.4
# https://packagist.org/packages/drush/drush#8.x-dev
# Drush 7.x requires PHP 5.3
# https://packagist.org/packages/drush/drush#7.x-dev
drush_version: 7.x-dev

## NGINX

nginx_user: nginx
nginx_group: www-data
# On Ubuntu precise, "auto" gives an error when starting Nginx.
# Restarting nginx: nginx: [emerg] "worker_processes" directive invalid number in /etc/nginx/nginx.conf:2
# http://nginx.org/en/docs/ngx_core_module.html#worker_processes
nginx_worker_processes: 3
nginx_pid: /run/nginx.pid

nginx_error_log: "/var/log/nginx/error.log info"
nginx_access_log: /var/log/nginx/access.log

nginx_config_inc: /etc/nginx/conf.d/*.conf
nginx_vhost_inc: /etc/nginx/sites-enabled/*.conf

nginx_listen_ip: ""
nginx_listen_port: ""

# http://nginx.org/en/docs/ngx_core_module.html#error_log
# Can be one of the following: debug, info, notice, warn, error, crit, alert, or emerg.
# The default level error will cause error, crit, alert, and emerg messages to be logged.
nginx_default_loglevel: info
