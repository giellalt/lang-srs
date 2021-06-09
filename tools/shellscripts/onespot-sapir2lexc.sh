#!/bin/sh

# onespot-sapir2lexc.sh

# Usage:
# cat *.tsv (Lexical database in TSV format)
# | changing CRLF's into LF's
# | onespot-sapir2lexc.sh REPORT="yes"/"no"
# "yes" outputs dubious lines as a report at the end of the LEXC file.

# Example:
# cat ~/Downloads/Tsuut'ina\ -\ Preliminary\ lexical\ database\ -\ Verbs.tsv |
# tr -s '\r' '\n' |
# tools/shellscripts/onespot-sapir2lexc.sh yes > verb_stems.lexc

# Fields in the provisional Tsuut'ina lexical database based on the Onespot-Sapir glossary
# 1 OS
# 2 Citation form (3SG.SBJ)
# 3 Senses
# 4 FST Gloss template
# 5 morphemic parsing
# 6 Aspect
# 7 Argument structure
# 8 Inflectional paradigm
# 9 FST lemma
# 10 FST morphology
# 11 Source
# 12 Notes

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


gawk -v REPORT=$1 'BEGIN { FS="\t"; report=REPORT; report_text="!! REPORT OF IRREGULARITIES:"; }
NR==1 {
  for(i=1; i<=NF; i++)
    {
      os=1;
      if(index($i,"FST lemma")!=0) fst_lemma=i;
      if(index($i,"FST morphology")!=0) fst_stem=i;
      if(index($i,"Inflectional paradigm")!=0) tama=i;
      if(index($i,"Argument structure")!=0) args=i;
    }
  # Argument structure abbreviations for contlexes
  # Index corresponds to flag-diacritic value; value to contlex prefix
  arg_label["Impersonal"]="IMP";
  arg_label["Intransitive"]="INTR";
  arg_label["Intransitive-Subj3SgOnly"]="INTR-S3SG";
  arg_label["Intransitive-SubjSuppr"]="INTR-SS";
  arg_label["Transitive"]="TR";
  arg_label["TransitionalTransitive"]="TR-TR";
  arg_label["Transitive-SubjSuppr"]="TR-SS";
  arg_label["Transitive-SubjSuppr"]="TR-DO3SG";
  arg_label["Transitive-SubjSuppr"]="TR-ARL";
  arg_label["Ditransitive"]="DITR";
  arg_label["DirectObjectExperiencer"]="DOEXP";
  arg_label["ObliqueObject"]="OBL";
  arg_label["ObliqueObjectExperiencer"]="OBLEXP";

  # Aspect comment labels
  aspect_label["IPFV"]="Imperfective";
  aspect_label["IPFV-REP"]="Imperfective + Repetitive";
  aspect_label["PFV"]="Perfective"; 
  aspect_label["PFV-REP"]="Perfective + Repetitive"; 
  aspect_label["PROG"]="Progressive";
  aspect_label["POT"]="Potential";
  aspect_label["OPT"]="Optative";
  aspect_label["OTHER"]="Other aspect";
  aspect_label["CHECK"]="CHECK ASPECT";
  # print fst_lemma*1, fst_stem*1, tama*1;

}
NR>=2 {
  if($fst_lemma!="" && $fst_stem!="" && $tama!="" && $args!="")
    { # lemma[$fst_lemma]++;
      # clex[$tama]++;
      # lemma_tama_stem[$fst_lemma" "$tama]=$fst_stem
      aspect=""; superaspect="";
      if(match($tama,"(^.+)[-](IPFV|PFV|PROG|OPT|POT)([-](REP))?$",f)!=0)
        { tama_chunk=f[1]; aspect=f[2]; superaspect=f[4];
          if(superaspect!="") aspect=aspect"-"superaspect;
        }
      else
        { tama_chunk="CHECK-TAMA"; aspect="CHECK-ASPECT"; }        
      lemma_tama_stem[$args][$fst_lemma][aspect][$tama][$fst_stem]=lemma_tama_stem[$args][$fst_lemma][aspect][$tama][$fst_stem] $os ", ";
lemma_tama_stem[arg][lemma][asp][clex][stem]
      contlex[$args][aspect][tama_chunk]++;
    }
  else
    {
      report_text=report_text"\n!! LINE: "NR" - L: "$fst_lemma" - S: "$fst_stem" - T: "$tama;
    }
}
END { PROCINFO["sorted_in"]="@ind_str_asc";
# Header
print "!! Tsuut'\''na (srs) verb stems";
print "";

print "Multichar_Symbols";
print "! Flag specifications";
for(arg in contlex)
   { flags["@U.VALENCE."toupper(arg)"@"]++;
     for(asp in contlex[arg])
        { flags["@U.ASPECT."toupper(aspect_label[asp])"@"]++;
          for(tama in contlex[arg][asp])
            {
              gsub("0","%0",tama);
              flags["@U.TAMA."tama"@"]++;
            }
        }
   }

for(flag in flags)
   {
     if(index(flag,"REPETITIVE")!=0)
       sub(" \\+ ","@\n@U.SUPERASPECT.",flag);
     printf "%s\n", flag;
   }
printf "@U.VV.%0@\n@U.VV.I@\n@U.VV.S@\n@R.CONATIVE.OFF@\n";
printf "\n\n";

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
                     if(index(lemma," ")!=0 || index(stem," ")!=0 || index(lemma,"?")!=0 || index(stem,"?")!=0)
                       comment="CHECK LEMMA/STEM! ";
                     else
                       comment="";
                     if(asp=="" || aspect_label[asp]=="")
                       asp="CHECK";
                     lexc=sprintf("%s%s:%s\t%s-%s ; ! %s ! OS: %s", comment, lemma, stem, arg_label[arg], clex, aspect_label[asp], os_lines);
                     # printf "%s:%s\t%s-%s ; ! %s\n", lemma, stem, arg_pfx, clex, aspect_label[asp];
                     if(index(lexc,"CHECK")!=0)
                       lexc="! "lexc;
                     printf "%s\n", lexc;
                   }
        printf "\n";
      }
   }

   print ""; print "!! Continuation lexica specifying Valence + Aspect + TAMA with flags"; print "";
   for(arg in contlex)
      for(asp in contlex[arg])
         for(tama in contlex[arg][asp])
            {
              print "LEXICON "arg_label[arg]"-"tama"-"asp;
              printf "@U.VALENCE.%s@", toupper(arg);
              asp_flag="@U.ASPECT."toupper(aspect_label[asp])"@";
              if(index(asp,"REP")!=0)
                sub(" \\+ ","@@U.SUPERASPECT.",asp_flag);
              printf "%s", asp_flag;
              gsub("0","%0",tama);
              printf "@U.TAMA.%s@", tama;

              # 0, ni, si, etc. —  @U.VV.%0@
              # 0s, nis, sis, etc. — @U.VV.S@
              # 0i, nii, sii-, etc. — @U.VV.I@
              vv="%0";
              if(match(tama,"s[-$]")!=0)
                vv="S";
              if(match(tama,"ii")!=0)
                vv="I";
              printf "@U.VV.%s@", vv;

              # @R.CONATIVE.OFF@ for: Transitive, Ditransitive, DirectObjectExperiencer, Transitional
              if(arg=="Transitive" || arg=="Ditransitive" || arg=="DirectObjectExperiencer" || arg=="Transitional")
                printf "@R.CONATIVE.OFF@";

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
