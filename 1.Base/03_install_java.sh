# install Java and a few base packages
add-apt-repository ppa:openjdk-r/ppa
apt-get update
apt-get install vim curl zip unzip git python-pip -y -q

# Java install - adjust if needed
# apt-get install openjdk-7-jdk -y -q
apt-get install openjdk-8-jdk -y -q
