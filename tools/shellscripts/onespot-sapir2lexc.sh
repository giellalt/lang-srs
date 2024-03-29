#!/bin/sh

# onespot-sapir2lexc.sh

# Usage:
# cat *.tsv (Lexical database in TSV format)
# | changing CRLF's into LF's
# | onespot-sapir2lexc.sh REPORT="yes"/"no" ALL="yes"/"no" ONLYYAML="yes"/"no"
# REPORT="yes" outputs dubious lines as a report at the end of the LEXC file.
# ALL="yes" outputs all entries, even those that have been marked as needing
#  to be excluded from the FST for now (i.e., where "FST status" != "")
# ONLYYAML="yes" outputs only items for which YAML test cases are available
#  in 'test/src/gt-norm-yamls' (to allow for quicker compilation when doing
#  basic sanity checking of FST behaviour)

# Example:
# cat ~/Downloads/Tsuut'ina\ -\ Preliminary\ lexical\ database\ -\ Verbs.tsv |
# tr -s '\r' '\n' |
# tools/shellscripts/onespot-sapir2lexc.sh yes > verb_stems.lexc

# Fields in the provisional Tsuut'ina lexical database based on the Onespot-Sapir glossary
# 1 ID
# 2 Form
# 3 Senses
# 4 FST gloss template
# 5 Morphemic parsing
# 6 Aspect
# 7 Argument structure
# 8 Inflectional paradigm
# 9 FST lemma
# 10 FST morphology
# 11 Source
# 12 FST status
# 13 Notes
# 14 WordNet
# 15 RapidWords items
# 16 RapidWords labels

# Argument structure classes and contlex prefixes
# These need to be matched with the contlexes in the end of the current skeleton file
# These contlexes specifying TAMA etc. classes might be moved into their own LEXC file
# together with the multicharacter symbol specifications.
#
# DITRANS -> DITR
# EXPER -> EXP
# INTR
# OBL
# TRANS -> TR


