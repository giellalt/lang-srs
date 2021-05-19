


















* Sets for POS sub-categories





* Sets for Semantic tags





* Sets for Morphosyntactic properties






































































































































































* Sets for verbs


    - V is all readings with a V tag in them, REAL-V should
be the ones without an N tag following the V.  
The REAL-V set thus awaits a fix to the preprocess V ... N bug.



* The set COPULAS is for predicative constructions







* NP sets defined according to their morphosyntactic features







* The PRE-NP-HEAD family of sets

These sets model noun phrases (NPs). The idea is to first define whatever can
occur in front of the head of the NP, and thereafter negate that with the
expression **WORD - premodifiers**.












The set **NOT-NPMOD** is used to find barriers between NPs.
Typical usage: ... (*1 N BARRIER NPT-NPMOD) ...
meaning: Scan to the first noun, ignoring anything that can be
part of the noun phrase of that noun (i.e., "scan to the next NP head")






* Miscellaneous sets





















* Border sets and their complements













* Syntactic sets




These were the set types.



## HABITIVE MAPPING


* **hab1** 


* **hab2** 

* **hab3** (<hab> @ADVL>) for hab-actor and hab-case; if leat to the right, and Nom to the right of leat. Lots of restrictions.



* **habNomLeft** 


* **hab4** 	



* **hab6** 

* **hab7** 

* **hab8** This is not HAB
* **hab5**  This is not HAB



* **habDain** (<hab> @ADVL>) for (Pron Dem Pl Loc) if leat followed by Nom to the right




* **habGen** (<hab> @<ADVL) hab for Gen; if Gen is located in the end of the sentence and Nom is sentence initial










































































* **spred<obj** (@SPRED<OBJ) for Acc; the object of an SPRPED. Not to be mistaken with OPRED. If SPRED is to the left, and copulas is to the left of it. Nom or Hab are found sentence initially.


* **Hab<spred** (@<SPRED) for Nom; if copulas, goallut or jápmit is FMAINV and habitive or human Loc is found to the left. OR: if Ill or @Pron< followed by HAB are found to the left.

* **Hab>Advlcase<spred** (<ext> @<SUBJ) for Nom; it allows adverbials with Ill/Loc/Com/Ess to be found inbetween HAB and <ext>.

* **Nom>Advlcase<spred** (<ext> @<SUBJ) for Nom; it allows adverbials with Ill/Loc/Com/Ess to be found inbetween Nom and <ext> @<SUBJ.

* **<spred** (<ext> @<SUBJ) for Nom; if copulas to the left, and some kind of adverb, N Loc, time related word or Po to the left of it. OR: if Ill or @Pron< to the left, followed by copulas and the before mentioned to the left of copulas. 

* **<spred** (<ext> @<SUBJ) for Nom, but not for Pers. To the left boahtit or heaŋgát as MAINV, and futher to the left is some kind of place related word, or time related word


* **<spredQst1** (<ext> @<SUBJ) for Nom in a typically question sentence; if A) Hab, some kind of place word, Po or Nom to the left, and Qst followed by copulas to the left. B) same as a, only the Qst-pcle is attached to copulas. C) Qst to the left, with copulas to its left, but not if two Nom:s are found somewhere to the right. D) copulas to the left, and BOS to the left. E) Loc or Ill to the left, and Loc or Hab to the left of this, Qst and copulas to the left. F) Num @>N to the left, Hab, some kind of place word, Po or Nom to the left, and Qst followed by copulas to the left. NOTE) for all these rules; human, Loc or Sem/Plc not allowed to the right.

* **<spredQst2** (@<SPRED) for Nom; in a typically question sentence; differs from <spredQst1 by not beeing as restricted to the right. Though you are not allowed to be Pers or human.

* **Nom<spredQst** (@<SPRED) for Nom; in a typically question sentence. Differs from <spredQst2 by letting Nom be found between SPRED and copulas



