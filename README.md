NES-breakout
====================

This is an implementation of the classic arcade game [Breakout](http://en.wikipedia.org/wiki/Breakout_(video_game)) for the Nintento Entertainment System (NES).

The executable is (.nes) is included in the repository an can be run in a NES emulator. I am using the [CC65 compiler](http://www.cc65.org/index.php) available at ftp://ftp.musoftware.de/pub/uz/cc65/

Code documentation is available at the [wiki](https://github.com/89erik/NES-breakout/wiki/Code-documentation).

To get started, I have been following a guide by Johan Fjeldtvedt, available [here](http://www.diskusjon.no/index.php?showtopic=519922). The guide is in Norwegian. 


#Conventions#
###Variable names###
Smallcaps. Words are divided by underscore.

###Global sub routines###
Camelcase. First letter is capitalized.

###Local sub routines###
As global sub routines, but prefixed with @.

###Local labels###
As variable names, but prefixed with @.

###Parameter passing###
Usually by register A. Sometimes also with X and Y. Sometimes by global variables sub_routine_argumenti, where i is 1 or 2. All sub routines that take or return arguments describes how to pass or return parameters in a comment above the sub routine. 
