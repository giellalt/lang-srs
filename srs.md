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




# Symbol affixes





Adjective inflection
The Sarsi language adjectives compare.



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


# The Tsuut'ina morphophonological/twolc rules file 

## Alphabet and sets

### Alphabet
 *  a b c d e f g h i j k l ł m n o p q r s t u v w x y z  
  á é ó ú í ā ē ō ū ī à è ò ù ì ʔ %'                       
 *  A B C D E F G H I J K L Ł M N O P Q R S T U V W X Y Z  
  Á É Ó Ú Í Ā Ē Ō Ū Ī À È Ò Ù Ì ʔ                        

 *  %^VH:0       
    %> %<        

### Sets

 *  Vow = a e i o u                                     
        á é ó ú í ā ē ō ū ī à è ò ù ì                 
        A E I O U                                     
        Á É Ó Ú Í Ā Ē Ō Ū Ī À È Ò Ù Ì ;               
 *  Cns = b c d f g h j k l ł m n p q r s t v w x z ʔ %i 
        B C D F G H J K L Ł M N P Q R S T V W X Z ʔ ;  

## Rules

* **Dock floating high tone on the preceeding vowel** \\  si<^VHtsí to high-tone prefix sí

* *si<^VHtsí*
* *sí<0tsí*

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


Prefixes
Prefixes in the Sarsi language are bound to beginning of other words.



Pronouns
Pronouns in Tsuut'ina


Adjectives
Adjectives in the Sarsi language describe things.



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



Numerals
Numerals in the Sarsi language are numbers.


















































% komma% :,      Root ;
% tjuohkkis% :%. Root ;
% kolon% :%:     Root ;
% sárggis% :%-   Root ; 
% násti% :%*     Root ; 




We describe here how abbreviations are in Sarsi are read out, e.g.
for text-to-speech systems.

For example:

 * s.:syntynyt # ;  
 * os.:omaa% sukua # ;  
 * v.:vuosi # ;  
 * v.:vuonna # ;  
 * esim.:esimerkki # ; 
 * esim.:esimerkiksi # ; 


