# QEMU Installation

Run the following command:

```sh
brew install qemu 
```

libvirt, clang (or gcc), ruby, ruby-build, rbenv, libiconv, libxml2.

Please confirm the necessity of all the above dependencies.

# Create disk image for QEMU

> qcow is a file format for disk image files used by QEMU, a hosted virtual machine monitor. It stands for “QEMU Copy On Write” and uses a disk storage optimization strategy that delays the allocation of storage until it is needed.

This command will create a 10 GB qcow2 image to install the an OS:  

```sh
qemu-img create -f qcow2 <file name>.qcow2 5G
```

# Start VM

```sh
qemu-system-x86_64 \
  -machine accel=hvf \
  -cpu Nehalem \
  -smp 2 \
  -hda <file path>.qcow2 \
  -cdrom <file path>.iso \
  -m 4G \
  -vga virtio \
  -usb \
  -device usb-tablet \
  -display default,show-cursor=on
```

https://wiki.gentoo.org/wiki/QEMU/Options

Add the following flag to enable HVF for almost native performance

https://wiki.qemu.org/Hosts/Mac

```sh
-accel hvf
```

# Error HVF

Since the latest update for macOS (2018), Apple has made changes to the hypervisor entitlements.

> Entitlements are key-value pairs that grant an executable permission to use a service or technology. In this case the QEMU binary is missing the entitlement to create and manage virtual machines.

To fix the issue all we have to do is add the entitlement to the qemu-system-x86_64 binary.

First we need to create an XML file:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.security.hypervisor</key>
    <true/>
</dict>
</plist>
```

... and run the following command:

```sh
codesign -s - --entitlements entitlements.xml --force /usr/local/bin/qemu-system-x86_64
```

This enables HVF without having any errors occurring. [source](https://www.arthurkoziel.com/qemu-on-macos-big-sur/)
