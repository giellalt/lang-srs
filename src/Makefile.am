## Process this file with automake to produce Makefile.in
## Copyright: Sámediggi/Divvun/UiT
## Licence: GPL v3+

# always build . last here, and tagsets have to be built after morphology
SUBDIRS = phonology morphology filters phonetics hyphenation orthography syntax transcriptions tagsets .

####### Automake targets: ########

# Define target variables first, before assigning to them:
GT_ANALYSERS=
GT_GENERATORS=

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
endif # CAN_XFST

#### HFST transducers
if CAN_HFST
GT_ANALYSERS+=
GT_GENERATORS+=
endif # CAN_HFST

#### FOMA transducers
if CAN_FOMA
GT_ANALYSERS+=analyser-dict-gt-desc-mobile-downcasetest.foma
GT_GENERATORS+=
endif # CAN_FOMA

#################################################
#### Add language-specific build rules here: ####

# The mobile analyser is just like the regular dictionary analyser,
# except for one additional set of spellrelaxes:
analyser-dict-gt-desc-mobile-downcasetest.%: analyser-dict-gt-desc-mobile.tmp.% \
					filters/downcase_UCletters.%
	$(AM_V_XFST_TOOL)$(PRINTF) "read regex \
			    @\"filters/downcase_UCletters.$*\" \
			.o. @\"$<\" \
			;\n\
		 save stack $@\n\
		 quit\n" | $(XFST_TOOL)

# analyser-oahpa-gt-downcaseerror.%: analyser-dict-gt-desc.tmp.% \
# 					filters/downcase_UCletters.%      \
# 					filters/extract-Sem_Plc-strings.% \
# 					filters/tag-lowercase_error-strings.%
# 	$(AM_V_XFST_TOOL)$(PRINTF) "read regex \
# 			[ [   @\"filters/tag-lowercase_error-strings.$*\" \
# 			  .o. @\"filters/extract-Sem_Plc-strings.$*\"     \
# 			  .o. @\"$<\" \
# 			  ] \
# 			  .o. @\"filters/downcase_UCletters.$*\"          \
# 			] \
# 			|   @\"$<\" \
# 			;\n\
# 		 save stack $@\n\
# 		 quit\n" | $(XFST_TOOL)

##################################################################
#### END: Add local processing instructions ABOVE this line ######
##################################################################

include $(top_srcdir)/am-shared/src-dir-include.am
