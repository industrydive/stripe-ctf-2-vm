# Stripe Capture the Flag (CTF) 2 in a Virtualbox VM

This repository provides the [2012 Stripe CTF 2.0 contest][1] in the form of a
Virtualbox VM, generated with [Veewee][2], suitable for conducting group
exercises with a minimum of technical preparation.

The Capture the Flag (CTF) contest is an exercise for developers at all levels
of experience, designed as a teaching aid to cover some of the basics of web
security. There are nine puzzles in the contest, each with its own set of code
to inspect and server to exploit, the first being the easiest and the last the
hardest. To progress to the next puzzle you extract a password by finding and
exploiting the security flaws in the current puzzle.

The instructions included here guide a group administrator to build the VM that
will be used by all participants in an exercise. The participants then download
and individually install a personal copy of the VM that each will use over the
course of the CTF event.

At Bazaarvoice we have found that running through the first four or five levels
in a group exercise with ten to twenty developers, split into small teams, takes
about three hours and provides a good introduction to web security concepts.
Expect to spend 15-30 minutes examining and solving a puzzle, with a 5-10 minute
discussion after each, which can be used to elaborate on the vulnerabilities
used and their relevance to current development work.

* [Administrators: Creating the Virtualbox VM][3]
* [Participants: Taking Part in the CTF Contest][4]
* [Development Notes][5]

[1]: https://github.com/stripe-ctf/stripe-ctf-2.0
[2]: https://github.com/jedi4ever/veewee
[3]: ./docs/creating-the-vm.md
[4]: ./docs/participating.md
[5]: ./docs/development-notes.md
