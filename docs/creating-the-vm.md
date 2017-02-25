# Creating the Virtualbox VM

The Ubuntu 14.04 Virtualbox VM for the CTF contest is created via [Packer][2].
The scripts used in the creation process were developed for OS X, though should
run on other distributions - or at least only require minor changes. Anyone can
use the VM once it has been created, provided that they have Virtualbox
installed.

## Installation Requirements

* Install the latest version of [Virtualbox][1].
* Install [Git][3].

## Run the Installation Script

Run the installation script to install a recent version of Packer.

```
packer-scripts/install.sh
```

## Configure the Creation Process

The open `config/environment.sh` and edit it to set:

  * Name and password for the admin user.
  * Name and password for the CTF contestant user.

The admin user password must be changed if the intent is to create a useful
contest exercise, rather than a collaborative or teaching event. That password
should not be available to the contestants.

## Run the Creation Script

Next run the creation script. This will take a little while, and the Virtualbox
UI will be visible during the process. It can be left to run on its own until
it completes:

```
packer-scripts/create-ctf-vm.sh
```

## Export the VM

Lastly run the export script:

```
packer-scripts/export-ctf-vm.sh
```

The packaged VM archive file will be placed in the `dist` folder.

## Distributing the VM

To distribute the VM, upload it to a file sharing service such as Box, or to an
accessible location on AWS S3. Send an email to the contestants to provide each
of them with:

  * Links to the [participant instructions][4] and [CTF code][5] in this
repository.
  * A link or instructions to download the VM.
  * The CTF user name and password.

[1]: https://www.virtualbox.org/wiki/Downloads
[2]: https://www.packer.io/
[3]: https://git-scm.com/
[4]: ./participating.md
[5]: ../levels
