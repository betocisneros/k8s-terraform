# main.tf

# Configure the vSphere provider
provider "vsphere" {
  user                 = var.vsphereuser
  password             = var.vspherepass
  vsphere_server       = var.vsphere-vcenter
  allow_unverified_ssl = var.vsphere-unverified-ssl
}

data "vsphere_datacenter" "dc" {
  name = var.vsphere-datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.vm-datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere-cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.vm-network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.vm-template-name
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Create VM Folder
#resource "vsphere_folder" "folder" {
#  path          = "KUBERNETES"
#  type          = "vm"
#  datacenter_id = data.vsphere_datacenter.dc.id
#}





# Create Control Plane VMs
resource "vsphere_virtual_machine" "CP" {
  count            = var.control-count
  name             = "${var.vm-prefix}-CP-${count.index + 1}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = "KUBERNETES/Clusters-Produccion" #vsphere_folder.folder.path

  num_cpus = var.vm-cpu-cp
  memory   = var.vm-ram-cp
  guest_id = var.vm-guest-id


  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label       = "${var.vm-prefix}-${count.index + 1}-diska"
    size        = 20
    unit_number = 0
  }

  disk {
    label       = "${var.vm-prefix}-${count.index + 1}-diskb"
    size        = 20
    unit_number = 1
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      timeout = 0

      linux_options {
        host_name = "${var.vm-prefix}-cp-${count.index + 1}"
        domain    = var.vm-domain
      }

      network_interface {
        ipv4_address = "10.1.150.22${count.index + 1}"
        ipv4_netmask = 16
      }

      ipv4_gateway    = "10.1.0.1"
      dns_server_list = ["10.2.0.210"]

    }
  }
}

# Create ETCD VMs
resource "vsphere_virtual_machine" "ETCD" {
  count            = var.etcd-count
  name             = "${var.vm-prefix}-ETCD-${count.index + 1}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = "KUBERNETES/Clusters-Produccion" #vsphere_folder.folder.path

  num_cpus = var.vm-cpu-etcd
  memory   = var.vm-ram-etcd
  guest_id = var.vm-guest-id


  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label       = "${var.vm-prefix}-${count.index + 1}-diska"
    size        = 20
    unit_number = 0
  }

  disk {
    label       = "${var.vm-prefix}-${count.index + 1}-diskb"
    size        = 20
    unit_number = 1
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      timeout = 0

      linux_options {
        host_name = "${var.vm-prefix}-etcd-${count.index + 1}"
        domain    = var.vm-domain
      }

      network_interface {
        ipv4_address = "10.1.150.24${count.index + 1}"
        ipv4_netmask = 16
      }

      ipv4_gateway    = "10.1.0.1"
      dns_server_list = ["10.2.0.210"]

    }
  }
}



# Create Worker VMs
resource "vsphere_virtual_machine" "worker" {
  count            = var.worker-count
  name             = "${var.vm-prefix}-WORKER-${count.index + 1}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = "KUBERNETES/Clusters-Produccion" #vsphere_folder.folder.path

  num_cpus = var.vm-cpu-worker
  memory   = var.vm-ram-worker
  guest_id = var.vm-guest-id

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label       = "${var.vm-prefix}-${count.index + 1}-diska"
    size        = 20
    unit_number = 0
  }
  disk {
    label       = "${var.vm-prefix}-${count.index + 1}-diskb"
    size        = 20
    unit_number = 1
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      timeout = 0

      linux_options {
        host_name = "${var.vm-prefix}-WORKER-${count.index + 1}"
        domain    = var.vm-domain
      }

      network_interface {
        ipv4_address = "10.1.150.23${count.index + 1}"
        ipv4_netmask = 16
      }

      ipv4_gateway    = "10.1.0.250"
      dns_server_list = ["10.2.0.210"]
    }
  }
}

output "control_ip_addresses" {
  value = vsphere_virtual_machine.CP.*.default_ip_address
}

output "etcd_ip_addresses" {
  value = vsphere_virtual_machine.ETCD.*.default_ip_address
}


output "worker_ip_addresses" {
  value = vsphere_virtual_machine.worker.*.default_ip_address
}