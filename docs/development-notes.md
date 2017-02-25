# Development Notes

## Organization of the VM

By default the following organization is used, but the `config/environment.sh`
file allows for some of these paths and names to be changed:

* The `ubuntu` user has sudo access.
* `ctf-*` scripts are added to `/usr/local/bin`
* The `ctf` user is given sudo permissions to run the `ctf-*` scripts, but
otherwise has no sudo access.
* Levels are stored under `/var/ctf/levels`
* Passwords are stored in `/var/ctf/passwords.txt` and in per-level files.
* Levels are marked unlocked with a file `/var/ctf/levels/<level>.unlocked`.

## `rm /EMPTY`

If developing on the VM without exporting it you will want to run `rm /EMPTY`
before starting to ensure that it doesn't fill up.
