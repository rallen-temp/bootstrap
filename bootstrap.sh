#!/usr/bin/env bash

#
# Bootstrap.sh - bootstrap script for OS X.
#
# Installs dependenceis required for running Spanfeller VM.
#
# Author: rallen@spanfellergroup.com
# Date: Jan/2015
#

### TODO for Automation (non-priority wishlist)
#
# - Initialize and pass passwords into either Ansible vault or OS X keychain.
# - Generate SSH key if not present, prompt user to paste it elsewhere and wait for user.
# - For..each loops for selectively exporting dotfile env vars.
# - Check ruby, python, and homebrew dependencies.
# - Check for: git, virtualbox, vagrant, hostmanager plugin.

#### PROJECT DEFAULTS
# @todo Declare defaults just in case .env is missing some information.
####

### USER OVERRIDES

###






# Enables debugging.
function debug_on {
    set +o verbose
    set +o xtrace
    # Test only.
    set +o noexec
    # Capture any errors produced by bootstrap.sh.
    set +o errtrace
    # set -o functrace
}

# Disables debugging.
function debug_off {
    set -o xtrace
    set -o verbose
    set -o noexec
    set -o errtrace
}

# Prints welcome message.
function welcome {
    copyright = 'copyright message stub'
    asciiart = 'art library stub'
    # https://github.com/fredpalmer/log4bash
}

# End-of-script tasks.
function goodybye () {
    echo "bootstrap.sh has finished running."
}
trap goodybye EXIT


### CONFIGURATION FUNCTIONS



# Set up Pantheon environment variables.
function pantheon_info {
    echo "Configuring Pantheon..."
    PANTHEON_USE_TERMINUS=false

    if [ -r ".env_pantheon" ]; then
        . .env_pantheon
        PANTHEON_USE_TERMINUS=true
        echo "Pantheon env vars set for ${PANTHEON_USER}..."
    else
        # Create the dotfile for the user and encrypt it with Ansible.
        printf "Question: Do you have permission on Pantheon to use Drush?
        Please answer (y or n): "
        read use_terminus;
        if [ "$use_terminus" == 'y' ]; then
            echo "Using Pantheon";

            echo "Enter your Pantheon username:"; read PANTHEON_USER
            echo "Enter your Pantheon password:"; read PANTHEON_PASS

            export PANTHEON_USER
            export PANTHEON_PASS

            PANTHEON_USE_TERMINUS=true
        fi
    fi

    export PANTHEON_USE_TERMINUS
    printf "\n"
}

# Forwards SSH Agent for use with Vagrant and remote workspaces.
# @TODO: This needs to be done permanent, check the Phase2 blog post.
function ssh_agent_forward () {
    echo "Configuring SSH settings..."
    printf "Enter the path to your SSH public key (default: ~/.ssh/id_rsa):"
    read PUBLIC_KEY

    if [ -z "$PUBLIC_KEY" ]; then
        _PUBLIC_KEY="$HOME/.ssh/id_rsa";
    else
        _PUBLIC_KEY=$PUBLIC_KEY
    fi

    ssh-add -K $_PUBLIC_KEY

    printf "Verifying your SSH keychain...
    Output from ssh-add -l: "
    ssh-add -l
    printf "\n"
}

function uninstall_vagrant () {

    # Check if Vagrant is installed first.
    which vagrant &> /dev/null

    # If it is installed, remove it.
    if [ $? !eq 0 ]; then

        # Uninstall it with brew.
        brew info vagrant &> /dev/null
        if [ $? !eq 0 ]; then
            brew cask uninstall --force vagrant

        # Otherwise, uninstall it manually.
        # See https://docs.vagrantup.com/v2/installation/uninstallation.html.
        else
            sudo rm -rf /Applications/Vagrant
            # Remove binary.
            which vagrant 1> smg_vagrant_location
            sudo rm $(<smg_vagrant_location)
            rm smg_vagrant_location
            # Tell OS X to forget about Vagrant.
            sudo pkgutil --forget com.vagrant.vagrant
            # Remove user data.
            sudo rm -rf ~/.vagrant.d
        fi
    fi

}
function cleanup () {
    printf "Performing cleanup ...\n"

    # First cleanup any previous website installs.
    # This is to prevent git clone from failing due to existing directory.

    if [ -d $SMG_PROJECT_WEBROOT ]; then
        sudo rm -rf $SMG_PROJECT_WEBROOT
    fi

    # Remove Ansible if it's lower than the expected version.
    # sudo pip uninstall ansible -y
}

