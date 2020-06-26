#!/bin/bash

# script to configure my notebook

# local variables

BLUE="\033[0;34m"
NC="\033[0m"
RED='\033[0;31m'
GREEN="\033[0;32m"
BASE_PATH="/other/scripts"


echo "***********************************************************************************************************************\n"
echo "===Starting script for configure all your tools, you should take a coffee and take a sit, this could take a while===\n"
echo "***********************************************************************************************************************\n"

sleep 2s

echo "***********************************************************************************************************************\n"
echo "updating the system\n"
echo "***********************************************************************************************************************\n"

sudo apt update
clear

echo "***********************************************************************************************************************\n"
echo "installing curl\n"
echo "***********************************************************************************************************************\n"

sudo apt install curl -y
clear

echo "***********************************************************************************************************************\n"
echo "installing vim\n"
echo "***********************************************************************************************************************\n"

sudo apt install vim -y
clear

echo "***********************************************************************************************************************\n"
echo "installing git\n"
echo "***********************************************************************************************************************\n"

sudo apt install git -y
clear


echo "What name do you want to use in GIT user.name?"

read git_config_user_name
git config --global user.name "$git_config_user_name"

echo "What email do you want to use in GIT user.email?"

read git_config_user_email
git config --global user.email $git_config_user_email

echo "Setting VIM as your default GIT editor\n"

git config --global core.editor vim
clear

echo "Generating a SSH Key\n"

ssh-keygen -t rsa -b 4096 -C $git_config_user_email
ssh-add ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub | xclip -selection clipboard

echo "***********************************************************************************************************************\n"
echo 'installing zsh\n'
echo "***********************************************************************************************************************\n"

sudo apt-get install zsh -y
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
chsh -s /bin/zsh

echo "***********************************************************************************************************************\n"
echo 'installing tool to handle clipboard via CLI'
echo "***********************************************************************************************************************\n"

sudo apt-get install xclip -y

export alias pbcopy='xclip -selection clipboard'
export alias pbpaste='xclip -selection clipboard -o'
source ~/.zshrc
clear


echo "***********************************************************************************************************************\n"
echo "installing vscode\n"
echo "***********************************************************************************************************************\n"

curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get install apt-transport-https -y
sudo apt-get update
sudo apt-get install code -y # or code-insiders

#hash code 2>/dev/null || { echo >&2 "${RED} The command code is not available in path ${NC}\n"; } 

echo "***********************************************************************************************************************\n"
echo "installing vscode extensions\n"
echo "***********************************************************************************************************************\n"


code --install-extension formulahendry.auto-rename-tag
code --install-extension CoenraadS.bracket-pair-colorizer
code --install-extension ms-azuretools.vscode-docker
code --install-extension p1c2u.docker-compose
code --install-extension EditorConfig.EditorConfig
code --install-extension dbaeumer.vscode-eslint
code --install-extension eamodio.gitlens
code --install-extension andys8.jest-snippets
code --install-extension ritwickdey.LiveServer
code --install-extension shd101wyy.markdown-preview-enhanced
code --install-extension arcticicestudio.nord-visual-studio-code
code --install-extension esbenp.prettier-vscode
code --install-extension Prisma.prisma
code --install-extension xabikos.ReactSnippets
code --install-extension vscode-icons-team.vscode-icons

cp -rf vscode/settings.json ~/.config/Code/User/

clear

echo "***********************************************************************************************************************\n"
echo "installing chrome\n"
echo "***********************************************************************************************************************\n"

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb

echo "***********************************************************************************************************************\n"
echo "installing zsh\n"
echo "***********************************************************************************************************************\n"

sudo apt install zsh -y
zsh --version

echo "***********************************************************************************************************************\n"
echo "installing Oh My Zsh\n"
echo "***********************************************************************************************************************\n"

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "***********************************************************************************************************************\n" 
echo 'installing autosuggestions\n' 
echo "***********************************************************************************************************************\n" 

git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
source ~/.zshrc

echo "***********************************************************************************************************************\n" 
echo 'installing theme\n'
echo "***********************************************************************************************************************\n" 

