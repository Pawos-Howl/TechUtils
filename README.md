# TechUtils
A set of Debian bash based utilities for managing systems.
### NOTES:
The files starting with a "0" arer not different, they are just smaller and will not take up as much space (they have no code comments or older tried code).

## getUsers.sh
This small script can be used to spot unautorized users. It has an embedded system users list (which might not catch everything) and the ability to use your own list without modifying the code! The way to specify this second list is seperated by comas. (ex: ./getUsers.sh paw,pawos,wolf)

