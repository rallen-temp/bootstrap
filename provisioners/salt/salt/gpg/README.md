Introduction to GPG

* http://www.cnet.com/how-to/want-really-secure-gmail-try-gpg-encryption/
* https://security.googleblog.com/2014/06/making-end-to-end-encryption-easier-to.html


Pinentry install

    rallen36@WITSC02M50WLFD5:~|⇒  brew install pinentry-mac
    ==> Downloading https://homebrew.bintray.com/bottles/pinentry-mac-0.9.4.yose
    #######################################                                   54######################################################################## 100.0%
    ==> Pouring pinentry-mac-0.9.4.yosemite.bottle.tar.gz
    ==> Caveats
    You can now set this as your pinentry program like
    
    ~/.gnupg/gpg-agent.conf
        pinentry-program /usr/local/bin/pinentry-mac
    
    .app bundles were installed.
    Run `brew linkapps pinentry-mac` to symlink these to /Applications.
    ==> Summary
    🍺  /usr/local/Cellar/pinentry-mac/0.9.4: 10 files, 389.9K
    
GPG Suite Install Results

    ==> installer: Package name is GPG Suite
    ==> installer: Installing at base path /
    ==> installer: The install was successful.
    2016-08-11 17:55:09: [fixGpgHome] started with arguments: rallen36 /Users/rallen36/.gnupg
    2016-08-11 17:55:09: Overwrite UID: rallen36
    2016-08-11 17:55:09: Overwrite GNUPGHOME: /Users/rallen36/.gnupg
    d2e82a39aaef128c61a91b1ca08d9931922d3327  /usr/local/MacGPG2/bin/gpg2
    990cae62c6aaf4529c54e28b5c929ade0245f6ee  /usr/local/MacGPG2/bin/gpg-agent
    2016-08-11 17:55:09: [fixGpgHome] Fixing '/Users/rallen36/.gnupg'...
    gpg: WARNING: unsafe ownership on configuration file `/Users/rallen36/.gnupg/gpg.conf'
    2016-08-11 17:55:09: [fixGpgHome] Fixing done
    2016-08-11 17:55:09: [fixGpgHome] fixGPGAgent started
    2016-08-11 17:55:09: [fixGpgHome] Fixing '/Users/rallen36/.gnupg/gpg-agent.conf'...
    2016-08-11 17:55:09: [fixGpgHome] Found working pinentry at: /usr/local/MacGPG2/libexec/pinentry-mac.app/Contents/MacOS/pinentry-mac
    2016-08-11 17:55:09: [fixGpgHome] Add new pinentry
    2016-08-11 17:55:09: [fixGpgHome] Start gpg-agent.
    2016-08-11 17:55:09: [fixGpgHome] UID = 0
    2016-08-11 17:55:09: [fixGpgHome] Start gpg-agent using uid: 'rallen36'
    GPG_AGENT_INFO=/Users/rallen36/.gnupg/S.gpg-agent:94035:1; export GPG_AGENT_INFO;
    2016-08-11 17:55:09: [fixGpgHome] fixGPGAgent done
    2016-08-11 17:55:09: [fixGpgHome] done
    🍺  gpgtools was successfully installed!
    
GPG Agent Check
    
    rallen36@WITSC02M50WLFD5:~|⇒  gpg-agent --help
    gpg-agent (GnuPG/MacGPG2) 2.0.30
    libgcrypt 1.7.0
    Copyright (C) 2015 Free Software Foundation, Inc.
    License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
    This is free software: you are free to change and redistribute it.
    There is NO WARRANTY, to the extent permitted by law.
    
    Syntax: gpg-agent [options] [command [args]]
    Secret key management for GnuPG
    
    Options:
    
         --daemon                     run in daemon mode (background)
         --server                     run in server mode (foreground)
     -v, --verbose                    verbose
     -q, --quiet                      be somewhat more quiet
     -s, --sh                         sh-style command output
     -c, --csh                        csh-style command output
         --options FILE               read options from FILE
         --no-detach                  do not detach from the console
         --no-grab                    do not grab keyboard and mouse
         --log-file                   use a log file for the server
         --use-standard-socket        use a standard location for the socket
         --pinentry-program PGM       use PGM as the PIN-Entry program
         --scdaemon-program PGM       use PGM as the SCdaemon program
         --disable-scdaemon           do not use the SCdaemon
         --keep-tty                   ignore requests to change the TTY
         --keep-display               ignore requests to change the X display
         --default-cache-ttl N        expire cached PINs after N seconds
         --ignore-cache-for-signing   do not use the PIN cache when signing
         --no-allow-mark-trusted      disallow clients to mark keys as "trusted"
         --allow-preset-passphrase    allow presetting passphrase
         --enable-ssh-support         enable ssh support
         --no-allow-external-cache    disallow the use of an external password cache
         --write-env-file FILE        write environment settings also to FILE
    
    Please report bugs to <http://bugs.gnupg.org>.    