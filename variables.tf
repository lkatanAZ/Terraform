variable "NETresourceGroupName" {
    type = string
    description = "the network resourcegroup name"
    
}


variable "VMrg" {
    type = string
    description = "the vm resourcegroup name"
    
}


variable "location"{
    type=string
    description="the location where the resources will be created"
    
}

variable "vmname"{
    type=string
    description="virtual nachine name "
   
}

variable "subnetprefix"{
    type=string
    description="subnet prexfix"
}

variable "subnetname"{
    type=string
    description="vardescription"
}

variable "vnetspace"{
    type=list
    description="vardescription"

}

variable "vnetname"{
    type=string
    description="vnet name"

}


variable "vmsku"{
    type=string
    description="sku of the virtual machine"
}




variable "vm_size" {
    type = string
    description = "Size of VM"
    default = "Standard_B1s"
}

variable "os" {
    description = "OS image"
    type = object({
        publisher = string
        offer = string
        sku = string
        version = string
  })
}


  variable "admin_username" {
    type = string
    description = "Administrator username for server"
}

variable "admin_password" {
    type = string
    description = "Administrator password for server"
}
