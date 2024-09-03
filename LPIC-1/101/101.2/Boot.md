## 101.2 Boot the System

### The Boot Process
Bootloader initializes the minimum hardware needed to boot the system and then finds and runs the OS.
>the **kernel** must be **loaded** by a program called a **bootloader** which itself is **loaded** by a **pre-installed firmware** such as **BIOS** or **UEFI**
- BIOS
    - Master Boot Record will be used (1 sector)
    - the first 440 bytes in the first storage device(also called **bootstrap**)
- UEFI
  - EFI System Partition (ESP), UEFI does not rely on the MBR
  - The standard compatible filesystems are FAT12,
FAT16 and FAT32 for block devices and ISO-9660 for optical media
  - `/boot/efi`
---
1. Motherboard Firmware does a POST (PowerOnSelfTest)
2. The BIOS activates the basic components to load the system, like video output, keyboard and storage media.
3. Motherboard loads the bootloader
4. Bootloader loads the Linux Kernel-based on its configs/commands
5. The Kernel loads and prepares the system (root filesystem) and runs the **initialization** program
6. **Init** program start the service, other programs, ... (web server, graphical interface, networking, etc.)
---
>dmesg:Linux will show you the ***boot process logs during the boot***. Some desktop systems hide this behind a fancy boot splash which you can hide using the Esc key or press Ctrl+Alt+F1. 

>**Virtual Machine** usualy use **BIOS** as defult *Bootloader*.

## Initialization Inspection
The memory space where the kernel stores its messages, including the boot messages, is called the `kernel ring buffer`. 
- `/var/log/dmesg`
- `dmesg -h`  human readable
- `journalctl --list-boots`
- `journalctl -k`(kernel)
- `journalctl -b NUMBER_OF_BOOT`(boot)
- `journalctl -u kernel`
- `/var/log/boot | /var/log/boot.log`
  
---
## The Bootloader
The most popular bootloader for Linux in the x86 architecture is **GRUB** (Grand Unified Bootloader).

### **/var/log/messages | /var/log/syslog**
After the init process comes up, syslog daemon will log messages

> When the Kernel finished its initialization, its time to start other programs
## System Initialization
The `init` program is responsible for running all initialization scripts and system daemons
There are different init systems:
- **SysVinit** is based on Unix System V. Not being used much but people loved it and you may see it on older machines or even on recently installed ones
- **systemd** is the new replacement. Some people hate it but it is being used by all the major distros. Can start services in parallel and do lots of fancy stuff!
- **upstart** was an event-based replacement for the traditional init daemon. The project was started in 2014 by Canonical (the company behind Ubuntu) to replace the SysV but did not continue after 2015 and Ubuntu is now using the systemd as its init system.

**The init process had the ID of 1 and you can find it by running the** 
>You can check the hierarchy of processes using the `pstree` command.
---

- ### systemd
  The systemd is made around units. A unit can be a service, group of services, or an action. Units do have a name, a type, and a configuration file. There are 12 unit types: automount, device, mount, path, scope, service, slice, snapshot, socket, swap, target & timer.
  
  >We use `systemctl` to work with these units and `journalctl` to see the logs.

  *The units can be found in these places (sorted by **priority**)*
  - `/etc/systemd/system`
  - `/run/systemd/system`
  - `/usr/lib/systemd/system`

  #### runlevels
  A service manager based on the SysVinit standard controls which daemons and resources will be available by employing the concept of runlevels. Runlevels are numbered 0 to 6 and are designed by the distribution maintainers to fulfill specific purposes. The only runlevel definitions shared between all distributions are the runlevels 0, 1 and 6.


- `/etc/systemd/system/`
- `/run/systemd/system/`
- `/usr/lib/systemd/system` 
- ### SysV
  `/etc/init.d/service|units`

  **The control files are located at `/etc/init.d/`**

---
> Services, also known as **daemons**

> The kernel will then open the `initramfs` (initial RAM filesystem).
> As soon as the root filesystem is available, the kernel will mount all filesystems configured in `/etc/fstab` and then will execute the first program

> kernel ring buffer loses all messages when the system is turned off or by executing the
command `dmesg --clear` 