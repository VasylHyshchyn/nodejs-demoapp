terraform {
  source = "../../../modules/ec2"
}

dependency "sg" {
  config_path = "../sg"
}

inputs = {
  name        = "nodejs-demoapp"
  environment = "dev"

  instance_type = "t3.micro"

  security_group_id = dependency.sg.outputs.ec2_security_group_id

  user_data_base64 = filebase64("../../../user_data/user_data.sh")
}

