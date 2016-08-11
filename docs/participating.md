# Participating in a CTF Event

Stripe's second CTF contest, held in 2012, was designed to teach some of the
basics of web security to an audience of developers of all skill levels. Here
that contest is packaged in a convenient Virtualbox VM for use in contests and
other group exercises.

There are nine puzzles of increasing difficultly. Your mission is simple: solve
the current puzzle to obtain the password that will unlock the next puzzle.
Start at level 0, and repeat until you succeed in level 8.

## Obtain the VM

The contest organizers will provide you with:

  * A link to a tar archive containing the VM files.
  * Credentials to log in to the VM via SSH.
  * Guidance on teams, collaboration, and discussion in the event.

Note that much of the VM is off-limits. Your user credentials provide very
limited sudo access and no access to other accounts.

## Install the VM

  * Install the latest version of [Virtualbox][1].
  * Unpack the archive containing the VM:

```
tar -xvzf ctf-vm.tar.gz`
```

  * Locate the `.ovf` file amongst the unpacked files
  * [Import][4] the `.ovf` file into Virtualbox to create the VM.

## Setup a Host-Only Network Adapter

Next set up a network adaptor for the server. Copy and paste the the following
commands in either OS X or Linux:

```
cat > /tmp/setup-ctf-adaptor.sh <<EOF
#!/bin/bash
DEF_NAME="stripe-ctf-2-ubuntu-14.04"
GATEWAY="192.168.57.1"

VBoxManage controlvm "\${DEF_NAME}" poweroff soft

if ifconfig | grep --quiet "\${GATEWAY}"; then
  cat <<TOF
One or more interfaces for gateway \${GATEWAY} already exist. List these interfaces with:

ifconfig

Then run the following command to delete each interface, where [name] is of the form "vboxnetN":

vboxmanage hostonlyif remove [name]

Then rerun this script to start the VM.

TOF
  exit 1
fi

INTERFACE=\`VBoxManage hostonlyif create\`
ARR=()
IFS="'" read -a ARR <<< "\${INTERFACE}"
INTERFACE="\${ARR[1]}"

VBoxManage hostonlyif ipconfig "\${INTERFACE}" --ip "\${GATEWAY}"
VBoxManage modifyvm "\${DEF_NAME}" --hostonlyadapter2 "\${INTERFACE}"
VBoxManage modifyvm "\${DEF_NAME}" --nic2 hostonly
VBoxManage startvm "\${DEF_NAME}" --type headless
EOF
chmod a+x /tmp/setup-ctf-adaptor.sh
/tmp/setup-ctf-adaptor.sh
```

This will add the necessary network adaptor and start the server running at the
IP address `192.168.57.2`. You can use the Virtualbox UI to start and stop the
server thereafter.

## Log In

Once you start the VM, you will need to log in in order to run server processes
and unlock puzzle levels. E.g. for user `ctf`:

```
ssh ctf@192.168.57.2

# If your Bash profile forces key authentication, you might need to do this
# instead:
ssh -o PubkeyAuthentication=no ctf@192.168.57.2
```

In your home directory, you find that each puzzle has a corresponding
subdirectory in ./levels and each one has a README.md file.

Initially will only be able to run the server for the first puzzle,
[level 0][3]. Find the source files and README.md for the puzzle in the VM under
`~/levels/0`.

## Play the Game...

Use the following workflow to work with a given level.

  1. `cd` to the level directory. E.g. `cd ~/levels/0`.
  2. Run the server for this level with the command `ctf-run <level>`. So for
level 0, enter `ctf-run 0`.
  3. Consult the level `README.md` file, e.g. `~/levels/0/README.md`, to find
the URL of the server. Load it and look over its web pages.
  4. View the `README.md` hints, the web application, and the source code in the
level directory or [the repository][2].
  5. Solve the puzzle! Some of the levels suggest that you might want to run the
code locally to better understand how to break it. This can be accomplished in
the VM, with a little work.
  6. Solving a level involves uncovering the password for the next level.
  7. Unlock the next level with the command `ctf-unlock <level> <password>`. So
for level 1, you would enter something along the lines of
`ctf-unlock 1 password-found-in-level-0`.
  8. Shut down the completed level using the command `ctf-halt <level>`. So for
level 0, enter `ctf-halt 0`.

Note that some levels require access to an earlier level in order to exploit a
vulnerability. This will be noted in the level `README.md`, and you will need to
`ctf-run` all the necessary levels in order to proceed.

## Rules of Engagement

### Be Inventive

There are all sorts of ways to attack code: bad parameters, XSS, SQL injection,
and more. Assume all of these are on the table.

### Collaborate

This is a learning exercise, and the best way to approach it is to work
together, especially in the later levels where the puzzle is much more
challenging.

### No Changing the Code! That Only Works for Captain Kirk.

All of the challenge levels can be broken through the web interface, with the
code running as it is presently written. Inspecting the code will lead you to
see how that can be accomplished.

### Victory is Obtaining the Secret From Level 8

Start with level 0 and work your way to level 8. Victory is obtained by
finding the key stored in level 8. You can verify that key with the contest
administrators.

## CTF Script Reference

### Unlock a Level

To unlock a given level:

```
ctf-unlock <level> <password>
```

You can only unlock a level if you have obtained its password from the prior
level.

### Run a Level

To run the server for a given level:

```
ctf-run <level>
```

You can only run the services for a level once it is unlocked, and unlocking
requires the password.

### Halt a Level

To halt the server for a given level:

```
ctf-halt <level>
```

[1]: https://www.virtualbox.org/wiki/Downloads
[2]: ../levels
[3]: ../levels/0
[4]: http://docs.oracle.com/cd/E26217_01/E26796/html/qs-import-vm.html