* **<spred** (@<SPRED) for A Nom or N Nom if; the subject Nom is on the same side of copulas as you: on the right side of copulas

* **<spredVeara** (@<SPRED) for veara + Nom; if genitive immediately to the right, and intransitive mainverb to the right of genitive

* **leftCop<spred** (@<SPRED) for Nom; if copulas is the main verb to the left, and there is no Ess found to the left of cop (note that Loc is allowed between target and cop). OR: if you are Coll or Sem/Group with copulas to your left. 

* **<spredLocEXPERIMENT** (@<SPRED) for material Loc; if you are to the right of copulas, and the Nom to the left of copulas is not a hab-actor


* **NumTime** (@<SPRED) for A Nom

* **<spredSg** (@<SPRED) for Sg Nom	

* **<spredPg** (@<SPRED) for Pl Nom	

* **<spred** (@<SPRED) for Nom; if copulas to the left, and Nom or sentence boundary to the left of copulas. First one to the right is EOS.

* **<spred** (@<SPRED) for N Ess

* **spredEss>** (@SPRED>) for N Ess; if copulas to the right of you, and if an NP with nom-case first one to your left.

* **HABSpredSg>** (@SPRED>) for Nom; if habitive first one to the left, followed by copulas.

* **GalleSpred>** (@SPRED>) for Num Nom; if sentence initial

* **spredSgMII>** (@SPRED>)

* **r492>** (@SPRED>) for Interr Gen; consisting only of negations. You are not allowed to be MII. You are not allowed to have an adjective or noun to yor right. You are not allowed to have a verb to your right; the exception beeing an aux.



* **AdjSpredSg>** (@SPRED>) for A Sg Nom; if copulas to the right, but not if A or @<SPRED are found to the right of copulas

* **SpredSg>Hab** (@SPRED>) for Nom; if you are sentence initial, copulas is located to the right, and there is a habitive to the right of copulas



* **Spred>SubjInf** (@SPRED>) for Nom; if copulas to the right, and the subject of copulas is an Inf to the right

* **spredCoord** (@<SPRED) coordination for Nom; only if there already is a SPRED to the left of CNP. Not if there is some kind of comparison involved.






* **subj>Sgnr1** (@SUBJ>) for Nom Sg, including Indef Nom if; VFIN + Sg3 or Pl3 to the right (VFIN not allowed to the left) 

* **subj>Du** (@SUBJ>) for dual nominatives, including Coll Nom. VFIN + Du3 to the right. 
* **subj>Pl** (@SUBJ>) for plural nominatives, including Coll and Sem/Group. VFIN + Pl3 to the right.

* **subj>Pl** (@SUBJ>) for plural nominatives


* **subj>Sgnr2** (@SUBJ>) for Nom Sg; if VFIN + Sg3 to the right.

* **<subjSg** (@<SUBJ) for Nom Sg; if VFIN Sg3 or Du2 to the left (no HAB allowed to the left).




















* **f<advl** (@-F<ADVL) for infinite adverbials

* **f<advl** (@-F<ADVL) for infinite adverbials



* **s-boundary=advl>** (@ADVL>) for ADVL that resemble s-booundaries. Mainverb to the right.




* **-fobj>** (@-FOBJ>) for Acc 

* **-fobj>** (@-FOBJ>) for Acc




* **advl>mainV** (@ADVL>) if; finite mainverb not found to the left, but the finite mainverb is found to the right.


* **<advl** (@<ADVL) if; finite mainverb found to the left. Not if a comma is found immediately to the left and a finite mainverb is located somewhere to the right of this comma.




* **<advlPoPr** (@<ADVL) if mainverb to the left.
* **advlPoPr>** (@<ADVL) if mainverb to the right.



* **advlEss>** (@<ADVL) for weather and time Ess, if FMAINV to the left.






* **advl>inbetween** (@ADVL>) for Adv; if inbetween two sentenceboundaries where no mainverb is present.