gawk -v REPORT=$1 -v ALL=$2 'BEGIN { FS="\t"; all_entries=ALL; report=REPORT; only_yaml=ENVIRON["ONLYYAML"]; report_text="!! REPORT OF IRREGULARITIES:"; }
NR==1 {
  for(i=1; i<=NF; i++)
    {
      os=1;
      if(index($i,"FST lemma")!=0) fst_lemma=i;
      if(index($i,"FST morphology")!=0) fst_stem=i;
      if(index($i,"Inflectional paradigm")!=0) tama=i;
      if(index($i,"Argument structure")!=0) args=i;
      if(index($i,"FST status")!=0) status=i;
      if(index($i,"YAML")!=0) yaml=i;
    }
  # Argument structure abbreviations for contlexes
  # Index corresponds to flag-diacritic value; value to contlex prefix

# Impersonal
# Intransitive -> INTR
# Intransitive-Subj3SgOnly -> INTR + @R.SUBJECTPERSON.3@@R.SUBJECTNUMBER.SG@
# Intransitive-Subj3Only -> INTR + @R.SUBJECTPERSON.3@
# Intransitive-SubjPlOnly -> INTR + @R.SUBJECTNUMBER.PL@
# Intransitive-SubjSuppr -> INTR
# Transitive -> TR
# Transitive-DObjPlOnly -> TR + @R.OBJECTNUMBER.PL@ 
# Transitive-DObj3SgOnly -> TR + @R.OBJECTNUMBER.SG@ @R.OBJECTPERSON.3@ 
# Transitive-SubjSuppr -> TR
# ObliqueObject -> OO
# Ditransitive -> DITR
# DirectObjectExperiencer -> DOEXP
# ObliqueObjectExperiencer -> OOEXP
# TransitionalTransitive -> TT

  arg_label["Impersonal"]="IMP"; valence["Impersonal"]="IMPERSONAL";
  arg_label["Intransitive"]="INTR"; valence["Intransitive"]="INTRANSITIVE";
  arg_label["Intransitive-Subj3SgOnly"]="INTR-S3SG"; valence["Intransitive-Subj3SgOnly"]="INTRANSITIVE"; extraflags["Intransitive-Subj3SgOnly"]="@R.SUBJECTPERSON.3@@R.SUBJECTNUMBER.SG@"
  arg_label["Intransitive-Subj3Only"]="INTR-S3"; valence["Intransitive-Subj3Only"]="INTRANSITIVE"; extraflags["Intransitive-Subj3Only"]="@R.SUBJECTPERSON.3@";
  arg_label["Intransitive-SubjPlOnly"]="INTR-PL"; valence["Intransitive-SubjPlOnly"]="INTRANSITIVE"; extraflags["Intransitive-SubjPlOnly"]="@R.SUBJECTNUMBER.PL@";
  arg_label["Intransitive-SubjSuppr"]="INTR-SS"; valence["Intransitive-SubjSuppr"]="INTRANSITIVE";
  arg_label["Transitive"]="TR"; valence["Transitive"]="TRANSITIVE";
  arg_label["TransitionalTransitive"]="TR-TR"; valence["TransitionalTransitive"]="TRANSITIONAL";
  arg_label["Transitive-SubjSuppr"]="TR-SS"; valence["Transitive-SubjSuppr"]="TRANSITIVE";
  arg_label["Transitive-DObjPlOnly"]="TR-DOPL"; valence["Transitive-DObjPlOnly"]="TRANSITIVE"; extraflags["Transitive-DObjPlOnly"]="@R.OBJECTNUMBER.PL@";
  arg_label["Transitive-DObj3SgOnly"]="TR-DO3SG"; valence["Transitive-DObj3SgOnly"]="TRANSITIVE"; extraflags["Transitive-DObj3SgOnly"]="@R.OBJECTNUMBER.SG@@R.OBJECTPERSON.3@";
  arg_label["Transitive-Conative"]="TR-CON"; valence["Transitive-Conative"]="TRANSITIVE"; extraflags["Transitive-Conative"]="@R.CONATIVE.ON@";
  arg_label["Ditransitive"]="DITR"; valence["Ditransitive"]="DITRANSITIVE";
  arg_label["DirectObjectExperiencer"]="DOEXP"; valence["DirectObjectExperiencer"]="DO-EXPERIENCER";
  arg_label["ObliqueObject"]="OBL"; valence["ObliqueObject"]="OBLIQUEOBJECT";
  arg_label["ObliqueObjectExperiencer"]="OBLEXP"; valence["ObliqueObjectExperiencer"]="OO-EXPERIENCER";

  # Aspect comment labels
  aspect_label["IPFV"]="IPFV"; aspect_comment["IPFV"]="Imperfective";
  aspect_label["IPFV-REP"]="IPFV"; superaspect_flag["IPFV-REP"]="@U.SUPERASPECT.REP@"; aspect_comment["IPFV-REP"]="Imperfective + Repetitive";
  aspect_label["PFV"]="PFV"; aspect_comment["PFV"]="Perfective"; 
  aspect_label["PFV-REP"]="PFV"; superaspect_flag["PFV-REP"]="@U.SUPERASPECT.REP@"; aspect_comment["PFV-REP"]="Perfective + Repetitive"; 
  aspect_label["PROG"]="PROG"; aspect_comment["PROG"]="Progressive";
  aspect_label["POT"]="POT"; aspect_comment["POT"]="Potential";
  aspect_label["OPT"]="OPT"; aspect_comment["OPT"]="Optative";
  aspect_label["OTHER"]="OTHER"; aspect_comment["OTHER"]="CHECK ASPECT";
  aspect_label["CHECK-ASPECT"]="CHECK-ASPECT"; aspect_comment["CHECK-ASPECT"]="CHECK ASPECT";
  # print fst_lemma*1, fst_stem*1, tama*1;
}
NR>=2 {
  if($fst_lemma!="" && $fst_stem!="" && $tama!="" && $args!="" && ($all_entries=="yes" || $status=="") && (only_yaml!="yes" || $yaml=="Available"))
    { 
      # Removing diacritics from mid-tones in lemmas and stems
      gsub("ā", "a", $fst_lemma);
      gsub("ī", "i", $fst_lemma);
      gsub("ō", "o", $fst_lemma);
      gsub("ū", "u", $fst_lemma);
      gsub("ā", "a", $fst_stem);
      gsub("ī", "i", $fst_stem);
      gsub("ō", "o", $fst_stem);
      gsub("ū", "u", $fst_stem);
      gsub("[ ]+$","",$args); gsub("^[ ]+","",$args);
      aspect=""; superaspect="";
      if(match($tama,"(^.+)[-](IPFV|PFV|PROG|OPT|POT)([-](REP))?$",f)!=0)
        { tama_chunk=f[1]; aspect=f[2]; superaspect=f[4];
          if(superaspect!="") aspect=aspect"-"superaspect;
        }
      else
        { tama_chunk="CHECK-TAMA"; aspect="CHECK-ASPECT"; }        
      if($args=="") aspect=aspect " CHECK-VALENCE";
      lemma_tama_stem[$args][$fst_lemma][aspect][$tama][$fst_stem]=lemma_tama_stem[$args][$fst_lemma][aspect][$tama][$fst_stem] $os ", ";
      contlex[$args][aspect][tama_chunk]++;
    }
  else
    {
      report_text=report_text"\n!! LINE: "NR" - L: "$fst_lemma" - S: "$fst_stem" - T: "$tama;
    }
}
END { PROCINFO["sorted_in"]="@ind_str_asc";
# Header
print "!! Tsuut'\''ina (srs) verb stems";
print "";

split(",PlainStem,ModifiedStem", contlex_suffixes, ",");
split(",@U.STEM.PLAIN@,@U.STEM.MODIFIED@", contlex_suffix_flags, ",");

print "Multichar_Symbols";
print "! Flag specifications";
for(arg in contlex)
   { flags["@U.VALENCE."valence[arg]"@"]++;
     for(asp in contlex[arg])
        { if(index(asp,"REP")!=0)
            { sub("-REP","",asp); flags["@U.SUPERASPECT.REP@"]++; }
          flags["@U.ASPECT."asp"@"]++;
          for(tama in contlex[arg][asp])
            {
              gsub("0","%0",tama);
              if(match(tama,"(s\\-)|(s$)")!=0)
                { vv="S"; sub("s-","-",tama); sub("s$","",tama); }
              if(match(tama,"ii")!=0 || match(tama,"0i")!=0)
                { vv="I"; sub("ii","i",tama); sub("0i","0",tama); }
              flags["@U.TAMA."tama"@"]++;
            }
        }
   }

for(flag in flags)
   if(index(flag,"CHECK")==0)
     printf "%s\n", flag;
printf "@U.VV.%0@\n@U.VV.I@\n@U.VV.S@\n@R.CONATIVE.OFF@\n@R.CONATIVE.ON@\n";
printf "@U.STEM.PLAIN@\n@U.STEM.MODIFIED@\n"
printf "@R.SUBJECTPERSON.3@\n@R.SUBJECTNUMBER.SG@\n@R.SUBJECTNUMBER.PL@\n@R.OBJECTNUMBER.PL@\n@R.OBJECTNUMBER.SG@\n@R.OBJECTPERSON.3@\n";

printf "\n\n";

printf "!! Morphophonological special characters\n";
printf "^O ! outer prefix TAMA chunk\n";
printf "^H ! spreading high tone\n";
printf "^L ! spreading low tone\n";
printf "i2 ! moraic, non-collapsing /i/\n";
printf "n2 ! optional word-final /n/\n";
printf "s2 ! special 2Pl /s/\n\n";

print "LEXICON Root";
for(arg in lemma_tama_stem)
   printf "%s ;\n", arg;
printf "\n\n";

for(arg in lemma_tama_stem)
   { 
     print gensub(/ /, "!", "g", sprintf("%*s", length(arg)+12, ""))
     printf "!!!!! %s !!!!!\n", arg;
     print gensub(/ /, "!", "g", sprintf("%*s", length(arg)+12, ""))
     printf "\nLEXICON %s\n\n", arg;
     for(lemma in lemma_tama_stem[arg])
      { match(lemma,"(^.+)\\[(.+)\\]",f);
        gsub("_"," ",f[2]);
        printf "! %s - %s\n", f[1], f[2];
        for(asp in lemma_tama_stem[arg][lemma])
           for(clex in lemma_tama_stem[arg][lemma][asp])
              for(stem in lemma_tama_stem[arg][lemma][asp][clex])
                 if(lemma_tama_stem[arg][lemma][asp][clex][stem]!="")
                   { 
                     os_lines=lemma_tama_stem[arg][lemma][asp][clex][stem];
                     sub(", $","",os_lines);

                     # If the stem contains a slash (e.g., "di.dál/dátł'"),
                     # then it separates the plain stem ("dál") from the
                     # modified one ("dátł'").
                     stem_modified="";
                     if(index(stem,"/")!=0)
                       {
                         # Split the modified stem (after the slash) off from
                         # the plain stem and prefixes.
                         split(stem, stem_parts, "/");
                         prefixes="";
                         if(index(stem_parts[1], ".")!=0)
                           {
                             split(stem_parts[1], stem_out, ".");
                             prefixes = sprintf("%s.", stem_out[1]);
                             stem=stem_out[2];
                           }
                         else if(index(stem_parts[1], "_")!=0)
                           {
                             split(stem_parts[1], stem_out, "_");
                             prefixes = sprintf("%s_", stem_out[1]);
                             stem=stem_out[2];
                           }
                         else if(index(stem_parts[1], "=")!=0)
                           {
                             split(stem_parts[1], stem_out, "=");
                             prefixes = sprintf("%s=", stem_out[1]);
                             stem=stem_out[2];
                           }
                         else
                           {
                             stem=stem_parts[1];
                           }
                         stem=sprintf("%s%s", prefixes, stem);
                         stem_modified=sprintf("%s%s", prefixes, stem_parts[2]);
                       }
                     if(index(lemma," ")!=0 || index(stem," ")!=0 || index(lemma,"?")!=0 || index(stem,"?")!=0)
                       comment="CHECK LEMMA/STEM! ";
                     else
                       comment="";
                     if(asp=="" || aspect_label[asp]=="")
                       asp="CHECK";
                     if(stem_modified=="")
                       {
                         lexc=sprintf("%s%s:%s\t%s-%s ; ! %s ! OS: %s", comment, lemma, stem, arg_label[arg], clex, aspect_comment[asp], os_lines);
                         if(index(lexc,"CHECK")!=0)
                           lexc="! "lexc;
                         printf "%s\n", lexc;
                       }
                     else
                       {
                         lexc1=sprintf("%s%s:%s\t%s-%s-PlainStem ; ! %s ! OS: %s", comment, lemma, stem, arg_label[arg], clex, aspect_comment[asp], os_lines);
                         if(index(lexc1,"CHECK")!=0)
                           lexc1="! "lexc1;

                         lexc2=sprintf("%s%s:%s\t%s-%s-ModifiedStem ; ! %s ! OS: %s", comment, lemma, stem_modified, arg_label[arg], clex, aspect_comment[asp], os_lines);
                         if(index(lexc2,"CHECK")!=0)
                           lexc2="! "lexc2;
                         printf "%s\n%s\n", lexc1, lexc2;
                       }
                   }
        printf "\n";
      }
   }

   print ""; print "!! Continuation lexica specifying Valence + Aspect + TAMA + Voice-Valence with flags"; print "";
   for(arg in contlex)
      for(asp in contlex[arg])
         for(tama in contlex[arg][asp])
           if(index(asp,"CHECK")==0)
               for(i = 1; i <= 3; i++)
               {
                 if(contlex_suffixes[i] == "")
                   print "LEXICON "arg_label[arg]"-"tama"-"asp;
                 else
                   printf "LEXICON %s-%s-%s-%s\n", arg_label[arg], tama, asp, contlex_suffixes[i];

                 printf "@U.VALENCE.%s@", valence[arg];
                 asp_flag="@U.ASPECT."aspect_label[asp]"@" superaspect_flag[asp];
                 printf "%s", asp_flag;

                 ## TAMA and VV flags
                 # 0, ni, si, etc. —  @U.VV.%0@
                 # 0s, nis, sis, etc. — @U.VV.S@
                 # 0i, nii, sii-, etc. — @U.VV.I@

                 ## TAMA+ -> TAMA + VV conversions
                 # @U.TAMA.%0@ -> 0 + 0
                 # @U.TAMA.%0i@ -> 0 + i
                 # @U.TAMA.%0s@ -> 0 + s
                 # @U.TAMA.i@ -> i + 0
                 # @U.TAMA.ii@ -> i + i
                 # @U.TAMA.is@ -> i + s
                 # @U.TAMA.isi@ -> isi + 0
                 # @U.TAMA.isis@ -> isi + s
                 # @U.TAMA.ni@ -> ni + 0
                 # @U.TAMA.nii@ -> ni + i              
                 # @U.TAMA.nis@ -> ni + s
                 # @U.TAMA.si@ -> si + 0
                 # @U.TAMA.sii@ -> si + i 
                 # @U.TAMA.sis@ -> si + s
                 # @U.TAMA.yi-a@ -> yi-a + 0
                 # @U.TAMA.yi-y@ -> yi-y + 0
                 # @U.TAMA.yi@ -> yi + 0
                 # @U.TAMA.yii-y@ -> yi-y + i
                 # @U.TAMA.yis-a@ -> yi-a + s
                 # @U.TAMA.yis-y@ -> yi-y + s
                 # @U.TAMA.yis@ -> yi + s


                 tama_flag = tama;
                 gsub("0","%0",tama_flag);
                 vv="%0";
                 if(match(tama_flag,"(s\\-)|(s$)")!=0)
                   { vv="S"; sub("s-","-",tama_flag); sub("s$","",tama_flag); }
                 if(match(tama_flag,"ii")!=0 || match(tama_flag,"0i")!=0)
                   { vv="I"; sub("ii","i",tama_flag); sub("0i","0",tama_flag); }
                 printf "@U.TAMA.%s@", tama_flag;
                 printf "@U.VV.%s@", vv;

                 # @R.CONATIVE.OFF@ for: Transitive, Ditransitive, DirectObjectExperiencer, Transitional
                 if((match(arg, "Transitive") != 0 || arg=="Ditransitive" || arg=="DirectObjectExperiencer" || arg=="TransitionalTransitive") && match(arg, "Conative") == 0)
                   printf "@R.CONATIVE.OFF@";

                 # Additional flags governing paradigm restrictions
                 if(extraflags[arg]!="")
                   printf "%s", extraflags[arg];

                 printf "%s", contlex_suffix_flags[i];

                 printf " VerbSuffixes;\n\n";
               }
  print "";
  print "LEXICON VerbSuffixes";
  print "# ;";
  print ""; print"";

  if(report=="yes")
    { print ""; print report_text;
    }
}'
