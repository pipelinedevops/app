variable "reponame" {
    type = string
    description = "Nome do cofre"
   default  =  "labchallenge"
 }

variable "imagename" {
    type = string
    description = "Nome do cofre"
   default  =  "labchallenge"
 }


 variable "tags" {
  type        = map(any)
  description = "tags"
  default = {
    Application = "state"
    project     = "lab_challenge"
    Owner       = "lab_challenge"
    Environment = "PRD"
    name = "labchallenge"

  }
}

