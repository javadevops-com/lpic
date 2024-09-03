## 101.1 Determine and configure hardware settings

### Device Activation
The system configuration utility is presented after pressing a specific key when the computer is **turned on** 
usually it is `Del` or one of the function keys, such as `F2` or `F12` .
### Device Inspection in Linux
There are two basic ways to identify hardware resources on a Linux system: 
- to use specialized commands
  - `lspci`
    - The hexadecimal numbers at the beginning of each line are the unique addresses of the corresponding PCI device `00:1f.2`
    - shows more details about a specific device `lspci -s 00:1f.2 -v` 
    - The kernel module can be identified in the line `kernel driver in use` **OR** `lspci -s 00:1f.2 -k`

  - `lsusb`
    - Command lsusb shows the available USB channels and the devices connected to them
    - specific device can be selected for inspection by **providing its ID** to the option *-d* `lsusb -v -d 1d6b:0001`
    - `lsusb -t` shows the current USB device mappings as a hierarchical tree
      - When a matching module exists, its name appears at the end of the line for the device, as in `Driver=btusb`.
    - `lsusb -s 001:002`  verify which device is using the module
  - `lsmod` 
    - shows all currently loaded modules
  - `modprobe`
    - used to both load and to unload kernel modules
    - `modprobe -r`  unload a module and its related modules
    - t is possible to change module parameters when the kernel is being loaded 
  - `modinfo -p module_name`
    - shows a description, the file, the author, the license, the identification, the dependencies and the available parameters for the
given module
- to read specific files inside special filesystem

### Information Files and Device Files
hardware information stored by the **operating system**. This kind of information is kept in special files in the directories `/proc`
and `/sys`.

These directories are **mount points to filesystems** not present in a device partition, but only in **RAM** space used by the kernel to store runtime configuration and information on running
processes. Such filesystems are not intended for conventional file storage, so they are called **pseudo-filesystems** and *only exist while the system is running*

- `/proc` 
  - files with information regarding **running processes and hardware resources**
  - `/proc/cpuinfo`
  - `/proc/interrupts`
  - `/proc/ioports`
  - `/proc/dma`
- `/sys`
  - have similar roles to those in `/proc`. However, the `/sys` directory has the specific purpose of **storing device information and kernel data related to hardware**
- `/dev`
  - Every file inside `/dev` is associated with a system device, particularly *storage devices*

### Storage Devices
In Linux, storage devices are generically referred as **block** devices, because data is read to and from these devices in blocks of buffered data with different sizes and positions.
- Every block device is identified by a file in the `/dev` directory, with the name of the file depending on the
device type (`IDE`, `SATA`, `SCSI`, etc.) and its partitions. `CD/DVD` and `floppy` devices
- From Linux kernel version 2.4 onwards, most storage devices are now identified as if they were `SCSI` devices, regardless of their hardware type. `IDE`, `SSD` and `USB` block devices will be prefixed
by `sd`
- The exception to this pattern occurs with memory cards (SD cards) and NVMe devices (SSD connected to the PCI Express bus)



---
> BIOS (Basic Input/Output System)
> *replace the BIOS with a new implementation called UEFI*

> UEFI (Unified Extensible Firmware Interface)
>  *has more sophisticated features for identification, testing, configuration and firmware upgrades. Despite the change, it is not uncommon to still call the configuration utility BIOS, as both implementations fulfill the same basic purpose*

> PCI (Peripheral Component Interconnect)
>  *like disk controller, or an expansion card fitted into a PCI slot, like an external graphics card*

> USB (Universal Serial Bus) 
> *the USB interface is largely used to connect input devices — keyboards, pointing devices — and removable storage media*

> IRQ (interrupt request)

> DMA (directmemory access)

> Driver: Linux kernel modules related to hardware devices are also called drivers, as in other operating systems. 

>  `kmod` package, which is a set of tools to handle common tasks with Linux kernel modules like insert, remove, list, check properties, resolve dependencies and aliases. 

> If a module is causing problems, the file `/etc/modprobe.d/blacklist.conf` can be used to block the loading of the module 

>  A legacy IDE hard drive ---> `/dev/hda1`

> Removable devices are handled by the `udev` subsystem
The Linux kernel captures the hardware detection event and passes it to the `udev` process, which then identifies the device and dynamically creates corresponding files in `/dev`, using pre-defined rules.

>In current Linux distributions, `udev` is responsible for the identification and configuration of the devices already present during machine power-up (coldplug detection) and the devices identified while the system is running (hotplug detection). Udev relies on `SysFS`, the p`seudo filesystem` for
hardware related information mounted in `/sys` pre-defined rules stored in the directory `/etc/udev/rules.d/`

> CD/DVD drive connected to the second IDE channel will be identified as /dev/hdc (`/dev/hda `and `/dev/hdb` are reserved for the master and slave devices on the first IDE channel)

>  floppy drive will be identified as /dev/fdO

> SD cards, the paths `/dev/mmcblk0p1`

>  NVMe devices receive the prefix nvme, as in `/dev/nvme0n1p1`