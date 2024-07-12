variable "region" {
  description = "The AWS region where the resources will be deployed"
  type        = string
  default     = "eu-central-1"
}

variable "domain" {
  description = "The domain name of the OpenSearch cluster, which should be in lowercase"
  type        = string
  default     = "trc-workshop"
}

variable "alarms_email" {
  type        = string
  description = "An e-mail address for the alarms for the OpenSearch cluster"
}

variable "instance_count" {
  description = "The count of instances to be deployed"
  type        = number
  default     = 1
}
