# TechUtils
Disclaimer, I am a silly programmer 90% of the time. In this case, I did a few things that are not advisiable. As such, that code will be replaced. (NOTE: I did replace it). It is still left because someone might need it for their own sake and programming.

A set of Debian bash based utilities for managing systems that have some support for Ubuntu... kinda. For an explaination on how to run this, [click here](#execution)

### NOTES:
Yes, I did overhaul the whole project. Why? My organization was terrible, and I shouldn't have a seperate version of each program based on comment count.

## getUsers.sh
This small script can be used to spot unautorized users. It has an embedded system users list (which might not catch everything) and the ability to use your own list without modifying the code! The way to specify this second list is seperated by comas. (ex: ./getUsers.sh paw,pawos,wolf)

## findMedia.sh
This script can be used to find media files (audio, video, and image) that are on your system, and it pulls extensions from an embedded list. The first parameter is the location you want to look at. This script makes a file titled "PATHS.txt" and if it can find that file, will read from it. It will NOT purge it if a new location is specified, so keep that in mind. The second parameter is the type of file you want to look for (either audio, video, image or a combination of them. "all" can be used to specify all of them). The second parameter is a list with comas and no spaces. The full execution of this script can look like this: ./findMedia.sh /home/pawos/ all.

## programsCheck.sh
This is a script that might run some "red flags" on your system, but they can be safely disregarded. These tools are ones typically associated (from what I have done) as either backdoors or malicious programs. This could find some programs that have been causing some attacks (or could be the future reason for an attack). However, some things that this tool flags could be intended in your system. Use at your own discression.

## Execution
NOTE: I fixed the execution flag. it should be fine now.

To run these, you have to give the execution flag to the file. To do this, you can run
```
chmod +x [script name].sh
```
and in a terminal line again run
```
./[script name].sh
```
in the directory of the script to execute it.
