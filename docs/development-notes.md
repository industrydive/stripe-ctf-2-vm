# Development Notes

## There is a Document Explaining How to Beat the Levels

But of course you'd have to know more than you currently do in order to locate
it. That document will never be added to this repo for all the obvious reasons.

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

## Using `--skip-to-postinstall` to Test the Provisioning Step

In `veewee-scripts/create-ctf-vm.sh` you will find the following command:

```
# Build the box.
#
# The commented --skip-to-postinstall is very useful when testing, as the full
# build takes forever.
bundle exec veewee vbox build "${DEF_NAME}" \
  --nogui --auto \
  --workdir=/Users/reason/Code/stripe-ctf-2-vm/veewee #--skip-to-postinstall
```

Uncomment `--skip-to-postinstall` in order to rapidly rerun the provisioning
process without going through the slow initial setup.
