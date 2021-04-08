
provider "vsphere" {
  user           = "brucem"
  password       = "Madne$$@2020"
  vsphere_server = "10.89.8.130"

  # If you have a self-signed cert
  allow_unverified_ssl = true
}
