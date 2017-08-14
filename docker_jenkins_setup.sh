#!/bin/bash

install_brew () {
  echo "Do you want to install brew (y/n)"
  read option
  if [[ ${option} == 'Y' || ${option} == 'y' ]]; then
    echo "Installing brew for you !!!"
    check_ruby_version
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    echo "Brew Installed!!!!"
  else
    echo "Exiting the script ...."
    sleep 1
    exit 0
  fi
}

check_ruby_version () {
  /usr/bin/ruby -v
  if [[ $? > 0 ]]; then
    echo "Ruby is not Installed please install Ruby."
    echo "Exiting the script"
    exit 0
  else
    echo "Ruby is already installed in your machine"
  fi
}

install_docker () {
  echo "Installing docker"
  docker -v
  if [[ $? > 0 ]]; then
    brew install docker
    echo "Docker installed !!!"
  else
    echo "Docker already installed !!!"
  fi
}

install_docker_machine () {
  echo "Installing docker-machine"
  docker-machine -v
  if [[ $? > 0 ]]; then
    brew install docker-machine
    echo "Docker-machine installed !!!"
  else
    echo "Docker-machine already installed !!!"
  fi

}

setup_jenkins () {
  echo "Setting up Jenkins"
  docker-machine create --driver virtualbox devops
  eval $(docker-machine env devops)
  docker pull jenkins:2.60.1
  PORT=8090
  DIR_JENKINS=${HOME}/devops-essentials/docker-jenkins
  mkdir -p ${DIR_JENKINS}
  docker run -d --name nisumJenkins -p ${PORT}:8080 -p 50000:50000 -v ${DIR_JENKINS}:/var/jenkins_home jenkins:2.60.1
  echo "Jekins should be up an running now !!!"
  DOCKER_MACHINE_IP=`docker-machine ip devops`
  echo "http://${DOCKER_MACHINE_IP}:${PORT} is where you can access jenkins"
  echo "The initialAdminPassword is as follows: "
  cat ${DIR_JENKINS}/secrets/initialAdminPassword
  echo "InitialPasscode can also be found at ${DIR_JENKINS}"
}

# check_if_brew_exists=`brew -v | head -1 | awk {'print $2'}`
brew -v
if [[ $? > 0 ]]; then
  echo "Brew doesn't exists"
  install_brew
else
  echo "Brew exists !!!"
fi

install_docker_machine
install_docker
setup_jenkins
