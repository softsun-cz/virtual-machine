# About

**Softsun Virtual Machine** is a shell installation script for Debian Linux that helps you to easily install Virtual Machine environment on your server. It is designed for **Debian Linux 9 x64**, other versions / architectures of Debian or other Linux distributions might require some changes in script, otherwise it probably will not work.

**What does this script do?**

Installed and preconfigured software:
- QEMU / KVM (virtual machine)
- nginx + PHP 7.0 (web server for web administration)
- SSH server (remote console access)
- FERM (firewall)
- few other packages and its dependencies

# How to install

1. Install [Debian Linux 9.x from "netinst" minimal installation ISO image](https://www.debian.org/CD/netinst/) on your server
2. Log in and run:

```sh
apt-get -y install git
git clone https://github.com/softsun-cz/virtual-machine.git
cd virtual-machine 
chmod +x ./install.sh
./install.sh
```

3. This script will automatically reboot your server after the installation
4. Access your server web administration from your web browser on your client machine via https://[YOUR-SERVER-IP]
5. Log in as "root" with the same password you use when accessing server shell

# License

This software is developed as open source under [MIT License](./LICENSE)
