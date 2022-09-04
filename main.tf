

#  resource "aws_instance" "iaaC-assessment-vm" {
#    ami         = "ami-052efd3df9dad4825"
  
#   instance_type = "t2.micro"

#    tags = {
#      Name = "iaac-assessment"
#    }
#  }

resource "aws_instance" "web" {
  ami           = "ami-052efd3df9dad4825"
  instance_type = "t2.micro"
  count = 20
  # vpc_security_group_ids = [
  #   "sg-0d8bdc716e7baee9f"
  # ]
}