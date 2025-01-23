variable "cluster_name" {
   type = string
   description = "Nome do cluster"
   #default  =  "labchallenge"
 }

variable "ecs_servicename" {
   type = string
   description = "Nome do cluster"
   #default  =  "labchallenge"
 }


variable "reponame" {
   type = string
   description = "Nome do repositório"
   #default  =  "labchallenge"
 }

 variable "imagetag" {
   type = string
   description = "Nome tag"
   #default  = "v" #"labchallenge"
 }

 variable "tags" {
  type        = map(any)
  description = "tags"

}

