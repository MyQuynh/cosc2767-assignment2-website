sudo snap install docker
sudo snap start docker
sudo chmod 666 /var/run/docker.sock
echo 'export PATH=$PATH:/snap/bin' >> ~/.bashrc
source ~/.bashrc