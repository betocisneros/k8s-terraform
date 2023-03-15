# terraform.tfvars

# Definir cuantos nodos de cada uno se necesitan.
control-count = "1"
etcd-count    = "0"
worker-count  = "0"

# VM Configuration
vm-prefix        = "k8s-Prod"
vm-template-name = "amzn2-for-ansible-template"
#vm-template-name = "amzn2-for-ansible-template-Cloud"
#vm-template-name = "amz2.test"
#vm-template-name = "amzn2-vmware_esx-2.0.20230119.1-x86_64.xfs.gpt"
vm-cpu-cp      = "4"
vm-ram-cp      = "4096"
vm-cpu-etcd    = "2"
vm-ram-etcd    = "4096"
vm-cpu-worker  = "8"
vm-ram-worker  = "8192"
vm-guest-id = "other3xLinux64Guest"
#vm-guest-id = "ubuntu64Guest"
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
