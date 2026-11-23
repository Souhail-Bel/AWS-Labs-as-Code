variable "use_floci" {
  type        = bool
  default     = true
  description = "Use the local Floci emulator instead of real AWS"
}

variable "floci_endpoint" {
  type        = string
  default     = "http://localhost:4566"
  description = "Floci endpoint"
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}
