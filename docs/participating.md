# Participating in the CTF Contest

The second Strip CTF contest is an exercise for web developers at all levels of
skill designed to teach some of the basics of web security. There are nine
puzzles, each with its own set of code to inspect, the first being the easiest
and the last the hardest. To progress to the next puzzle you must solve the
current puzzle.

## Obtain the VM

You should have been provided with a zipped archive containing the VM files by
the contest organizer and the credentials necessary to log in and start, stop,
or unlock the servers for each level. You have only very limited sudo access and
no access to other accounts. That would be too easy.

The user you will use to log in is probably `ctf`. Check with the organizer.

## Install Requirements

The only requirement is to install the latest version of [Virtualbox][1].

Then unzip the archive containing the VM and open the `.ovf` file to import
the VM into Virtualbox. Once imported, start the VM. It will run at the
IP address 192.168.57.2.

## Getting Started

You will need to log in to the VM in order to run server processes and unlock
puzzle levels. E.g. for user `ctf`:

```
ssh ctf@192.168.57.2
```

You will also need to inspect the puzzle code and `README.md` documents as you
progress in the contest. These can be found in the [levels directory][2], and
the first puzzle is ready and waiting under [levels/0][3].

Lastly, you will need a web browser open to load pages from the VM server
processes. Get started by looking at the [level 0 README.md][3] file for
context, and start the service running with the following command while logged
in to the VM:

```
ctf-run 0
```

## Unlocking the Next Level

When you have obtained the password to the next level, you can unlock that level
by logging into the VM to use the `ctf-unlock` script.

```
ctf-unlock <level> <password>
```

You can only run the services for a level once it is unlocked in this was, and
unlocking requires the password.

## Running and Halting a Level

To run the server for a given level:

```
ctf-run <level>
```

To halt it:

```
ctf-halt <level>
```

## Investigating the Level Code

If you log into the VM you'll find a copy of the level code in your home
directory. Some of the levels suggest that you might want to run the code
locally to get a better idea as to how to break it. You can do this in the VM.

## Rules of Engagement

### Be Inventive

There are all sorts of ways to attack code: bad parameters, XSS, SQL injection,
and more. Assume all of these are on the table.

### No changing the code! That only works for Captain Kirk.

All of the challenge levels can be broken through the web interface, with the
code running as it is presently written. Inspecting the code will lead you to
how that can be done.

[1]: https://www.virtualbox.org/wiki/Downloads
[2]: ../levels
[3]: ../levels/0
