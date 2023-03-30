

variable "aws_region" {
  description = "AWS region(N.Virginia)"
  default     = "us-east-1"
}

variable "instance_tags" {
	type = map(string)
	default = {
		production = "Awesome Production Server"
		jenkins = "Jenkins for Awesome Inc."
        jenkins-agent: "Agent machine for builds"
	}
}