function install_homebrew () {
    echo "Check if Homebrew is installed."
    which brew &> /dev/null
    if [ $? -eq 0 ]; then
        echo "Homebrew found."
    else
        echo "Homebrew not found, installing."
         # See http://brew.sh/.
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
}

# Keep the brews fresh.
function homebrew_tuneup () {
    # Always update Homebrew.
    echo "Updating Homebrew."
    sudo brew update

    # Remove dead symlinks.
    sudo brew prune
}

function install_python () {
    # This is the default
    # SmgOpss-MacBook-Pro:~ richardallen$ which python
    # /usr/bin/python

    echo "Check if Python is installed."
    brew info python &> /dev/null
    if [ $? -ne 0 ]; then
        echo "Installing Python"
        brew install python
        pip install --upgrade setuptools
        pip install --upgrade pip

        pip install virtualenv
    else
        echo "Python O.K."
    fi
}

function install_ansible () {
    echo "Check if Ansible is installed."
    ansible --version &> /dev/null
    if [ $? -ne 0 ]; then
        echo "Ansible not found, installing."
        sudo brew install ansible --devel
    else
        echo "Ansible O.K."
    fi
}

function install_virtualbox () {
    echo "Check if Virtualbox is installed."
    which virtualbox &> /dev/null
    if [ $? -ne 0 ]; then
        echo "Virtualbox not found, installing."
        sudo brew cask install virtualbox
    else
        echo "Virtualbox O.K."
    fi
}

function install_vmwarefusion () {
    echo "Check if VMWare Fusion is installed."
    ls /Applications/VMware Fusion.app &> /dev/null
    if [ $? -ne 0 ]; then
        echo "VMWare Fusion not found, installing."
        sudo brew cask install vmware-fusion
    else
        echo "VMWare Fusion O.K."
    fi
}

install_vagrant () {
    echo "Check if Vagrant is installed."
    which vagrant &> /dev/null
    if [ $? -ne 0 ]; then
        echo "Vagrant not found, installing."
        sudo brew cask install vagrant
    else
        echo "Vagrant O.K."
    fi
}

# Vagrant extra packages, not always required.
function install_vagrant_extra () {

    # GUI for Vagrant.
    if [ $(brew list vagrant-manager &> /dev/null; echo $?) -eq 0 ]; then
        sudo brew cask install vagrant-manager
    fi

    # Vagrant hostmanager: allows the Vagrantfile to automatically update OS X /etc/hosts files.
    # https://github.com/smdahlen/vagrant-hostmanager.
    sudo vagrant plugin install vagrant-hostmanager

    # Hands-off private IPs for your VMs.
    # https://github.com/oscar-stack/vagrant-auto_network
    # vagrant plugin install vagrant-auto_network
}

function check_existing_databases () {
    # Check if there is any database vendor already installed first.
    echo "Check first to see if there's an existing database service in your system."
    if [ $(brew list MySQL &> /dev/null; echo $?) -eq 0 ]; then
        brew info MySQL
        return 0;
    fi
    if [ $(brew list MariaDB &> /dev/null; echo $?) -eq 0 ]; then
        brew info MariaDB
        return 0;
    fi
    if [ $(brew list percona-server &> /dev/null; echo $?) -eq 0 ]; then
        brew info percona-server
        return 0;
    fi
    echo "No database service found."
    return 1
}

function confirm_uninstall () {
    local formula=$1

    echo "Confirm uninstall of Homebrew formula \"${formula}\"?:"
    select yn in "Yes" "No"; do
        case $yn in
            Yes )
                sudo brew uninstall --force ${formula};
                break;;
            No )
                echo "Skipped uninstall of ${formula}."
            exit;;
        esac
    done
}

function uninstall_db_services () {
    echo "Attempting to uninstall conflicting database services."

    declare -a _db_formulas=("MySQL" "MariaDB" "percona-server")
    for formula in "${_db_formulas[@]}"
    do
       echo "Check if Homebrew formula \"$formula\" is installed."
        if [ $(brew list "$formula" &> /dev/null; echo $?) -eq 0 ]; then
            echo "Homebrew formula \"$formula\" found."
            echo "The current installed version of \"$formula\" is:"
            brew ls --versions ${formula}
            confirm_uninstall "$formula"
        fi
    done
}

