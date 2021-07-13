#!/bin/sh

# Usage:
# cat Tsuut\'ina\ -\ Preliminary\ lexical\ database\ -\ Verbs.tsv | tools/shellscripts/validate-onespot-sapir-entries.sh
# | less


gawk -F"\t" 'NR>=2 { cmd="hfst-optimized-lookup -q src/fst/srs-analyser-gt-norm.hfstol";
  FS="\n"; RS="";
  print $2 |& cmd; fflush(); close(cmd, "to");
  cmd |& getline res; fflush(); close(cmd, "from");
  FS="\t"; RS="\n";
  lemma=$9; args=$7; asp=$6;
  sub("\\[.*$","",lemma);
  gsub("a","ā",lemma); gsub("e","ē",lemma); gsub("i","ī",lemma); gsub("o","ō",lemma); gsub("u","ū",lemma);
  print $1, "-", "W:", $2, "L:", lemma, "S:", $10;
  print $3;

  na=split(res,anl,"\n"); delete rank; delete matches;
  for(i=1; i<=na; i++)
     {
       lm="-"; am="-"; mm="-"; pm="-"; om="-";
       split(anl[i],f,"\t");

       # Congruence with lemma
       if(match(f[2],"^"lemma"\\+")!=0)
         {
           # sub(lemma,">"lemma"<",f[2]);
           rank[f[2]]++; lm="+";
         }
       else
         {
           f[2]=f[2] f[3];
           rank[f[2]]=rank[f[2]]+0;
           lm="-";
         }

       # Congruence with argument structure type
       if(index(args,"Intransitive")!=0 && index(f[2],"+I+")!=0)
         { rank[f[2]]++; am="+"; }
       if(index(args,"Transitive")!=0 && index(f[2],"+T+")!=0)
         { rank[f[2]]++; am="+"; }
       if(index(args,"Ditransitive")!=0 && index(f[2],"+D+")!=0)
         { rank[f[2]]++; am="+"; }

       # Congruence with aspect/mood
       if(asp=="Non-past" && index(f[2],"+Ipfv")!=0 && index(f[2],"+Rep")==0)
         { rank[f[2]]++; mm="+"; }
       if(asp=="Past" && index(f[2],"+Pfv")!=0 && index(f[2],"+Rep")==0)
         { rank[f[2]]++; mm="+"; }
       if(asp=="Progressive" && index(f[2],"+Prog")!=0 && index(f[2],"+Rep")==0)
         { rank[f[2]]++; mm="+"; }
       if(asp=="Repetitive-Non-past" && index(f[2],"+Ipfv")!=0 && index(f[2],"+Rep")!=0)
         { rank[f[2]]++; mm="+"; }
       if(asp=="Repetitive-Past" && index(f[2],"+Pfv")!=0 && index(f[2],"+Rep")!=0)
         { rank[f[2]]++; mm="+"; }

       # Congruence with subject
       if(match($3,"\\<I\\>")!=0 && index(f[2],"SbjSg1")!=0)
         { rank[f[2]]++; pm="+"; }
       if(match($3,"\\<[Yy]ouˢᵍ∙")!=0 && index(f[2],"SbjSg2")!=0)
         { rank[f[2]]++; pm="+"; }
       if((match($3,"\\<[Hh]e/she/it\\>")!=0 || match($3,"^[Ii]t\\>")!=0) && index(f[2],"SbjSg3")!=0)
         { rank[f[2]]++; pm="+"; }
       if(match($3,"\\<[Ss]ome")!=0 && index(f[2],"SbjSg4")!=0)
         { rank[f[2]]++; pm="+"; }
       if(match($3,"\\<[Ww]e\\>")!=0 && index(f[2],"SbjPl1")!=0)
         { rank[f[2]]++; pm="+"; }
       if(match($3,"\\<[Yy]ou")!=0 && index($3,"[Yy]ouˢᵍ∙")==0 && index(f[2],"SbjPl2")!=0)
         { rank[f[2]]++; pm="+"; }
       if(match($3,"\\<[Tt]hey\\>")!=0 && index(f[2],"SbjPl3")!=0)
         { rank[f[2]]++; pm="+"; }

       # Congruence with object
       if(match($3," \\<it\\>")!=0 && index(f[2],"DObjSg3")!=0)
         { rank[f[2]]++; om="+"; }
       if(match($3,"\\<them\\>")!=0 && index(f[2],"DObjPl3")!=0)
         { rank[f[2]]++; om="+"; }

       if(lm=="+")
         matches[f[2]]="L";
       else
         matches[f[2]]="-";
       if(am=="+")
         matches[f[2]]=matches[f[2]]"A";
       else
         matches[f[2]]=matches[f[2]]"-";
       if(mm=="+")
         matches[f[2]]=matches[f[2]]"M";
       else
         matches[f[2]]=matches[f[2]]"-";
       if(pm=="+")
         matches[f[2]]=matches[f[2]]"S";
       else
         matches[f[2]]=matches[f[2]]"-";
       if(om=="+")
         matches[f[2]]=matches[f[2]]"O";
       else
         matches[f[2]]=matches[f[2]]"-";
     }

  # Outputting analyses ranked based on feature matches
  PROCINFO["sorted_in"]="@val_num_desc";
  for(r in rank)
     printf "%i: %s | %s\n", rank[r], matches[r], r;
  print "";
}' 
