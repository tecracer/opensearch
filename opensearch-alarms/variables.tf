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

variable "master_instance_count" {
  description = "The count of master instances"
  type        = number
  default     = 0
}


variable "warm_instance_count" {
  description = "The count of warm instances"
  type        = number
  default     = 0
}

# Variable for enabling/disabling alarm groups
variable "enable_alarm_groups" {
  description = "Enable or disable groups of alarms"
  type = object({
    master_nodes  = bool
    ultrawarm     = bool
    cold_storage  = bool
    plugin_alarms = bool
  })
  default = {
    master_nodes  = true
    ultrawarm     = true
    cold_storage  = true
    plugin_alarms = true
  }
}