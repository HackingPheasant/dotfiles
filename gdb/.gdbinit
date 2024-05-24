### GDB Options ###
# Display instructions in Intel format
set disassembly-flavor intel

set listsize 40

# To skip all .h files in /usr/include/c++/13/bits
skip -gfi /usr/include/c++/13/bits/*.h
