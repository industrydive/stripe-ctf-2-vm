# Creating the Virtualbox VM

The Ubuntu 14.04 Virtualbox VM for the CTF contest is created via [Veewee][3].
The scripts used in the creation process were developed for OS X, though should
run on other distributions - or at least only require minor changes. Anyone can
use the VM once it has been created, provided that they have Virtualbox
installed.

## Installation Requirements

* Install the latest version of [Virtualbox][1].
* Install [Git][5].
* Install [Homebrew][2] if using OS X.

## Run the Installation Script

Run the installation script to install the needed tools, including the
[Ruby Version Manager (RVM)][4] and Veewee.

```
veewee-scripts/install.sh
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
veewee-scripts/create-ctf-vm.sh
```

## Export the VM

Lastly run the export script:

```
veewee-scripts/export-ctf-vm.sh
```

The packaged VM zip file will be placed in the `dist` folder.

## Distributing the VM

To distribute the VM, upload it to a file sharing service such as Box, or to an
accessible location on AWS S3. Send an email to the contestants to provide each
of them with:

  * Links to the [participant instructions][6] and [CTF code][7] in this
repository.
  * A link or instructions to download the VM.
  * The CTF user name and password.

[1]: https://www.virtualbox.org/wiki/Downloads
[2]: http://brew.sh/
[3]: https://github.com/jedi4ever/veewee
[4]: https://rvm.io/
[5]: https://git-scm.com/
[6]: ./participating.md
[7]: ../levels
