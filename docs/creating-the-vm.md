# Creating the Virtualbox VM

The Ubuntu 14.04 Virtualbox VM for the CTF contest is created via [Veewee][3].
At the present time only OS X is supported for the creation process, though
anyone can use the VM once it has been created.

## Install Requirements

* Install the latest version of [Virtualbox][1].
* Install [Homebrew][2].

Next run the installation script to install other dependencies such as the
[Ruby Version Manager (RVM)][4] and Veewee.

```
veewee-scripts/install.sh
```

## Configure the Creation Process

The open `config/environment.sh` and edit it to set:

* Name and password for the admin user.
* Name and password for the CTF contestant user.
* IP address and other details for VM.

You MUST change the admin user password if you want this to be a useful
exercise. That password should not be available to the contestants.

## Run the Creation Script

Next run the creation script. This will take a little while, and the Virtualbox
UI will be visible during the process. You can leave it to run on its own until
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

To distribute the VM, upload it to a file share - such as Box - or S3. Send an
email to the contestants to provide each of them with:

* Links to the instructions and CTF code in this repository.
* Where to download the VM.
* The CTF user name and password.

[1]: https://www.virtualbox.org/wiki/Downloads
[2]: http://brew.sh/
[3]: https://github.com/jedi4ever/veewee
[4]: https://rvm.io/
