<img alt="Vagrant" src="https://img.shields.io/badge/vagrant%20-%231563FF.svg?&style=for-the-badge&logo=vagrant&logoColor=white"/>

# Fortinet FortiGate Vagrant box

A Packer template for creating a Fortinet FortiGate Vagrant box for the [libvirt](https://libvirt.org) provider.

## Prerequisites

  * [Fortinet](https://support.fortinet.com) account
  * [Git](https://git-scm.com)
  * [Packer](https://packer.io) >= 1.70
  * [libvirt](https://libvirt.org)
  * [QEMU](https://www.qemu.org)
  * [Vagrant](https://www.vagrantup.com) >= 2.2.10, != 2.2.16
  * [vagrant-libvirt](https://github.com/vagrant-libvirt/vagrant-libvirt)

## Steps

1\. Verify the prerequisite tools are installed.

```
which git unzip packer libvirtd qemu-system-x86_64 vagrant
vagrant plugin list
vagrant-libvirt (0.9.0, global)
```

2\. Log in and download the _FortiGate for KVM platform_ package from [Fortinet](https://docs.fortinet.com/document/fortigate-private-cloud/7.0.14/kvm-administration-guide/706376/about-fortigate-vm-on-kvm). Save the file to your `Downloads` directory.

3\. Extract the disk image file to the `/var/lib/libvirt/images` directory.

```
cd HOME/Downloads
sudo unzip -d /var/lib/libvirt/images FGT_VM64_KVM-v7.0.14.F-build1157-FORTINET.out.kvm.zip
```

4\. Modify the file ownership and permissions.

```
sudo chown libvirt-qemu:kvm /var/lib/libvirt/images/fortios-7.0.14.qcow2
sudo chmod u+x /var/lib/libvirt/images/fortios-7.0.14.qcow2
```

5\. Clone this GitHub repo and _cd_ into the directory.

```
git clone https://github.com/celeroon/fortigate-vagrant-libvirt
cd fortigate-vagrant-libvirt
```

6\. Packer _build_ to create the Vagrant box artifact. Supply the FortiOS version number for the `version` variable value and `image name`.

```
packer build -var "version=7.0.14" -var "image_name=fortios-7.0.14.qcow2" fortigate-ssl-vrf.pkr.hcl
```

If you encounter issues, run with debug logging enabled:

```bash
PACKER_LOG=1 packer build -var "version=7.0.14" -var "image_name=fortios-7.0.14.qcow2" fortigate-ssl-vrf.pkr.hcl
```

7\. Move the Vagrant box artifact to the `/var/lib/libvirt/images` directory.

```
sudo mv ./builds/fortinet-fortigate-7.0.14.box /var/lib/libvirt/images
```

8\. Copy the box metadata file to the `/var/lib/libvirt/images` directory.

```
sudo cp ./src/fortigate.json /var/lib/libvirt/images
```

9\. Substitute the `VER` placeholder string with the FortiOS version you're using.

```
vm_version="7.0.14"
sudo sed -i "s/\"version\": \"VER\"/\"version\": \"$vm_version\"/; s#\"url\": \"file:///var/lib/libvirt/images/fortinet-fortigate-VER.box\"#\"url\": \"file:///var/lib/libvirt/images/fortinet-fortigate-$vm_version.box\"#" /var/lib/libvirt/images/fortigate.json
```

10\. Add the Vagrant box to the local inventory.

```
vagrant box add --box-version 7.0.14 /var/lib/libvirt/images/fortigate.json
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
