


 resource "aws_instance" "my-vms" {
   ami           = "ami-052efd3df9dad4825"
   instance_type = "t2.micro"
   count = 20

   tags = {
    Name = "iaac_assessment_20_vm"
   }
}



#   resource "aws_instance" "iaaC-assessment-vm" {
#     ami         = "ami-052efd3df9dad4825"
  
#    instance_type = "t2.micro"

#     tags = {
#       Name = "iaac-assessment"
#     }
#  }
