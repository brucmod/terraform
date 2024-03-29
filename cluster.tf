
data "vsphere_datacenter" "dc" {
  name = "Chicago"
}

data "vsphere_datastore" "datastore" {
  name          = "chi-fs-vvol"
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_resource_pool" "pool1" {
   name          = "bm-rp"
   datacenter_id = data.vsphere_datacenter.dc.id
 }
data "vsphere_network" "public" {
  name          = "VLAN112"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "iscsi" {
  name          = "privatevlan"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = "chi-template-ubuntu20.04-clean"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  name             = "chi-btm-pwx-n${count.index}"
  count            = "5"
  resource_pool_id = data.vsphere_resource_pool.pool1.id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = "chi-btm"
  wait_for_guest_ip_timeout = "-1"
  wait_for_guest_net_timeout = "-1"
  enable_disk_uuid = "true"

  num_cpus = 8
  memory   = 12288
  guest_id = data.vsphere_virtual_machine.template.guest_id
  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  cdrom {
    client_device = true
  }

  network_interface {
    network_id   = data.vsphere_network.public.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }
  network_interface {
    network_id   = data.vsphere_network.iscsi.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = "200"
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }
  disk {
    label            = "disk1"
#    size             = data.vsphere_virtual_machine.template.disks.0.size
    size             = "100"
    unit_number      = 1
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }
  disk {
    label            = "disk2"
#    size             = data.vsphere_virtual_machine.template.disks.0.size
    size             = "100"
    unit_number      = 2
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }
  disk {
    label            = "disk3"
#    size             = data.vsphere_virtual_machine.template.disks.0.size
    size             = "99"
    unit_number      = 3
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = "chi-btm-pwx-n${count.index}"
        domain    = "purestorage.com"
      }
      network_interface {
        ipv4_address = "10.224.114.10${0 + count.index}"
        ipv4_netmask = 22
      }
      network_interface {
        ipv4_address = "10.10.10.${250 + count.index}"
        ipv4_netmask = 24
      }
      dns_server_list = ["10.224.112.106","8.8.4.4","8.8.8.8"]
      ipv4_gateway = "10.224.112.1"
    }
  }

}

