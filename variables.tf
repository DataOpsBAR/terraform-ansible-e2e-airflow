#////////////////////////////////
#  Variables
#////////////////////////////////
variable "web_app_name" {
  type = string
}
variable "whitelist" {
  type = list(string)
}
variable "web_instance_type" {
  type = string
}
variable "web_key_name" {
  type = string
}