sudo apt install fonts-firacode -y
export ZSH_CUSTOM=~/.oh-my-zsh
git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
sed -i 's/.*ZSH_THEME=.*/ZSH_THEME="spaceship"/g' ~/.zshrc


echo "SPACESHIP_PROMPT_ORDER=(
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  hg            # Mercurial section (hg_branch  + hg_status)
  exec_time     # Execution time
  line_sep      # Line break
  vi_mode       # Vi-mode indicator
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)
SPACESHIP_USER_SHOW=always
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_CHAR_SYMBOL=\"->\"
SPACESHIP_CHAR_SUFFIX=\" \"" >> ~/.zshrc

sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)" -y

echo "zinit light zdharma/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions" >> ~/.zshrc
source ~/.zshrc


echo "***********************************************************************************************************************\n" 
echo 'installing meet franz\n' 
echo "***********************************************************************************************************************\n" 

wget https://github.com/meetfranz/franz/releases/download/v5.5.0/franz_5.5.0_amd64.deb
sudo dpkg -i franz_5.5.0_amd64.deb

echo "***********************************************************************************************************************\n" 
echo 'installing docker\n' 
echo "***********************************************************************************************************************\n" 

sudo apt-get remove docker docker-engine docker.io
sudo apt install docker.io -y
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
sudo systemctl start docker
docker --version
docker run hello-world

echo "***********************************************************************************************************************\n" 
echo 'installing docker-compose\n' 
echo "***********************************************************************************************************************\n" 

sudo wget -O  /usr/local/bin/docker-compose https://github.com/docker/compose/releases/download/1.25.0/docker-compose-Linux-x86_64
sudo chmod +x /usr/local/bin/docker-compose
docker-compose version


echo "***********************************************************************************************************************\n" 
echo 'installing aws-cli\n'
echo "***********************************************************************************************************************\n" 

sudo apt-get install awscli -y
aws --version
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
sudo dpkg -i session-manager-plugin.deb
session-manager-plugin --version


echo "***********************************************************************************************************************\n" 
echo 'installing dbeaver\n'
echo "***********************************************************************************************************************\n" 

sudo snap install dbeaver-ce

echo "***********************************************************************************************************************\n" 
echo 'installing dbeaver\n'
echo "***********************************************************************************************************************\n" 

sudo snap install sublime-text --classic


echo "***********************************************************************************************************************\n" 
echo 'installing insomnia\n'
echo "***********************************************************************************************************************\n" 

sudo snap install insomnia

echo "***********************************************************************************************************************\n" 
echo 'installing insomnia-designer\n'
echo "***********************************************************************************************************************\n" 

sudo snap install insomnia-designer

echo "***********************************************************************************************************************\n" 
echo 'installing drawio\n'
echo "***********************************************************************************************************************\n" 

sudo snap install drawio


echo "***********************************************************************************************************************\n" 
echo 'installing obs-studio\n'
echo "***********************************************************************************************************************\n" 
sudo snap install obs-studio


echo "***********************************************************************************************************************\n" 
echo "installing yarn \n"
echo "***********************************************************************************************************************\n" 

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install yarn
yarn --version


echo "***********************************************************************************************************************\n" 
echo "lets install react/node.js environment stuffs \n"
echo "***********************************************************************************************************************\n" 

slepp 2s

echo "***********************************************************************************************************************\n"
echo "installing node \n"
echo "***********************************************************************************************************************\n" 

sudo mkdir /opt/node
wget https://nodejs.org/dist/v12.18.1/node-v12.18.1-linux-x64.tar.xz 
sudo tar -xf node-v12.18.1-linux-x64.tar.xz -C /opt/node
sudo mv /opt/node/node-v12.18.1-linux-x64 /opt/node/v12.18.1
cd /usr/local/bin
sudo ln -s /opt/node/v12.18.1/bin/node node
sudo ln -s /opt/node/v12.18.1/bin/npm npm
sudo ln -s /opt/node/v12.18.1/bin/npx npx
cd ${BASE_PATH}

sudo yarn add global gatsby
sudo yarn add global expo
sudo yarn add global react-native


