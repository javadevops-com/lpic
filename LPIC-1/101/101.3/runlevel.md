## 101.3 Change runlevels / boot targets and shutdown or reboot system
Unix design **principles** is the employment of **separate processes** to control distinct functions of the system. these Process Called **daemons** or **services**.

### daemons
- Which daemons should be active depends on the purpose of the system
- The set of active daemons should also be **modifiable** at **runtime**, so services can be started and stopped without having to reboot the whole system
- Services can be controlled by shell scripts or by a program and its supporting configuration files.
  - SysVinit(system V, SysV)
  - systemd
  - upstar


#### SystemVinit
provide **predefined** *sets* of system states, called `runlevels`, and their corresponding service script files to be executed.
- Runlevels are numbered **0 to 6**, being generally assigned to the following purposes
  - Runlevel 0 System shutdown.
  - Runlevel 1, s or single Single user mode, without network and other non-essential capabilities (maintenance mode). 
  - Runlevel 2, 3 or 4 Multi-user mode. Users can log in by console or network. Runlevels 2 and 4 are not often used.
  - Runlevel 5 Multi-user mode. It is equivalent to 3, plus the graphical mode login.
  - Runlevel 6 System restart.
- The program responsible for managing runlevels and associated daemons/resources is `/sbin/init`. 
- the init program identifies the requested runlevel, defined by a **kernel parameter** or in the `/etc/inittab`
-  **Every runlevel** may have many **associated service** files, usually scripts in the `/etc/init.d/` 
-  The Available Action on `/etc/inittab` are:
   -   boot
        The process will be executed during system initialization. The field runlevels is ignored.
   - bootwait
        The process will be executed during system initialization and init will wait until it finishes to continue. The field runlevels is ignored.
   - sysinit
    The process will be executed after system initialization, regardless of runlevel. The field runlevels is ignored.
   - wait
    The process will be executed for the given runlevels and init will wait until it finishes to continue.
   - respawn
    The process will be restarted if it is terminated.
   - ctrlaltdel
    The process will be executed when the init process receives the SIGINT signal, triggered when the key sequence of Ctrl  +  Alt  +  Del is pressed.

  Every runlevel has an associated directory in `/etc/`, named `/etc/rc0.d`/, `/etc/rc1.d/`, `/etc/rc2.d/`,etc.

#### Systemd
Currently, `systemd` is the most widely used set of tools to manage system resources and services, which are referred to as **units** by systemd.
  System Units:
  - `service` The **most common unit type**, for active system resources that can be initiated, interrupted and reloaded.- `socket` The socket unit type can be a filesystem socket or a network socket. **All socket units have a corresponding service unit, loaded when the socket receives a request**.
  - `device` A device unit is associated with a hardware device **identified by the kernel**. A device will only be taken as a systemd unit if a udev rule for this purpose exists. A device unit can be used to resolve configuration dependencies when certain hardware is detected, given that properties from the udev rule can be used as parameters for the device unit.
  - `mount` A mount unit is a mount point definition in the filesystem, similar to an entry in `/etc/fstab`.
  - `automount` An automount unit is also a mount point definition in the filesystem, but **mounted automatically**. **Every automount unit has a corresponding mount unit, which is initiated when the automount mount point is accessed**.
  - `target` A target unit is a **grouping of other units**, managed as a single unit.
  - `snapshot` A snapshot unit is a **saved state of the systemd manager** (not available on every Linux
distribution).

The systemctl command **can also control system targets**
Command `systemctl isolate` alternates **between different targets**


#### Upstart
Every Upstart action has its own independent command
scripts used by Upstart are located in the directory `/etc/init/` and for controling `initctl list`

Upstart does not use the `/etc/inittab` file to define runlevels, but the legacy commands `runlevel` and `telinit` can still be used to verify and alternate between runlevels

#### Shutdown and Restart
traditional command used to shutdown or restart the system is `shutdown` it **automatically notifies** all logged-in users with a warning message in their shell sessions and new
logins are prevented. After `shutdown` is executed, all processes receive the `SIGTERM` signal, followed by the `SIGKILL` signal, then the system shuts down or changes its runlevel.  when neither options `-h` or `-r `are used, the system alternates to **runlevel 1**
`shutdown [option: hh:mm, +m, now, +0 ] time [message]`

##### wall
it is important to warn logged-in users so that they are not harmed by an abrupt termination of their activities.
**Similar** to what the `shutdown` command does when powering off or restarting the system, the `wall` command is able to send a message to terminal sessions of all logged-in users

>  Linux utilizes a monolithic kernel, many low level aspects of the operating system are affected by daemons

> The telinit q command should be executed every time after the /etc/inittab file is modified.
The argument q (or Q) tells init to reload its configuration 

> The main command for controlling systemd units is `systemctl` 
> - systemctl start unit.service
> - systemctl stop unit.service
> - systemctl status unit.service
> - systemctl restart unit.service
> - systemctl enable unit.service
> - systemctl disable unit.service
> - systemctl is-active unit.service
> - systemctl is-enable unit.service
> - systemctl cat unit.service
> - systemctl set-default multi-user.target(runlevel.target)
> - systemctl get-default
> - systemctl list-unit-files --type=UNIT_TYPE
> - systemctl list-units --type=service
> - systemctl suspend
> - systemctl hibernate
> - systemctl reboot
> - systemctl poweroff

> systemd **does not** use the `/etc/inittab` file 

> The **configuration files associated with every unit** can be found in the `/lib/systemd/system/` directory

> systemd is also responsible for **triggering** and **responding** to ***power related events***

> The `acpid` daemon is the main power manager for Linux and allows finer adjustments to the actions following power related events, like closing the laptop lid, low battery or battery charging levels.

> `sudo which poweroff`