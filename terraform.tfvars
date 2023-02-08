# terraform.tfvars

# Definir cuantos nodos de cada uno se necesitan.
control-count = "1"
etcd-count    = "0"
worker-count  = "1"

# VM Configuration
vm-prefix        = "k3s-Prod"
#vm-template-name = "debian11-for-ansible-template"
vm-template-name = "debian11-001-v18-ssd"
vm-cpu-cp      = "2"
vm-ram-cp      = "2048"
vm-cpu-etcd    = "2"
vm-ram-etcd    = "4096"
vm-cpu-worker  = "4"
vm-ram-worker  = "8192"
vm-guest-id = "debian11_64Guest"
#vm-datastore = "NVME"
vm-datastore = "vsanDatastore2021"
#vm-network   = "VM Network"
vm-network   = "Rancher_Network_1"
vm-domain = "chaco.gov.ar"

# vSphere configuration
vsphere-vcenter        = "vcsa.ecom.com.ar"
vsphere-unverified-ssl = "true"
vsphere-datacenter     = "EcomDC"
vsphere-cluster        = "SM-HCI-2021"

# vSphere username defined in environment variable
# export TF_VAR_vsphereuser=$(pass vsphere-user)

# vSphere password defined in environment variable
# export TF_VAR_vspherepass=$(pass vsphere-password)