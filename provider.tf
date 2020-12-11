
provider "vsphere" {
  user           = "administrator@vsphere.local"
  password       = "Pure123$$!"
  vsphere_server = "10.224.112.45"

  # If you have a self-signed cert
  allow_unverified_ssl = true
}