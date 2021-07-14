#!/bin/sh

# Usage:
# cat Tsuut\'ina\ -\ Preliminary\ lexical\ database\ -\ Verbs.tsv | tools/shellscripts/validate-onespot-sapir-entries.sh
# | less


gawk -F"\t" 'NR>=2 { cmd="hfst-optimized-lookup -q src/fst/srs-analyser-gt-norm.hfstol";
  OS=$1; entry=$2; definition=$3; 
  FS="\n"; RS="";
  print entry |& cmd; fflush(); close(cmd, "to");
  cmd |& getline res; fflush(); close(cmd, "from");
  FS="\t"; RS="\n";

  # Setting lexical variables
  lemma=$9; stem=$10; valence=$7; aspect=$6;
  sub("\\[.*$","",lemma);
  gsub("a","ā",lemma); gsub("e","ē",lemma); gsub("i","ī",lemma); gsub("o","ō",lemma); gsub("u","ū",lemma);
  print OS, "-", "W:", entry, "L:", lemma, "S:", stem, "V:", valence;
  print $3;

  na=split(res,anl,"\n"); delete rank; delete matches;
  for(i=1; i<=na; i++)
     {
       hm="-"; lm="-"; vm="-"; am="-"; pm="-"; om="-";
       split(anl[i],f,"\t");

       # Congruence of FST lemma with DB lemma
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

       # Equality of FST lemma with entry head(word)
       fstlemma=f[2];
       sub("\\+.*$","",fstlemma);
       if(fstlemma==entry && index(f[2],"+SbjSg3")!=0)
         hm="+";
       else
         hm="-";

       # Congruence with argument structure type
       if(index(valence,"Intransitive")!=0 && index(f[2],"+I+")!=0)
         { rank[f[2]]++; vm="+"; }
       if(index(valence,"Transitive")!=0 && index(f[2],"+T+")!=0)
         { rank[f[2]]++; vm="+"; }
       if(index(valence,"Ditransitive")!=0 && index(f[2],"+D+")!=0)
         { rank[f[2]]++; vm="+"; }
       if(valence=="ObliqueObject" && index(f[2],"+O+")!=0)
         { rank[f[2]]++; vm="+"; }
       if(index(valence,"Experiencer")!=0 && index(f[2],"+E+")!=0)
         { rank[f[2]]++; vm="+"; }

       # Congruence with aspect/mood
       if(aspect=="Non-past" && index(f[2],"+Ipfv")!=0 && index(f[2],"+Rep")==0)
         { rank[f[2]]++; am="+"; }
       if(aspect=="Past" && index(f[2],"+Pfv")!=0 && index(f[2],"+Rep")==0)
         { rank[f[2]]++; am="+"; }
       if(aspect=="Progressive" && index(f[2],"+Prog")!=0 && index(f[2],"+Rep")==0)
         { rank[f[2]]++; am="+"; }
       if(aspect=="Repetitive-Non-past" && index(f[2],"+Ipfv")!=0 && index(f[2],"+Rep")!=0)
         { rank[f[2]]++; am="+"; }
       if(aspect=="Repetitive-Past" && index(f[2],"+Pfv")!=0 && index(f[2],"+Rep")!=0)
         { rank[f[2]]++; am="+"; }

       # Congruence with subject
       if(match(definition,"\\<I\\>")!=0 && index(f[2],"SbjSg1")!=0)
         { rank[f[2]]++; pm="+"; }
       if(match(definition,"\\<[Yy]ouˢᵍ∙")!=0 && index(f[2],"SbjSg2")!=0)
         { rank[f[2]]++; pm="+"; }
       if((match(definition,"\\<[Hh]e/she/it\\>")!=0 || match(definition,"^[Ii]t\\>")!=0) && index(f[2],"SbjSg3")!=0)
         { rank[f[2]]++; pm="+"; }
       if(match(definition,"\\<[Ss]ome")!=0 && index(f[2],"SbjSg4")!=0)
         { rank[f[2]]++; pm="+"; }
       if(match(definition,"\\<[Ww]e\\>")!=0 && index(f[2],"SbjPl1")!=0)
         { rank[f[2]]++; pm="+"; }
       if(match(definition,"\\<[Yy]ou")!=0 && index(definition,"[Yy]ouˢᵍ∙")==0 && index(f[2],"SbjPl2")!=0)
         { rank[f[2]]++; pm="+"; }
       if(match(definition,"\\<[Tt]hey\\>")!=0 && index(f[2],"SbjPl3")!=0)
         { rank[f[2]]++; pm="+"; }

       # Congruence with object (direct or indirect)
       if(match(definition,"\\<me\\>")!=0 && index(f[2],"ObjSg1")!=0)
         { rank[f[2]]++; om="+"; }
       if(match(definition," youˢᵍ∙")!=0 && index(f[2],"ObjSg2")!=0)
         { rank[f[2]]++; om="+"; }
       if((match(definition," \\<it\\>")!=0 || match(definition,"\\<him/her/it\\>")!=0 || match(definition," something\\>")!=0) && index(f[2],"ObjSg3")!=0)
         { rank[f[2]]++; om="+"; }
       if(match(definition,"\\<us\\>")!=0 && index(f[2],"ObjPl1")!=0)
         { rank[f[2]]++; om="+"; }
       if(match(definition," you")!=0 && match(definition," youˢᵍ∙")==0 &&  index(f[2],"ObjPl2")!=0)
         { rank[f[2]]++; om="+"; }
       if(match(definition,"\\<them\\>")!=0 && index(f[2],"ObjPl3")!=0)
         { rank[f[2]]++; om="+"; }

       # Aggregating and relabeling congruence results
       if(hm=="+")
         matches[f[2]]="H";
       else
         matches[f[2]]="-";
       if(lm=="+")
         matches[f[2]]=matches[f[2]]"L";
       else
         matches[f[2]]=matches[f[2]]"-";
       if(vm=="+")
         matches[f[2]]=matches[f[2]]"V";
       else
         matches[f[2]]=matches[f[2]]"-";
       if(am=="+")
         matches[f[2]]=matches[f[2]]"A";
       else
         matches[f[2]]=matches[f[2]]"-";
       if(pm=="+")
         matches[f[2]]=matches[f[2]]"S";
       else
         matches[f[2]]=matches[f[2]]"-";
       if(match(valence,"(Intransitive)|(Impersonal)")==0)
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
