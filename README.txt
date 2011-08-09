lentickle - length loop modeling

by Nicolas Smith-Lefebvre
nicolas@ligo.mit.edu

based on Pickle by Lisa Barsotti

TO SET UP:

edit setupLentickle-example.m to have correct path to lentickle 
and Optickle, save this file as setupLentickle.m 

You can run this file at the beginning of your script with the

>> run path-to-lentickle/setupLentickle.m

command.

EXAMPLES:

Examples are in examples/ directory. The exampleMICH.m example 
will explain the basic workings of lentickle. Also look at 
exampleMICHcucumber.m for instructions on how to build the control 
system model. A working knowledge of Optickle is assumed for this 
example.

KNOWN ISSUES:

Oscillator phase noise: there is no noise in the demodulation stage, 
so some cancelation is not modeled.
