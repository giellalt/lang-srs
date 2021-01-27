#!/bin/sh

# onespot-sapir2lexc.sh

# Usage:
# cat *.tsv (Lexical database in TSV format)
# | changing CRLF's into LF's
# | onespot-sapir2lexc.sh REPORT="yes"/"no"
# "yes" outputs dubious lines as a report at the end of the LEXC file.

# Example:
# cat ~/Downloads/Tsuutina\ -\ Preliminary\ lexical\ database\ -\ Verbs.tsv |
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
    { if(index($i,"FST lemma")!=0) fst_lemma=i;
      if(index($i,"FST morphology")!=0) fst_stem=i;
      if(index($i,"Inflectional paradigm")!=0) tama=i;
      if(index($i,"Argument structure")!=0) args=i;
    }
  # Argument structure abbreviations for contlexes
  # arg_label["Transitive"]="TR";
  # arg_label["Intransitive"]="INTR";
  # arg_label["Ditransitive"]="DITR";
  # arg_label["Experiencer"]="EXP";
  # arg_label["Oblique"]="OBL";

  # Aspect comment labels
  aspect_label[1]="Imperfective";
  aspect_label[2]="Perfective"; 
  aspect_label[3]="Progressive";
  aspect_label[4]="Repetitive";
  aspect_label[5]="Potential";
  aspect_label[6]="Optative";
  aspect_label[7]="Other aspect";
  # print fst_lemma*1, fst_stem*1, tama*1;
}
NR>=2 {
  if($fst_lemma!="" && $fst_stem!="" && $tama!="" && $args!="")
    { # lemma[$fst_lemma]++;
      # clex[$tama]++;
      # lemma_tama_stem[$fst_lemma" "$tama]=$fst_stem
      aspect=0;
      if(index($tama,"IPFV")!=0)
        aspect=1;
      if(index($tama,"-PFV")!=0)
        aspect=2;
      if(index($tama,"PROG")!=0)
        aspect=3;
      if(index($tama,"REP")!=0)
        aspect=4;
      if(index($tama,"POT")!=0)
        aspect=5;
      if(index($tama,"OPT")!=0)
        aspect=6;
      if(aspect==0) aspect=7;
      lemma_tama_stem[$args][$fst_lemma][aspect][$tama][$fst_stem]++;
    }
  else
    { report_text=report_text"\n!! LINE: "NR" - L: "$fst_lemma" - S: "$fst_stem" - T: "$tama;
    }
}
END { PROCINFO["sorted_in"]="@ind_str_asc";
# Header
print "! Tsuut'\''na verb stems";
print "";
print "LEXICON Root";
for(arg in lemma_tama_stem)
   printf "%s ;\n", arg;
printf "\n\n";

for(arg in lemma_tama_stem)
   { printf "LEXICON %s\n\n", arg;
     for(lemma in lemma_tama_stem[arg])
      { printf "! %s\n", lemma;
        for(asp in lemma_tama_stem[arg][lemma])
           for(clex in lemma_tama_stem[arg][lemma][asp])
              for(stem in lemma_tama_stem[arg][lemma][asp][clex])
                 if(lemma_tama_stem[arg][lemma][asp][clex][stem]!="")
                   { arg_pfx="";
                     if(arg=="DirectObjectExperiencer") arg_pfx="DOEXP";
                     if(arg=="Ditransitive") arg_pfx="DITR";
                     if(arg=="Intransitive") arg_pfx="INTR";
                     if(arg=="Intransitive-SubjSuppr") arg_pfx="INTR-SS";
                     if(arg=="Transitive") arg_pfx="TR";
                     if(arg=="Transitive-SubjSuppr") arg_pfx="TR-SS";
                     if(arg_pfx=="") arg_pfx="CHECK";
                     lexc=sprintf("%s:%s\t%s-%s ; ! %s", lemma, stem, arg_pfx, clex, aspect_label[asp]);
                     # printf "%s:%s\t%s-%s ; ! %s\n", lemma, stem, arg_pfx, clex, aspect_label[asp];
                     if(index(lexc,"CHECK")!=0)
                       lexc="! "lexc;
                     printf "%s\n", lexc;
                   }
        printf "\n";
      }
   }
  if(report=="yes")
    { print ""; print report_text;
    }
}'
