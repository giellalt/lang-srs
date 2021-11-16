#!/bin/sh

# OUTPUT: lexc OR db
# USAGE:
# cat starlight_eng_srs_anl4.tsv| inc/create-lexc-or-db-from-analyzed-tvpd.sh lexc | less
#   OR
# cat starlight_eng_srs_anl4.tsv| inc/create-lexc-or-db-from-analyzed-tvpd.sh db | less

gawk -v OUTPUT=$1 -F"\t" 'BEGIN { output=OUTPUT; }
NF==5 {
  gsub("’","'\''",$0);
  eng[++nr]=$2;
  srs[nr]=$3;
  englem[nr]=$4; englems[$4]++;
  anl[nr]=$5;

  # Interpreting cases with given NP objects in translations as Transitive, with DObj3Sg tag:
  # this book, ones rope, a headache,  his/her/its voice, a hoop, a house, water, candy 
  if(match(eng[nr],"\\<(this book|rope|a (headache|hoop|house)|his/her/its voice|water|candy)\\>")!=0 && match(anl[nr],"[03](Sg|Du|Pl)O")==0)
    sub("\\+(([0-4](Sg|Pl|Du))|X)(\\>|$)","&+0SgO",anl[nr]);

  #####
  # Interpreting combination of TVPD aspect classifications and engcrk tense analysis tags
  #####

  aspect[nr]="";

  # +NONPAST -Prt -Rept -> Ipfv
  # +NONPAST +Prt -> Pfv
  # Exceptions -> Ipfv
  # - will put it up on something -> Ipfv
  # - get(s) lost in thought while writing something -> Ipfv

  if(index(anl[nr],"+NONPAST")!=0 && index(anl[nr],"+Prt")==0 && index(anl[nr],"+Rept")==0) aspect[nr]="+Ipfv";
  if(index(anl[nr],"+NONPAST")!=0 && index(anl[nr],"+Prt")!=0)
    if(index(eng[nr],"will put it up on something")!=0 || index(eng[nr],"lost in thought while writing something")!=0) aspect[nr]="+Ipfv";
    else aspect[nr]="+Pfv";

  # +PAST -Rept -> Pfv
  # +PAST +Rept -> Pfv+Rep
  # +PAST -Prt +Def -> Ipfv
  # +PAST -Prt +Prog -> Pfv
  # +PAST -Prt -Def +Prog -> Ipfv

  if(index(anl[nr],"+PAST")!=0 && index(anl[nr],"+Rept")==0) aspect[nr]="+Pfv";
  if(index(anl[nr],"+PAST")!=0 && index(anl[nr],"+Rept")!=0) aspect[nr]="+Pfv+Rep";
  if(index(anl[nr],"+PAST")!=0 && index(anl[nr],"+Prt")==0 && index(anl[nr],"+Def")!=0) aspect[nr]="+Ipfv";
  if(index(anl[nr],"+PAST")!=0 && index(anl[nr],"+Prt")==0 && index(anl[nr],"+Prog")!=0) aspect[nr]="+Pfv";
  if(index(anl[nr],"+PAST")!=0 && index(anl[nr],"+Prt")==0 && index(anl[nr],"+Def")==0 && index(anl[nr],"+Prog")!=0) aspect[nr]="+Ipfv";

  # +PAST -Prt -Def -Prog -> Pfv
  # Except -> Ipfv
  # - laugh along with him/her in a joking way
  # - might start to ache
  # - might be weak later on

  if(index(anl[nr],"+PAST")!=0 && index(anl[nr],"+Prt")==0 && index(anl[nr],"+Def")==0 && index(anl[nr],"+Prog")==0)
    if(index(eng[nr],"laugh along with him/her in a joking way")!=0 || index(eng[nr],"might start to ache")!=0 || index(eng[nr],"might be weak later on")!=0) aspect[nr]="+Ipfv";
    else aspect[nr]="+Pfv";

  # +REPETITIVE +Rept +Prt -> Pfv+Rep
  # +REPETITIVE +Rept -Prt -> Ipfv+Rep
  # +REPETITIVE -Rept
  # - tooth/teeth aches -> Ipfv+Rep
  # - leg/legs aches -> Ipfv+Rep
  # - foot/feet aches -> Ipfv+Rep

  if(index(anl[nr],"+REPETITIVE")!=0 && index(anl[nr],"+Rept")!=0 && index(anl[nr],"+Prt")!=0) aspect[nr]="+Pfv+Rep";
  if(index(anl[nr],"+REPETITIVE")!=0 && index(anl[nr],"+Rept")!=0 && index(anl[nr],"+Prt")==0) aspect[nr]="+Ipfv+Rep";
  if(index(anl[nr],"+REPETITIVE")!=0 && index(anl[nr],"+Rept")==0)
    if(index(eng[nr],"tooth/teeth aches")!=0 || index(eng[nr],"leg/legs aches")!=0 || index(eng[nr],"foot/feet aches")!=0) aspect[nr]="+Ipfv+Rep";

  # +PROGRESSIVE +Def -> Ipfv
  # +PROGRESSIVE -Def +Prog -> Prog
  # +PROGRESSIVE -Def -Prog -> Ipfv

  if(index(anl[nr],"+PROGRESSIVE")!=0 && index(anl[nr],"+Def")!=0) aspect[nr]="+Ipfv";
  if(index(anl[nr],"+PROGRESSIVE")!=0 && index(anl[nr],"+Def")==0 && index(anl[nr],"+Prog")==0) aspect[nr]="+Ipfv";
  if(index(anl[nr],"+PROGRESSIVE")!=0 && index(anl[nr],"+Def")==0 && index(anl[nr],"+Prog")!=0) aspect[nr]="+Prog";

  if(index(anl[nr],"+UNKNOWN")!=0 && (index(anl[nr],"+Def")!=0 || index(anl[nr],"+Fut")!=0) && index(anl[nr],"+Rept")==0) aspect[nr]="+Ipfv";
  if(index(anl[nr],"+UNKNOWN")!=0 && index(anl[nr],"+Prt")!=0) aspect[nr]="+Pfv";
  if(index(anl[nr],"+UNKNOWN")!=0 && (index(anl[nr],"+Def")!=0 || index(anl[nr],"+Fut")!=0) && index(anl[nr],"+Rept")!=0) aspect[nr]="+Ipfv+Rep";
  if(index(anl[nr],"+UNKNOWN")!=0 && index(anl[nr],"+Prt")!=0 && index(anl[nr],"+Rept")!=0) aspect[nr]="+Pfv+Rep";
  if(index(anl[nr],"+UNKNOWN")!=0 && index(anl[nr],"+Prog")!=0) aspect[nr]="+Prog";

  gsub("\\+((Prt|Def|Fut|Int|Prog|Rept))","",anl[nr]);
  sub("\\+((NONPAST|PAST|PROGRESSIVE|REPETITIVE|UNKNOWN))","",anl[nr]);
  sub("V\\+(II|AI|TI|TA)","&"aspect[nr],anl[nr]);

  # Interpreting engcrk tense tags as engsrs aspect ones - old version relying purely on engcrk tags
  # sub("\\+(Def|Fut)","+Ipfv",anl[nr]);
  # sub("\\+Prt","+Pfv",anl[nr]);
  # sub("\\+Rept","+Rep",anl[nr]);
  # if(index(anl[nr],"+Rep")!=0 && index(anl[nr],"+Ipfv")==0 && index(anl[nr],"+Pfv")==0)
  #   sub("\\+Rep","+Ipfv&",anl[nr]);

  # Interpreting engcrk subject/object tags as engsrs ones
  sub("\\+[^\\+]+O","+DObj&",anl[nr]); sub("DObj\\+","DObj",anl[nr]); sub("O\\+","+",anl[nr]); sub("O$","",anl[nr]);
  sub("\\+[0-3](Sg|Pl)","+Sbj&",anl[nr]); sub("\\+Sbj\\+","+Sbj",anl[nr]);
  sub("\\+X","+Sbj4Sg",anl[nr]);
  gsub("0Sg","3Sg",anl[nr]);

  # Reordering person tags
  match(anl[nr], "Sbj([0-4])(Sg|Du|Pl)", f);
  sub("Sbj"f[1]f[2], "Sbj"f[2]f[1], anl[nr]);
  match(anl[nr], "DObj([0-4])(Sg|Du|Pl)", f);
  sub("DObj"f[1]f[2], "DObj"f[2]f[1], anl[nr]);
  match(anl[nr], "IObj([0-4])(Sg|Du|Pl)", f);
  sub("IObj"f[1]f[2], "IObj"f[2]f[1], anl[nr]);

  # Devising valency tags based on engcrk analyses
  if(index(anl[nr],"IObj")!=0 && index(anl[nr],"DObj")!=0)
    valence="+D";
  if(index(anl[nr],"DObj")!=0 && index(anl[nr],"IObj")==0)
    valence="+T";
  if(index(anl[nr],"DObj")==0 && index(anl[nr],"IObj")==0)
    valence="+I";
  sub("\\+(II|AI|TI|TA)",valence,anl[nr]);

  defanl[eng[nr]]=anl[nr];

  # Figuring our possible lemmas
  if(match(anl[nr],"\\+SbjSg3(\\+|$)")!=0 && (index(anl[nr],"DObj")==0 || (match(anl[nr],"\\+SbjSg3(\\+|$)")!=0 && index(anl[nr],"+DObjSg3")!=0)))
    {
      if(index(anl[nr],"+Ipfv")!=0 && index(anl[nr],"+Rep")==0)
        { ipfv[englem[nr]]=$3; ipfvdef[englem[nr]]=$2; }
      if(index(anl[nr],"+Pfv")!=0 && index(anl[nr],"+Rep")==0)
        { pfv[englem[nr]]=$3; pfvdef[englem[nr]]=$2; }
      if(index(anl[nr],"+Rep")!=0 && index(anl[nr],"+Pfv")==0)
        { ipfvrept[englem[nr]]=$3; ipfvreptdef[englem[nr]]=$2; }
      if(index(anl[nr],"+Rep")!=0 && index(anl[nr],"+Pfv")!=0)
        { pfvrept[englem[nr]]=$3; pfvreptdef[englem[nr]]=$2; }
      if(index(anl[nr],"+Prog")!=0 && index(anl[nr],"+Rep")==0 && index(anl[nr],"+Ipfv")==0 && index(anl[nr],"+Pfv")==0)
        { prog[englem[nr]]=$3; progdef[englem[nr]]=$2; }
    }
}

