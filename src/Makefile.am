## Process this file with automake to produce Makefile.in
## Copyright: Sámediggi/Divvun/UiT
## Licence: GPL v3+

# always build . last here, and tagsets have to be built after morphology
SUBDIRS = fst filters phonetics hyphenation orthography cg3 transcriptions tagsets .

####### Automake targets: ########

# Define target variables first, before assigning to them:
GT_ANALYSERS=
GT_GENERATORS=
CUSTOM_FSTS=

#### Local modifications in *fst processing: ####
####
#### Copy the fallback targets, and rename them to the desired targets. Then:
#### Replace the 'cp' command (Xerox) / Prepend the hfst-invert command (Hfst -
#### remember to move the $<) with whatever you need to complete
#### the processing to get the final target transducer.
#### Remember to add the dependencies as well.
#### Also make sure that HFST and Xerox processing are the same.
####
#### If you add new transducers to be built, you need to add them to the
#### relevant variable, e.g.:
####
#### if CAN_HFST
#### GT_GENERATORS+=generator-oahpa-gt-norm.hfst
#### endif
####
#### NB!!!! The HFST targets should get a hyphen after 'analyser'/'generator'
#### respectively, to make the local targets minimally different from and
#### slightly more specific than the fallback targets. This is to avoid warnings
#### about duplicate targets. That is, the local targets should looke like:
####
#### analyser-%.hfst: analyser-%.tmp.hfst
#### generator-%.hfst: generator-%.tmp.hfst

##################################################################
#### BEGIN: Add local processing instructions BELOW this line ####
##################################################################

########################################################
#### Add language-specific transducer targets here: ####

#### Xerox transducers:
if CAN_XFST
GT_ANALYSERS+=
GT_GENERATORS+=

if WANT_CUSTOM_FSTS
CUSTOM_FSTS+=
endif # WANT_CUSTOM_FSTS

endif # CAN_XFST

#### HFST transducers
if CAN_HFST
GT_ANALYSERS+=
GT_GENERATORS+=

if WANT_CUSTOM_FSTS
CUSTOM_FSTS+=
endif # WANT_CUSTOM_FSTS

endif # CAN_HFST

#### FOMA transducers
if CAN_FOMA
GT_ANALYSERS+=analyser-dict-gt-desc.foma
GT_GENERATORS+=generator-dict-gt-norm.foma

if WANT_CUSTOM_FSTS
CUSTOM_FSTS+=
endif # WANT_CUSTOM_FSTS

endif # CAN_FOMA

#################################################
#### Add language-specific build rules here: ####

# Convert accented y to plain y:
generator-raw-gt-desc.hfst: generator-raw-gt-desc.tmp.hfst \
					 filters/remove-bracketed-english-gloss.hfst
	$(AM_V_XFST_TOOL)$(PRINTF) "read regex            \
				@\"filters/remove-bracketed-english-gloss.hfst\" \
			.o. @\"$<\"                               \
			;\n\
		 save stack $@\n\
		 quit\n" | $(XFST_TOOL)

### Foma % Xerox: as Hfst, but the file is an analyser, not generator:
analyser-raw-gt-desc.%: analyser-raw-gt-desc.tmp.% \
					 filters/remove-bracketed-english-gloss.%
	$(AM_V_XFST_TOOL)$(PRINTF) "read regex            \
				@\"filters/remove-bracketed-english-gloss.$*\" \
			.o. @\"$<\"                               \
			;\n\
		 save stack $@\n\
		 quit\n" | $(XFST_TOOL)


# Remove brackets from mobile dict as well (spellrelax should already be
# included at this stage)
analyser-dict-gt-desc-mobile.%: analyser-dict-gt-desc-mobile.tmp.% \
					filters/remove-bracketed-english-gloss.%       \
  					filters/allow_uppercase.%
	$(AM_V_XFST_TOOL)$(PRINTF) "read regex \
  			    @\"filters/remove-bracketed-english-gloss.$*\" \
			.o. @\"$<\"                                        \
   			.o. @\"filters/allow_uppercase.$*\"                \
			;\n\
		 save stack $@\n\
		 quit\n" | $(XFST_TOOL)

# Override analyser-dict-gt-desc, and add spellrelax
analyser-dict-gt-desc.%: analyser-dict-gt-desc.tmp.%         \
					orthography/spellrelax.compose.%         \
					filters/remove-bracketed-english-gloss.% \
  					filters/allow_uppercase.%
	$(AM_V_XFST_TOOL)$(PRINTF) "read regex                     \
  			    @\"filters/remove-bracketed-english-gloss.$*\" \
			.o. @\"$<\"                                        \
			.o. @\"orthography/spellrelax.compose.$*\"         \
   			.o. @\"filters/allow_uppercase.$*\"                \
			;\n\
		 save stack $@\n\
		 quit\n" | $(XFST_TOOL)

generator-dict-gt-norm.%: generator-dict-gt-norm.tmp.% \
					filters/remove-bracketed-english-gloss.%
	$(AM_V_XFST_TOOL)$(PRINTF) "read regex                     \
  			    @\"filters/remove-bracketed-english-gloss.$*\" \
			.o. @\"$<\"                                        \
			;\n\
		 invert net\n\
		 save stack $@\n\
		 quit\n" | $(XFST_TOOL)


# Override analyser-gt- analysers with spellrelax and downcase
# analyser-gt-%.foma: analyser-gt-%.tmp.foma \
# 					orthography/spellrelax.compose.foma \
# 					filters/downcase_UCletters.foma
# 	$(AM_V_XFST_TOOL)$(PRINTF) "read regex                    \
# 			    @\"$<\"                                       \
#   			.o. @\"orthography/spellrelax.compose.foma\"  \
#   			.o. @\"filters/downcase_UCletters.foma\"      \
# 			;\n\
# 		 save stack $@\n\
# 		 quit\n" | $(XFST_TOOL) $(VERBOSITY)

analyser-gt-%.foma: analyser-gt-%.tmp.foma \
					orthography/spellrelax.compose.foma
	$(AM_V_XFST_TOOL)$(PRINTF) "read regex               \
			    @\"$<\"                                  \
  			.o. @\"orthography/spellrelax.compose.foma\" \
			;\n\
		 save stack $@\n\
		 quit\n" | $(XFST_TOOL) $(VERBOSITY)

##################################################################
#### END: Add local processing instructions ABOVE this line ######
##################################################################

include $(top_srcdir)/../giella-core/am-shared/src-dir-include.am
