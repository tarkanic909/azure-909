locals {
  prefix = "k8s-lab"

  vms = {
    master  = { subnet = "master" }
    worker1 = { subnet = "workers" }
    worker2 = { subnet = "workers" }
  }
}
