sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo chkconfig docker on
sudo yum install -y git
sudo chmod 666 /var/run/docker.sock
docker pull nginx:latest
docker run -d -p 80:80 nginx:latest  
