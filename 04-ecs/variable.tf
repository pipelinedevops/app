variable "cluster_name" {
   type = string
   description = "Nome do cluster"
   #default  =  "labchallenge"
 }

variable "reponame" {
   type = string
   description = "Nome do repositório"
   #default  =  "labchallenge"
 }

 variable "image_tag " {
   type = string
   description = "Nome tag"
   #default  =  "labchallenge"
 }

 variable "tags" {
  type        = map(any)
  description = "tags"

}

