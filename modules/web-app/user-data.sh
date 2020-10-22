#!/bin/bash -i

WEBAPP_VER=0.0.3
WEBAPP_NAME=nodejs-example-webapp-$WEBAPP_VER

install_nvm(){
  echo "Installing nvm"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.36.0/install.sh | bash
  echo 'export NVM_DIR="$HOME/.nvm"' >> $HOME/.bashrc
  echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> $HOME/.bashrc
  echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> $HOME/.bashrc
  . $HOME/.bashrc
  nvm -v
}

install_node(){
  echo "Installing NodeJS"
  #. $HOME/.bashrc
  nvm install --lts
  node --version
}

install_webapp(){
  echo "Setting up Web App"
  #. $HOME/.bashrc
  wget -O $HOME/$WEBAPP_NAME.tar.gz https://github.com/muhannad0/nodejs-example-webapp/archive/v$WEBAPP_VER.tar.gz
  tar -xf $WEBAPP_NAME.tar.gz
  cd $HOME/$WEBAPP_NAME
  npm install
  echo "Configurig Web App"
	cat <<- EOF > .env
	SERVER_PORT=${server_port}
	SERVER_TEXT="${server_text}"
	DB_ADDRESS=${db_address}
	DB_PORT=${db_port}
	DB_NAME=${db_name}
	DB_USERNAME=${db_user}
	DB_PASSWORD=${db_password}
	EOF
}

start_webapp(){
  echo "Starting Web App"
  cd $HOME/$WEBAPP_NAME
  node app.js 2>&1 > /dev/null
}


# MAIN
#yum update -y

if [[ ! -d $HOME/$WEBAPP_NAME ]]; then
  echo "Web app not found"
  if [[ ! $(command -v node) ]]; then
    echo "NodeJS not found"
    if [[ ! -f $HOME/.nvm/nvm.sh ]]; then
      echo "nvm not found"
      install_nvm
      install_node
      install_webapp
      start_webapp
    else
      install_node
      install_webapp
      start_webapp
    fi
  else
    install_webapp
    start_webapp
  fi
else
  echo "Web app already installed"
  start_webapp
fi
