# Process this file with automake to produce Makefile.in
## Copyright: Sámediggi/Divvun/UiT
## Licence: GPL v3+

# Uncomment and list here (space separated) all test scripts that should be run:
TESTS=

if CAN_HFST
TESTS+=pair-test-hfst.sh
endif # CAN_HFST

# List tests that are presently (expected) failures here, ie things that should
# be fixed *later*, but is not critical at the moment:
XFAIL_TESTS=

# Make sure all tests scripts are included in the distributed tarballs:
EXTRA_DIST=pair-test-positive.sh.in \
            pair-test-negative.sh.in \
            pair-test-hfst.sh.in

####### Other targets: ###########
clean-local:
	-rm -f *.txt
include $(top_srcdir)/../giella-core/am-shared/devtest-include.am
