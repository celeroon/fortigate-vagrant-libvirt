packer {
  required_plugins {
    qemu = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

variable "version" {
  type    = string
  default = "unknown"
}

variable "gui_disabled" {
  type    = bool
  default = true
}

variable "boot_time" {
  type    = string
  default = "1m"
}

variable "boot_key_interval" {
  type    = string
  default = "50ms"
}

variable "image_name" {
  type    = string
  default = "fortios"
}

variable "image_path" {
  default = "/var/lib/libvirt/images"
}

variable "out_dir" {
  type    = string
  default = "tmp_out"
}

source "qemu" "fortigate" {
  accelerator       = "kvm"
  cpus              = 1
  memory            = 2048
  skip_resize_disk  = true
  skip_compaction   = true
  disk_image        = true
  use_backing_file  = false
  disk_interface    = "virtio"
  disk_cache        = "none"
  format            = "qcow2"
  net_device        = "virtio-net"
  iso_checksum      = "none"
  iso_url           = "${var.image_path}/${var.image_name}"
  boot_wait         = "${var.boot_time}"
  boot_key_interval = "${var.boot_key_interval}"
  headless         = "${var.gui_disabled}"
  communicator     = "none"
  vm_name          = "fortigate-${var.version}.qcow2" 
  output_directory = "${var.out_dir}"
  boot_command = [
    "admin<enter><wait>",
    "<enter><wait>",
    "admin<enter><wait>",
    "admin<enter><wait10s>",
    "config system admin<enter><wait>",
    "edit vagrant<enter><wait>",
    "set accprofile super_admin<enter><wait>",
    "set password vagrant<enter><wait>",
    "set ssh-public-key1 \"ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ==\"<enter><wait>",
    "end<enter><wait>",
    "config system interface<enter><wait>",
    "edit port1<enter><wait>",
    "set vrf 1<enter><wait>",
    "set allowaccess ping http https ssh fgfm snmp<enter><wait>",
    "end<enter><wait>",
    "config system global<enter><wait>",
    "set admintimeout 60<enter><wait>",
    "set admin-ssh-grace-time 3600<enter><wait>",
    "end<enter><wait>",
    # New commands for configuring VPN certificate
    "config vpn certificate local<enter><wait>",
    "edit \"self-signed-cert-lab\"<enter><wait>",
    "set password ENC 6IJ1ofslBLj7beDO0B5Kzrqd+6RFyqhkhqk1uvFerYXitHSlDsliqPrDvsrQpj0fJyIGK3K+dPNZvavXMgVnPuS2sCrZnxhqWa5LaiRyM3bXwMX7JgPiVw4i4C4RSzNJIAdPURi8ubtD5izOaLPuPHVEfV/tPwehHHj5yspqv1dCFhEV57rT6NDTQJTtudAzshr4JA==<enter><wait>",
    "set comments \"Self-signed certificate for lab use\"<enter><wait>",
    "set private-key '-----BEGIN ENCRYPTED PRIVATE KEY-----<enter><wait>",
    "MIHjME4GCSqGSIb3DQEFDTBBMCkGCSqGSIb3DQEFDDAcBAhxU+ZrViGVQAICCAAw<enter><wait>",
    "DAYIKoZIhvcNAgkFADAUBggqhkiG9w0DBwQI+Xwuhtlk1OsEgZB50ZRRDDQrmUTB<enter><wait>",
    "TIESSnttkl6ahAjc/4zCxfpBDV2pk3CaQ9dvA5Pgw99NOPF9MPqX43EhdMxnxjhi<enter><wait>",
    "Uw4C+vyRY3oKHWoRdGayFAOOe0hLPnyxXt7yTV2ZRGMo321P0aJa8JVi2y/kM4Kz<enter><wait>",
    "Q/W1VQ7Tkmtoiyb6YG7TchqnVkUQwZFKpPWHCUIBRI5Y2Efaj1c=<enter><wait>",
    "-----END ENCRYPTED PRIVATE KEY-----'<enter><wait>",
    "set certificate '-----BEGIN CERTIFICATE-----<enter><wait>",
    "MIICZjCCAhCgAwIBAgIIC/SkcEXzHYEwDQYJKoZIhvcNAQELBQAwgakxCzAJBgNV<enter><wait>",
    "BAYTAlVTMRMwEQYDVQQIEwpDYWxpZm9ybmlhMRIwEAYDVQQHEwlTdW5ueXZhbGUx<enter><wait>",
    "ETAPBgNVBAoTCEZvcnRpbmV0MR4wHAYDVQQLExVDZXJ0aWZpY2F0ZSBBdXRob3Jp<enter><wait>",
    "dHkxGTAXBgNVBAMTEEZHVk1FVjAwMDAwMDAwMDAxIzAhBgkqhkiG9w0BCQEWFHN1<enter><wait>",
    "cHBvcnRAZm9ydGluZXQuY29tMB4XDTI0MDcxMzE1Mzk1NVoXDTM0MDcxMzIxNDM1<enter><wait>",
    "NVowgZYxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpDYWxpZm9ybmlhMRIwEAYDVQQH<enter><wait>",
    "EwlTdW5ueXZhbGUxETAPBgNVBAoTCEZvcnRpbmV0MRIwEAYDVQQLEwlGb3J0aUdh<enter><wait>",
    "dGUxEjAQBgNVBAMTCWxhYi5sb2NhbDEjMCEGCSqGSIb3DQEJARYUc3VwcG9ydEBm<enter><wait>",
    "b3J0aW5ldC5jb20wWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAARgjQ3HVPG7l2Ni<enter><wait>",
    "7H2rsue8uqopw148aQq1o6dT3c0BITzUrAg4qErNESs+Oo7X7Pqud2B5GItIx5IY<enter><wait>",
    "HjTOvD98ozAwLjAJBgNVHRMEAjAAMAsGA1UdDwQEAwIFoDAUBgNVHREEDTALggls<enter><wait>",
    "YWIubG9jYWwwDQYJKoZIhvcNAQELBQADQQCm2PLhHOfEClWAjFO+teRhJB3ZbkqS<enter><wait>",
    "OL3q4mUykroyqlByt6MlfjjWvrxmDGkZ3jhJ7fYBJ8jdTFr2A1seVFVS<enter><wait>",
    "-----END CERTIFICATE-----'<enter><wait>",
    "set source-ip 0.0.0.0<enter><wait>",
    "set ike-localid-type asn1dn<enter><wait>",
    "set enroll-protocol none<enter><wait>",
    "next<enter><wait>",
    "end<enter><wait>",
    "config system global<enter><wait>",
    "set admin-server-cert \"self-signed-cert-lab\"<enter><wait>",
    "end<enter><wait>",
    "config system settings<enter><wait>",
    "set gui-multiple-interface-policy enable<enter><wait>",
    "end<enter><wait>",
    # Shutdown command
    "execute shutdown<enter><wait>",
    "y<enter><wait>"
  ]
}

build {
  sources = ["source.qemu.fortigate"]
}