END {
  # Creating srs dictionary DB in JSON format
  db=sprintf("[\n");
  for(i in englems)
     { if(i in ipfv)
         { lemdef=ipfvdef[i]; srslem=ipfv[i]; }
       else
         if(i in pfv)
           { lemdef=pfvdef[i]; srslem=pfv[i]; }
         else
           if(i in ipfvrept)
             { lemdef=ipfvreptdef[i]; srslem=ipfvrept[i]; }
           else
             if(i in pfvrept)
               { lemdef=pfvreptdef[i]; srslem=pfvrept[i]; }
             else
                if(i in prog)
                  { lemdef=progdef[i]; srslem=prog[i]; }
                else
                  { lemdef=""; srslem=""; }

##### Template for srs dictionary DB in json #####
# [
#   {
#     "analysis": [
#       [],
#       "ànīyìgás",
#       ["+V", "+O", "+Ipfv", "+Sbj3Sg", "+IObjSb3", "+IObjGiven"]
#     ],
#     "head": "ànīyìgás",
#     "linguistInfo": {
#       "stem": "à=_niyi.gás (i-IPFV)"
#     },
#     "paradigm": "VO",
#     "senses": [
#       {
#         "definition": "he/she/it will bite him/her/it",
#         "sources": ["OS"]
#       }
#     ],
#     "slug": "ànīyìgás"
#   },
# ...
# ]
##### END TEMPLATE #####

       if(lemdef!="")
         # printf "%i: %s\t%s\t%s\n", ++k, srslem, lemdef, defanl[lemdef];
         {
           ntags=split(defanl[lemdef],tags,"\\+");
           srsslug=srslem; gsub(" ","_",srsslug);
           if(!(srsslug in slugs))
             { slugs[srsslug]=1; slugix=""; }
           else
             slugix="_" ++slugs[srsslug];
           db=db sprintf("  {\n");
           db=db sprintf("    \"analysis\": [\n");
           db=db sprintf("      [],\n");
           db=db sprintf("     \"%s\",\n", srslem);
           db=db sprintf("      [");
           for(t=1; t<=ntags-1; t++)
              db=db sprintf("\"+%s\", ", tags[t]);
           db=db sprintf("\"+%s\"]\n", tags[t]);
           db=db sprintf("    ],\n");
           db=db sprintf("    \"head\": \"%s\",\n", srslem);
           db=db sprintf("    \"paradigm\": \"%s%s\",\n", tags[1], tags[2]);
           db=db sprintf("    \"senses\": [\n");
           db=db sprintf("      {\n");
           db=db sprintf("        \"definition\": \"%s\",\n", lemdef);
           db=db sprintf("        \"sources\": [\"TVPD\"]\n");
           db=db sprintf("      }\n");
           db=db sprintf("    ],\n");
           db=db sprintf("    \"slug\": \"%s%s\"\n", srsslug, slugix);
           db=db sprintf("  },\n");
           db=db sprintf("\n");
         }
     }
  db=db sprintf("]\n");
  sub(",\n\n\\]\n$", "\n]", db);
  if(output=="db")
    print db;

  # Creating LEXC source for FST
  lexc="LEXICON Root\n";
  multichar_symbols="Multichar_Symbols\n";
  for(i=1; i<=nr; i++)
     if(aspect[nr]!="")
     { 
       if(englem[i] in ipfv)
         lemma=ipfv[englem[i]];
       else
         if(englem[i] in ipfvrept)
           lemma=ipfvrept[englem[i]];
         else
           if(englem[i] in pfv)
             lemma=pfv[englem[i]];
           else
             if(englem[i] in pfvrept)
               lemma=pfvrept[englem[i]];
             else
               if(englem[i] in prog)
                 lemma=prog[englem[i]];
               else
                 lemma="";
       if(lemma!="")
         { gsub("[ ]+","% ",lemma); gsub("[ ]+","% ",srs[i]);
           lexc=lexc sprintf("%s+%s:%s # ; ! \"%s\"\n", lemma, anl[i], srs[i], eng[i]);
           ntags=split(anl[i],tags,"\\+");
           for(j=1; j<=ntags; j++)
              multichars["+"tags[j]]++;
         }
     }
   PROCINFO["sorted_in"]="@ind_str_asc";
   for(j in multichars)
      multichar_symbols=multichar_symbols sprintf("%s\n", j);

   if(output=="lexc")
     printf "%s\n%s", multichar_symbols, lexc;
}'