* **comma<advlEOS** (@<ADVL) if; comma found to the left and the finite mainverb to the left of comma. To the right is the end of the sentence.



* **advlBOS>** (@ADVL>) if; you are N Ill and found sentnece initially. First one to your right is a clause.


* **<advlPoEOS** (@<ADVL) for Po; if you are found at the very end of a sentence. A mainverb is needed to the right though.



* **cleanupILL<advl** (@<ADVL) for N Ill if; there are no boundarysymbols to your left, if you arent already @N< OR @APP-N<, and no mainverb is to yor left.











* **<opredAAcc** (@<OPRED) for A Acc; if an other accusative to the left, and a transtive verb to the left of it. OR: if a transitive verb to the left, and an accusative to the left of it.


### sma object









* **<advlEss** (@<ADVL) for ESS-ADVL if; FMAINV to the left
* **<spredEss** (@<SPRED) for N Ess if; FMAINV to the left is intransitive or bargat





## SUBJ MAPPING - leftovers

## OBJ MAPPING - leftovers


## HNOUN MAPPING
















# Tsuut'ina Nouns
## Classification
1. Always unpossessed nouns: nàk'ús "cloud"
1. Always possessed nouns: sitsì "my head" (body parts, kinship terms)
1. Possessed or unpossessed: tłích'á "dog" vs. silích'à "my dog"

 Three (phonological) cases for the possessive prefixes:
 # Consonant-initial stem: si- "1SG" tsì "head" -> sitsì "my head"
 # Preceding H-tone stem: si- "1SG" V́tsí "nose" -> sítsí "my nose" 
 # Vowel-initial stem: si- "1SG" óó "mother" -> sóó "my mother" \\
   (cf. ʔinóó "mother" , ʔi- "UNSPEC.POSS" (n)óó;
   ```gu- "SOMEONE" óó "mother" -> gwóó gu > gw / _ [oa] ) Cu[oa] > Cw[oa]?```

Periphrastic / non-morphological constructions are used for always
unpossessed nouns: sá(à) nàk'ús "my cloud", ná(à) ʔidínít'ùgù
yiitł'áłí "your vehicle")

## Lexicons

 * LEXICON AlwaysUnpossessedNouns  never Px


 * LEXICON AlwaysPossessedNouns   always Px, body part, kinship


 * LEXICON UnpossessedNouns   Px or not, here not. Cf. PossessedNouns

 * LEXICON PossessedNouns   Px or not, here Px. Cf. UnpossessedNouns


Numerals
Numerals in the Sarsi language are numbers.



# Tsuut'ina verb stems

## Intransitive Verbs

 * LEXICON PERF_CLASS_1   

 * LEXICON IPFV_CLASS_1a   

 * LEXICON IPFV_CLASS_1b  

 * LEXICON IPFV_CLASS_2   

 * LEXICON PERF_STEMS_1   the list of most verbs in perf

 * LEXICON IPFV_STEMS_1a   same list in ipfv, but no prefix

 * LEXICON IPFV_STEMS_1b  same list in ipfv, but with pref


## Transitive Verbs 

 * LEXICON T_IPFV_CLASS_1a   type 1a


## Endlex cleanup

LEXICON T_IPFV_CLASS_1a   gives all D flags blocking unwanted forms



Pronouns
Pronouns in Tsuut'ina



# Symbol affixes





## Tsuut'ina Noun inflection

## Classification.
1. Always unpossessed nouns: nàk'ús "cloud"
1. Always possessed nouns: sitsì "my head" (body parts, kinship terms)
1. Possessed or unpossessed: tłích'á "dog" vs. silích'à "my dog"

(see explanation in the affixes file)

## Lexicons

 * LEXICON NounPrefixes    Splitting in 3

 * LEXICON AlwaysPossessedNounPrefixes   Px

 * LEXICON VariablyPossessedNouns   Px or not


Proper noun inflection
The Sarsi language proper nouns inflect in the same cases as regular
nouns, but with a colon (':') as separator.



# Verb inflection in Tsuut'ina

The lexicon names srs15, srs14, etc. refers to traditional template names.

 * LEXICON VerbPrefixes  from the Root lexicon, always empty

 * LEXICON srs15  

 * LEXICON srs14  empty

 * LEXICON srs13  empty

 * LEXICON srs12  empty

 * LEXICON srs11  optional Distr+

 * LEXICON srs10  empty

 * LEXICON srs9  empty




 * LEXICON srs8765  contains the person-number complex
* I_IMPERFECTIVE CLASS 1a, no other prefix

    - I_IMPERFECTIVE CLASS 1b, inner prefix

    - 3rd person, directed to Pref/di, Pref/zi, etc.


    - I_PERFECTIVE CLASS 1

    - T_IMPERFECTIVE CLASS 1a, no other prefix







 * LEXICON Person12_IPFV_CLASS_1b   contains the block of 1st and 2nd person



# Tsuut'ina morphological analyser                      !
INTRODUCTION TO THE MORPHOLOGICAL ANALYSER OF Tsuut'ina.

 # Definitions for Multichar_Symbols

## Analysis symbols
The morphological analyses of wordforms of Tsuut'ina are presented
in this system in terms of the following symbols.
(It is highly suggested to follow existing standards when adding new tags).


 * +Asp	 asp, aspect
 * +Dem	 D, demonstrative
 * +Dim	 dim, diminutive
 * +Du		 du, dual
 * +Err/Orth  Substandard, not implemented
 * +Foc	 foc, focus
 * +Hab	 hab, habitual
 * +Imprs	 impers, impersonal (+Impers?)
 * +Inc	 inc, inceptive (Incpt?)
 * +Inch	 incho, inchoative
 * +Mod	 M mode (this seems more like category than property)
 * +Mom	 momentaneous
 * N+		 N, noun
 * +Neg	 neg, negative
 * +Num	 num, Numeral
 * +PI+	 postposition incorporation (this is not a Morphosyn tag :-(
 * +PNS     possessed noun suffix (this is not a Morphosyn tag :-(
 * +Part    Part, particle
 * +Pl		 pl, Plural
 * +Po		 P, Postposition
 * +Prt	 T, tense (past)
 * +Qst	 Q, question marker
 * +Qt		 Qt, quantifier
 * +Sem/Hum		 Human
 * +Sem/Obj	 O, Object (have a look at this)
 * V+		 V, verb
 * 12Du+	 12, first person dual inclusive
 * 13Du+	 13, first person dual exclusive
 * 1Pl+      12, first person plural inclusive
 * 1PlO+    12, first person plural inclusive O
 * 1Sg+	 1, first person singular
 * 2Du+	 22, second person dual
 * 2Sg+	 2
 * 3Du+	 33, third person dual
 * 3Sg+	 3
 * 4Sg+	 4, the other

 * PxSg1+   Px
 * PxSg2+   Px
 * PxSg3+   Px
 * PxSg4+   Px

 * Ar+		 5, areal subject, it (place, condition, weather)
 * Impf+	 imp, imperfective (or prefix?)
 * Iter+	 iter, iterative
 * NI+		 NI, noun incorporation (probably not a tag)
 * Opt+	 opt, optative
 * Prf+	 perf, perfective
 * Recipr+	 rec, reciprocal
 * Refl+	 refl, reflexive
 * Th+		 Th, thematic prefix  (probably not a tag)
 * Unspec+	 0, Unspecified person
 * UnspecO+	 0, Unspecified person
 * UnspecS+	 0, Unspecified person
 * +Symbol = independent symbols in the text stream, like £, €, ©


## Prefixes


## our flags

 * @U.asp.perf@  
 * @U.asp.ipfv@  

 * @U.xaH.ON@   
 * @R.xaH.ON@   
 * @D.xaH@      

 * @U.xaM.ON@    
 * @R.xaM.ON@   
 * @D.xaM@    

 * @U.xaL.ON@   
 * @R.xaL.ON@      
 * @D.xaL@    

 * @U.di.ON@   
 * @R.di.ON@      
 * @D.di@    

 * @U.zi.ON@   
 * @R.zi.ON@      
 * @D.zi@    

 * @U.na.ON@   
 * @R.na.ON@      
 * @D.na@    

 * @U.ni.ON@   
 * @R.ni.ON@      
 * @D.ni@    

 * @R.TV.ON@   
 * @U.TV.ON@    
 * @U.TV.OFF@    

## Archphonemes (multi-character definitions)

 * %^VH       denoting floating high tone

## Border 

 * %<   prefix border
 * %>   suffix border

## Flag diacritics
We have manually optimised the structure of our lexicon using following
flag diacritics to restrict morhpological combinatorics - only allow compounds
with verbs if the verb is further derived into a noun again:
 |  @P.NeedNoun.ON@ | (Dis)allow compounds with verbs unless nominalised
 |  @D.NeedNoun.ON@ | (Dis)allow compounds with verbs unless nominalised
 |  @C.NeedNoun@ | (Dis)allow compounds with verbs unless nominalised

For languages that allow compounding, the following flag diacritics are needed
to control position-based compounding restrictions for nominals. Their use is
handled automatically if combined with +CmpN/xxx tags. If not used, they will
do no harm.
 |  @P.CmpFrst.FALSE@ | Require that words tagged as such only appear first
 |  @D.CmpPref.TRUE@ | Block such words from entering ENDLEX
 |  @P.CmpPref.FALSE@ | Block these words from making further compounds
 |  @D.CmpLast.TRUE@ | Block such words from entering R
 |  @D.CmpNone.TRUE@ | Combines with the next tag to prohibit compounding
 |  @U.CmpNone.FALSE@ | Combines with the prev tag to prohibit compounding
 |  @P.CmpOnly.TRUE@ | Sets a flag to indicate that the word has passed R
 |  @D.CmpOnly.FALSE@ | Disallow words coming directly from root.

Use the following flag diacritics to control downcasing of derived proper
nouns (e.g. Finnish Pariisi -> pariisilainen). See e.g. North Sámi for how to use
these flags. There exists a ready-made regex that will do the actual down-casing
given the proper use of these flags.
 |  @U.Cap.Obl@ | Allowing downcasing of derived names: deatnulasj.
 |  @U.Cap.Opt@ | Allowing downcasing of derived names: deatnulasj.








The word forms in Tsuut'ina start from noun and verb prefixes




We describe here how abbreviations are in Sarsi are read out, e.g.
for text-to-speech systems.

For example:

 * s.:syntynyt # ;  
 * os.:omaa% sukua # ;  
 * v.:vuosi # ;  
 * v.:vuonna # ;  
 * esim.:esimerkki # ; 
 * esim.:esimerkiksi # ; 


















































% komma% :,      Root ;
% tjuohkkis% :%. Root ;
% kolon% :%:     Root ;
% sárggis% :%-   Root ; 
% násti% :%*     Root ; 


      [ L A N G U A G E ]  G R A M M A R   C H E C K E R









# DELIMITERS


# TAGS AND SETS



## Tags


This section lists all the tags inherited from the fst, and used as tags
in the syntactic analysis. The next section, **Sets**, contains sets defined
on the basis of the tags listed here, those set names are not visible in the output.




### Beginning and end of sentence
BOS
EOS



### Parts of speech tags

N
A
Adv
V
Pron
CS
CC
CC-CS
Po
Pr
Pcle
Num
Interj
ABBR
ACR
CLB
LEFT
RIGHT
WEB
QMARK
PPUNCT
PUNCT

COMMA
¶



### Tags for POS sub-categories

Pers
Dem
Interr
Indef
Recipr
Refl
Rel
Coll
NomAg
Prop
Allegro
Arab
Romertall


### Tags for morphosyntactic properties

Nom
Acc
Gen
Ill
Loc
Com
Ess
Ess
Sg
Du
Pl
Cmp/SplitR
Cmp/SgNom Cmp/SgGen
Cmp/SgGen
PxSg1
PxSg2
PxSg3
PxDu1
PxDu2
PxDu3
PxPl1
PxPl2
PxPl3
Px

Comp
Superl
Attr
Ord
Qst
IV
TV
Prt
Prs
Ind
Pot
Cond
Imprt
ImprtII
Sg1
Sg2
Sg3
Du1
Du2
Du3
Pl1
Pl2
Pl3
Inf
ConNeg
Neg
PrfPrc
VGen
PrsPrc
Ger
Sup
Actio
VAbess



Err/Orth



### Semantic tags

Sem/Act
Sem/Ani
Sem/Atr
Sem/Body
Sem/Clth
Sem/Domain
Sem/Feat-phys
Sem/Fem
Sem/Group
Sem/Lang
Sem/Mal
Sem/Measr
Sem/Money
Sem/Obj
Sem/Obj-el
Sem/Org
Sem/Perc-emo
Sem/Plc
Sem/Sign
Sem/State-sick
Sem/Sur
Sem/Time
Sem/Txt

HUMAN

HAB-ACTOR
HAB-ACTOR-NOT-HUMAN


PROP-ATTR
PROP-SUR



TIME-N-SET


###  Syntactic tags

@+FAUXV
@+FMAINV
@-FAUXV
@-FMAINV
@-FSUBJ>
@-F<OBJ
@-FOBJ>
@-FSPRED<OBJ
@-F<ADVL
@-FADVL>
@-F<SPRED
@-F<OPRED
@-FSPRED>
@-FOPRED>
@>ADVL
@ADVL<
@<ADVL
@ADVL>
@ADVL
@HAB>
@<HAB
@>N
@Interj
@N<
@>A
@P<
@>P
@HNOUN
@INTERJ
@>Num
@Pron<
@>Pron
@Num<
@OBJ
@<OBJ
@OBJ>
@OPRED
@<OPRED
@OPRED>
@PCLE
@COMP-CS<
@SPRED
@<SPRED
@SPRED>
@SUBJ
@<SUBJ
@SUBJ>
SUBJ
SPRED
OPRED
@PPRED
@APP
@APP-N<
@APP-Pron<
@APP>Pron
@APP-Num<
@APP-ADVL<
@VOC
@CVP
@CNP
OBJ
<OBJ
OBJ>
<OBJ-OTHERS
OBJ>-OTHERS
SYN-V
@X





## Sets containing sets of lists and tags

This part of the file lists a large number of sets based partly upon the tags defined above, and
partly upon lexemes drawn from the lexicon.
See the sourcefile itself to inspect the sets, what follows here is an overview of the set types.



### Sets for Single-word sets

INITIAL


### Sets for word or not

WORD
REAL-WORD
REAL-WORD-NOT-ABBR
NOT-COMMA


### Case sets

ADLVCASE

CASE-AGREEMENT
CASE

NOT-NOM
NOT-GEN
NOT-ACC

### Verb sets


NOT-V

### Sets for finiteness and mood

REAL-NEG

MOOD-V

NOT-PRFPRC


### Sets for person

SG1-V
SG2-V
SG3-V
DU1-V
DU2-V
DU3-V
PL1-V
PL2-V
PL3-V





### Pronoun sets

















### Adjectival sets and their complements




### Adverbial sets and their complements




### Sets of elements with common syntactic behaviour


### NP sets defined according to their morphosyntactic features








### The PRE-NP-HEAD family of sets

These sets model noun phrases (NPs). The idea is to first define whatever can
occur in front of the head of the NP, and thereafter negate that with the
expression **WORD - premodifiers**.





















### Border sets and their complements











### Grammarchecker sets








