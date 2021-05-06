# Stripe Capture the Flag (CTF) 2 in a Virtualbox VM

This repository provides the [2012 Stripe CTF 2.0 contest][1] suitable for conducting group
exercises with a minimum of technical preparation.

The Capture the Flag (CTF) contest is an exercise for developers at all levels
of experience, designed as a teaching aid to cover some of the basics of web
security. There are nine puzzles in the contest, each with its own set of code
to inspect and server to exploit, the first being the easiest and the last the
hardest. To progress to the next puzzle you extract a password by finding and
exploiting the security flaws in the current puzzle.

--

## Log In

Once you start the VM, you will need to log in in order to run server processes
and unlock puzzle levels. E.g. for user `ctf`:

```
ssh ctf@ctf.dive.tools

# If your Bash profile forces key authentication, you might need to do this
# instead:
ssh -o PubkeyAuthentication=no ctf@ctf.dive.tools
```

In your home directory, you find that each puzzle has a corresponding
subdirectory in ./levels and each one has a README.md file.

Initially will only be able to run the server for the first puzzle,
[level 0][3]. Find the source files and README.md for the puzzle in the VM under
`~/levels/0`.

## Play the Game...

Use the following workflow to work with a given level.

  1. Run the server for this level with the command `ctf-run <level>`. So for
level 0, enter `ctf-run 0`. Don't execute this command in the copy of the level
directory at `~/levels/0`. You want to run the `/usr/local/bin/ctf-run` script,
not the `~/levels/0/ctf-run.sh` script.
  2. Consult the level `README.md` file, e.g. `~/levels/0/README.md`, to find
the URL of the server. Load it and look over its web pages.
  3. View the `README.md` hints, the web application, and the source code in the
level directory or [the repository][2].
  4. Solve the puzzle! Some of the levels suggest that you might want to run the
code locally to better understand how to break it. This can be accomplished in
the VM, with a little work.
  5. Solving a level involves uncovering the password for the next level.
  6. Unlock the next level with the command `ctf-unlock <level> <password>`. So
for level 1, you would enter something along the lines of
`ctf-unlock 1 password-found-in-level-0`.
  7. Shut down the completed level using the command `ctf-halt <level>`. So for
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
