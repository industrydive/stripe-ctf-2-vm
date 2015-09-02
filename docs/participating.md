# Participating in the CTF Contest

Stripe's second CTF contest was designed to teach some of the basics of web security to web developers of skill levels. We have revived the contest in a convenient VM.

There are nine puzzles of increasing difficultly. Your mission is simple: solve the current puzzle in order to unlock the next puzzle. Repeat until you pwn level 8.

## Obtain the VM

The contest organizers must provide you with:

* A link to a tar archive containing the VM files.
* Credentials to log in to the VM via SSH.

Note that much of the VM is off-limits. Your user credentials has very limited sudo access and no access to other accounts.

## Install the VM

* Install the latest version of [Virtualbox][1].
* Unpack the archive containing the VM: `tar -xvzf ctf-vm.tar.gz`
* Locate the `.ovf` file amongst the unpacked files
* [Import][4] the `.ovf` file into Virtualbox to make a VM

## Setup a Host-Only Network Adapter

Next set up a network adaptor for the server. Run the the following commands
in either OS X or Linux:

```
cat > /tmp/setup-ctf-adaptor.sh <<EOF
#!/bin/bash
DEF_NAME="stripe-ctf-2-ubuntu-14.04"
GATEWAY="192.168.57.1"

vboxmanage controlvm "\${DEF_NAME}" poweroff soft

INTERFACE=\`vboxmanage hostonlyif create\`
ARR=()
IFS="'" read -a ARR <<< "\${INTERFACE}"
INTERFACE="\${ARR[1]}"

vboxmanage hostonlyif ipconfig "\${INTERFACE}" --ip "\${GATEWAY}"
vboxmanage modifyvm "\${DEF_NAME}" --hostonlyadapter2 "\${INTERFACE}"
vboxmanage modifyvm "\${DEF_NAME}" --nic2 hostonly
vboxmanage startvm "\${DEF_NAME}" --type headless
EOF
chmod a+x /tmp/setup-ctf-adaptor.sh
/tmp/setup-ctf-adaptor.sh
```

These commands will add the necessary network adaptor and start the server
running at the IP address 192.168.57.2. You can use the Virtualbox UI to start
and stop the server thereafter.

## Log In

Once you start the VM, you will need to log in in order to run server processes and unlock
puzzle levels. E.g. for user `ctf`:

```
ssh ctf@192.168.57.2
```
In your home directory, you find that each puzzle has a corresponding subdirectory in ./levels and each one has a README.md file.

You will only be able to execute the first puzzle, [level 0][3]. You can find the source files and README.md on the VM by doing `cd levels/0`.

## Play the Game...

Heres the basic worflow to solving each puzzle...

1. `cd` to the puzzle directory. 
2. Run the puzzle by `ctf-run <level>`. So for puzzle 0, you would execute `ctf-run 0`.
3. Consult the README.md file for the no active web app's url and browse there.
4. Leverage the web app and its source code (which can be found either in the levels subdirectories on the VM or [in the repository][2]).
5. Solve the puzzle. Should be simple, right? Some of the levels suggest that you might want to run the code locally to get a better idea as to how to break it. You can do this in the VM,
with a little work.
6. The loot for each level is the password for the next level. If you have that in hand, you've beaten the puzzle.
7. Unlock the next level by `ctf-unlock <level> <password>`. So for puzzle 1, you would execute something like `ctf-unlock 1 totally-fake-password`.
8. Lather, rinse, repeat.

N.B. That some levels require access to an earlier level. You will need to `ctf-run` those if you have halted them.


## Rules of Engagement

### Be Inventive

There are all sorts of ways to attack code: bad parameters, XSS, SQL injection,
and more. Assume all of these are on the table.

### Collaborate

This is a learning exercise, and the best way to approach it is to work
together, especially in the later levels where the puzzle is much more
challenging.

### No changing the code! That only works for Captain Kirk.

All of the challenge levels can be broken through the web interface, with the
code running as it is presently written. Inspecting the code will lead you to
how that can be done.

### Victory is Obtaining the Secret From Level 8

You start with level 0, and work your way to level 8. Victory is obtained by
finding the key stored in level 8. You can verify that key with the contest
administrators.


## CTF Script Reference
### Unlock a Level

To unlock a given level:

```
ctf-unlock <level> <password>
```
You can only unlock the next level if you have looted its password out the current puzzle.

### Run a Level

To run the server for a given level:

```
ctf-run <level>
```

You can only run the services for a level once it is unlocked in this was, and
unlocking requires the password.

### Halt a Level

To halt a given level:

```
ctf-halt <level>
```


[1]: https://www.virtualbox.org/wiki/Downloads
[2]: ../levels
[3]: ../levels/0
[4]: http://docs.oracle.com/cd/E26217_01/E26796/html/qs-import-vm.html