function install_chosen_database_vendor () {
    echo "Choose your database vendor:"
    return 0;
}

function install_mysql () {
    # Install Oracle MySQL.
    # TODO: Allow user to choose another vendor such as MariaDB or Percona.
    sudo brew install MySQL

    # Database install is required.
    # Todo: Decouple the cd command's version.
    cd /usr/local/Cellar/mysql/5.7.10
    sudo bin/mysqld --initialize-insecure --user=mysql

    # todo: better test out the auto-startup commands.
    echo "Enable launchd to start mysql at login:"
    # ln -sfv /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents

    echo "Start mysql now:"
    # launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
}

function install_database () {
    check_existing_databases
    if [ $? -eq 0 ]; then
        echo "WARNING: There is at least one existing MySQL service installed in your system that might conflict with a new installation!"
        echo "Do you want to remove the existing MySQL service(s) before proceeding?"
        select yn in "Yes" "No"; do
            case $yn in
                Yes ) uninstall_db_services; break;;
                No ) echo "Attempt to start database service."
                    sudo mysql.server restart &> /dev/null
                    if [ $? -eq 1 ]; then
                        echo "ERROR: The command \"mysql.server restart\" is currently returning an error status!"
                        echo "You might want to look into that before proceeding."
                        # exit 1;
                    fi
                 exit;;
            esac
        done
    else
        echo "Do you want to install a new database service?"
        echo "NOTE: Choosing YES will install the database service on the host machine."
        select yn in "Yes" "No"; do
            case $yn in
                Yes ) install_chosen_database_vendor; break;;
                No ) echo "NOTE: THERE IS NO DATABASE INSTALLED ON THE HOST SYSTEM."
                 exit;;
            esac
        done
    fi
}

function install_extras () {
    echo "Installing extras."
    if [ $(brew list openssl &> /dev/null; echo $?) -eq 1 ]; then
        sudo brew install openssl
    fi
    if [ $(brew list Lynx &> /dev/null; echo $?) -eq 1 ]; then
        sudo brew install Lynx
    fi
}

# Initializes project.
function project_init {
    printf "Initializing project...\n"

    if [ ${SMG_PROJECT_CLEANUP} == true ]; then
        cleanup
    fi

    if [ ! -d ${SMG_PROJECT_WEBROOT} ]; then
        # Clone project repository.
        git clone $SMG_PROJECT_GIT_ORIGIN $SMG_PROJECT_WEBROOT
    else
        echo "Project already exists...no need to clone."
    fi

    # Configure upstream. exec?
    # (/usr/bin/env bash; cd ../www; git remote add upstream $_repo_upstream_url)

    # Export some globals.
    export SMG_PROJECT_GIT_USER
    export SMG_PROJECT_GIT_EMAIL
    export SMG_PROJECT_GIT_ORIGIN
    export SMG_PROJECT_GIT_UPSTREAM
}

# Main function.
function main () {
    # Accept Apple's XCode license to prevent this error:
    # Error: You have not agreed to the Xcode license.
    sudo xcodebuild -license

    # Install Xcode command line tools.
    xcode-select --version &> /dev/null
    if [ $? -ne 0 ]; then
        xcode-select --install
    fi

    # Install main package manager.
    install_homebrew
    # Keep Homebrew up to date.
    homebrew_tuneup

    # todo set the default vagrant provider conf (virtualbox or vmware).
    if [ ${SMG_DEFAULT_VAGRANT_PROVIDER} == "virtualbox" ]; then
        install_virtualbox
    elif [ ${SMG_DEFAULT_VAGRANT_PROVIDER} == "vmware_fusion" ]; then
        install_vmwarefusion
    else
        echo "You must choose a valid Virtualbox provider before proceeding!"
        exit 1;
    fi
    # install_python
    install_ansible
    install_vagrant
    install_vagrant_extra
    install_database
    install_extras

    # Configuration.
    ssh_agent_forward
    pantheon_info
    project_init
}

# Read project-specific environment variables.
if [ -f ".env_project" ]; then
    echo "Configuring project settings..."
    . .env_project
    main
else
    echo "REFUSING TO PROCEED: Could not find .env_project in current directory."
    exit 1;
fi
