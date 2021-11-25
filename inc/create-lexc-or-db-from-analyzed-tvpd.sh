#!/bin/sh

# OUTPUT: srslexc OR json (AND all) OR englexc (AND all)
# USAGE:
#
# 1. Word-list-based LEXC code for a srs FST analyzer
# cat starlight_eng_srs_anl4.tsv| inc/create-lexc-or-db-from-analyzed-tvpd.sh srslexc > srswords.lexc
#
#   OR
#
# 2. Lexical database with lemma word-forms as entries
# cat starlight_eng_srs_anl4.tsv| inc/create-lexc-or-db-from-analyzed-tvpd.sh json > srseng.importjson
#
#   OR
#
# 3. Lexical database with lemma and all other word-forms as entries (not yet producing valid content)
# cat starlight_eng_srs_anl4.tsv| inc/create-lexc-or-db-from-analyzed-tvpd.sh json all | less
#
#   OR
#
# 4. Transcriptor from Tsuut'ina lemmas + features to full English translations
# cat starlight_eng_srs_anl4.tsv| inc/create-lexc-or-db-from-analyzed-tvpd.sh englexc > srs2eng.lexc
#
#   OR
#
# 5. Transcriptor from English phrases (with all alternatives) to matching Tsuut'ina lemmas + features
# cat starlight_eng_srs_anl4.tsv| inc/create-lexc-or-db-from-analyzed-tvpd.sh englexc all > eng2srs.lexc
#
#   OR
#
# 6. Transcriptor from English phrases (with all alternatives) to matching English lexemes + features
# cat starlight_eng_srs_anl4.tsv| inc/create-lexc-or-db-from-analyzed-tvpd.sh englexc keys > eng2srs.lexc

gawk -v OUTPUT=$1 -v FORMS=$2 -F"\t" 'BEGIN { output=OUTPUT; forms=FORMS; }
NF==5 {
  # Standardizing certain characters
  gsub("’","'\''",$0);
  gsub("ɂ","ʔ",$0);

  # Assigning fields to variables
  eng[++nr]=$2; # English translation phrase corresponding to inflected word-form
  srs[nr]=$3;   # Tsuutina wordform
  englem[nr]=$4; englems[$4]++; # English translated phrase corresponding to lemma word-form
  anl[nr]=$5;   # Analysis of the English translated phrase with the eng2crk transcriptor 

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

  # Removing DO tags when resulting with duplicates in phrases
  # Needs more thinking
  # if(gsub("\\<you_sg\\>","&",eng[nr])>=2 || gsub("\\<you_pl\\>","&",eng[nr])>=2 || gsub("\\<someone)\\>","&",eng[nr])>=2)
  #   sub("\\+(2SgO|2PlO|XO)","",anl[nr]);

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

  # Figuring out Sg3 forms for each of the aspect types as possible lemma candidates
  if((match(anl[nr],"\\+SbjSg3(\\>|$)")!=0 && index(anl[nr],"DObj")==0) || (match(anl[nr],"\\+SbjSg3(\\>|$)")!=0 && index(anl[nr],"+DObjSg3")!=0))
    {
    if(index(anl[nr],"+Neg")==0)
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
    else
    {
      if(index(anl[nr],"+Ipfv")!=0 && index(anl[nr],"+Rep")==0)
        { ipfvneg[englem[nr]]=$3; ipfnegvdef[englem[nr]]=$2; }
      if(index(anl[nr],"+Pfv")!=0 && index(anl[nr],"+Rep")==0)
        { pfvneg[englem[nr]]=$3; pfvnegdef[englem[nr]]=$2; }
      if(index(anl[nr],"+Rep")!=0 && index(anl[nr],"+Pfv")==0)
        { ipfvreptneg[englem[nr]]=$3; ipfvreptnegdef[englem[nr]]=$2; }
      if(index(anl[nr],"+Rep")!=0 && index(anl[nr],"+Pfv")!=0)
        { pfvreptneg[englem[nr]]=$3; pfvreptnegdef[englem[nr]]=$2; }
      if(index(anl[nr],"+Prog")!=0 && index(anl[nr],"+Rep")==0 && index(anl[nr],"+Ipfv")==0 && index(anl[nr],"+Pfv")==0)
        { progneg[englem[nr]]=$3; prognegdef[englem[nr]]=$2; }
    }
    }
}

END {
  # Creating srs dictionary DB in JSON format
  db=sprintf("[\n");

  # Determining lemma form according to following hierarchy
  for(i in englems)
     {
       if(i in ipfv)
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
                  if(i in ipfvneg)
                    { lemdef=ipfvnegdef[i]; srslem=ipfvneg[i]; }
                  else
                    if(i in pfvneg)
                      { lemdef=pfvnegdef[i]; srslem=pfvneg[i]; }
                    else
                      if(i in ipfvreptneg)
                        { lemdef=ipfvreptnegdef[i]; srslem=ipfvreptneg[i]; }
                      else
                        if(i in pfvreptneg)
                          { lemdef=pfvreptnegdef[i]; srslem=pfvreptneg[i]; }
                        else
                          if(i in progneg)
                            { lemdef=prognegdef[i]; srslem=progneg[i]; }
                          else
                            { lemdef=""; srslem=""; }

       if(lemdef!="")
           srslems[i]=srslem;
  
       if(i in ipfv) stems="Ipfv: " ipfv[i]; else stems="Ipfv: –";
       if(i in pfv) stems=stems " | Pfv: "pfv[i]; else stems=stems " | Pfv: –";
       if(i in prog) stems=stems " | Prog: "prog[i]; else stems=stems " | Prog: –";
       if(i in ipfvrept) stems=stems " | Ipfv+Rep: "ipfvrept[i]; else stems=stems " | Ipfv+Rep: –";
       if(i in pfvrept) stems=stems " | Pfv+Rep: "pfvrept[i]; else stems=stems " | Pfv+Rep: –";

       ##### TEMPLATE for srs dictionary DB in json #####
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
           sub("[\\(]?something[\\)]? \\(something\\)","(something)",lemdef);
           gsub("="," ",lemdef);

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
           db=db sprintf("    \"linguistInfo\": {\n");
           db=db sprintf("      \"stem\": \"%s\"\n", stems);
           db=db sprintf("    },\n");
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

  # Addition of non-lemma inflected word forms as entries, if argument forms set to all
  if(forms=="all")
    for(i=1; i<=nr; i++)
       if(index(anl[i],"SbjSg3")==0 && (englem[i] in srslems) && index(srs[i]," ")==0)
         { 
           # printf "FORMOF: 1:%s 2:%s 3:%s 4:%s\n", srs[i], eng[i], srslems[englem[i]], anl[i];
           srslem=srslems[englem[i]];
           lemdef=eng[i];
           ntags=split(anl[i],tags,"\\+");
           srsslug=srs[i]; gsub(" ","_",srsslug);
           if(!(srsslug in slugs))
             { slugs[srsslug]=1; slugix=""; }
           else
             slugix="@" ++slugs[srsslug];

           db=db sprintf("  {\n");
           db=db sprintf("    \"analysis\": [\n");
           db=db sprintf("      [],\n");
           db=db sprintf("     \"%s\",\n", srslem);
           db=db sprintf("      [");
           for(t=1; t<=ntags-1; t++)
              db=db sprintf("\"+%s\", ", tags[t]);
           db=db sprintf("\"+%s\"]\n", tags[t]);
           db=db sprintf("    ],\n");
           db=db sprintf("    \"formOf\": \"%s\",\n",  srslem);
           db=db sprintf("    \"head\": \"%s\",\n", srs[i]);
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

  db=db sprintf("]\n");
  sub(",\n\n\\]\n$", "\n]", db);
  if(output=="json")
    print db;

  # Creating LEXC source for FST
  lexc="LEXICON Root\n";
  for(i=1; i<=nr; i++)
     if(aspect[nr]!="")
     # Determining lemma according to above presented hierarchy
     { 
       if(englem[i] in ipfv)
         lemma=ipfv[englem[i]];
       else
         if(englem[i] in pfv)
           lemma=pfv[englem[i]];
         else
           if(englem[i] in ipfvrept)
             lemma=ipfvrept[englem[i]];
           else
             if(englem[i] in pfvrept)
               lemma=pfvrept[englem[i]];
             else
               if(englem[i] in prog)
                 lemma=prog[englem[i]];
               else
                 if(englem[i] in ipfvneg)
                   lemma=ipfvneg[englem[i]];
                 else
                   if(englem[i] in pfvneg)
                     lemma=pfvneg[englem[i]];
                   else
                     if(englem[i] in ipfvreptneg)
                       lemma=ipfvreptneg[englem[i]];
                     else
                       if(englem[i] in pfvreptneg)
                         lemma=pfvreptneg[englem[i]];
                       else
                         if(englem[i] in progneg)
                           lemma=progneg[englem[i]];
                         else
                           lemma="";
       if(lemma!="")
         {
           comment=eng[i]; gsub("="," ",comment);
           gsub("[ ]+","% ",lemma); gsub("[ ]+","% ",srs[i]);
           lexc=lexc sprintf("%s+%s:%s # ; ! \"%s\"\n", lemma, anl[i], srs[i], comment);
           ntags=split(anl[i],tags,"\\+");
           for(j=1; j<=ntags; j++)
              multichars["+"tags[j]]++;
         }
     }
   # Creating LEXC-initial list of multicharacter symbols
   multichar_symbols="Multichar_Symbols\n";
   PROCINFO["sorted_in"]="@ind_str_asc";
   for(j in multichars)
      multichar_symbols=multichar_symbols sprintf("%s\n", j);

   if(output=="srslexc")
     printf "%s\n%s", multichar_symbols, lexc;

   # Creating FST transcriptor between English translation phrases and Tsuutina word-forms
   fst="LEXICON Root\n";
   for(i=1; i<=nr; i++)
      if(match(anl[i],"^V\\+")!=0)
      {
        srslem=srslems[englem[i]]; gsub(" ","_",srslem);
        ntags=split(anl[i],tags,"\\+");
           for(j=1; j<=ntags; j++)
              multichars["+"tags[j]]++;

        engtr=eng[i];
        engkeys=englem[i];
        gsub("you_sg","you",engtr);
        gsub("you_pl","you all",engtr);
        gsub("someone_pl","people",engtr);
        # print engtr;
        sub("[\\(]?something[\\)]? \\(something\\)","(something)",engtr);
        # print engtr;
        if(forms=="all" || forms=="keys")
          {
            gsub("\\<will\\>","(&)",engtr); # Turn auxiliary <will> optional (allowing recognition of both present/future tense)
            # gsub("\\(will\\) [^\\/]+","&Xs",engtr); gsub("\\(will\\) [^ ]+","&Xs",engtr);
            # gsub("yXs","i(es)",engtr); gsub("sXs","s(es)",engtr);  gsub("zXs","z(es)",engtr);  gsub("xXs","x(es)",engtr);  gsub("shXs","sh(es)",engtr);  gsub("chXs","ch(es)",engtr);
            # gsub("Xs","(s)",engtr);
            # gsub("\\(will\\) [^ ]+(s|z|x|sh|ch)","&Xes",engtr); gsub("\\(will\\) [^ X]+\\>","&Xs",engtr);
            # gsub("X[^ ]+","(&)",engtr); gsub("X","",engtr);
            gsub(" \\([^\\)]*\\)","[0|&]",engtr); # Turn parenthesized elements optional
            # print engtr;
            gsub(" ","_",engtr);
            # print engtr;
            gsub("\\([^/]+/[^\\)]+\\)","(&)",engtr); # Treat slash-separated elements as alternatives
            gsub("\\(\\(","(_",engtr); # Reinterpret double parentheses
            gsub("\\)\\)","_)",engtr);
            gsub("/","|",engtr); # Swapping slash to regex OR pipe
            # print engtr;
            gsub("[^_]+\\|[^_\\[]+","[&]",engtr); # print engtr;
            gsub("\\(_","(",engtr);
            gsub("_\\)",")",engtr);
            gsub("="," ",engtr);
            gsub("[\\(\\)]","",engtr);
            # gsub("[ ]+"," ",engtr);
            # print engtr;
          }
        if(forms=="keys")
          {
            gsub("\\<(I|i|you_sg|you_pl|he|she|it|he/she|he/she/it|we|they|someone|someone_sg|someone_pl|me|him|her|him/her|him/her/it|us|them)\\>","",engkeys);
            gsub("\\<each and every one( of\\>)?","",engkeys);
            gsub("\\<all\\>","",engkeys);
            gsub("\\<will ","",engkeys);
            gsub("\\<(am|is|are|was|were|been)\\>","be",engkeys);
            gsub("\\<again and again\\>","",engkeys);
            gsub("/"," ",engkeys); gsub("[\\(\\)]","",engkeys); gsub("="," ",engkeys);
            gsub("[ _]+"," ",engkeys); sub("^[ ]+","",engkeys); sub("[ ]+$","",engkeys);
            # print engkeys;
          }

        # Constructing together a single LEXC line
        fst=fst "< [";
        if(forms=="all" || forms=="keys")
          {
            if(forms=="keys")
              srslem=engkeys;
            n=split(srslem,c,"");
              for(j=1; j<=n; j++)
                 fst=fst sprintf(" %s", c[j]);
            for(j=1; j<=ntags; j++)
               fst=fst sprintf(" \"+%s\"", tags[j]);
            fst=fst " ] : [";
            gsub("[\\(\\)]","",engtr);
            n=split(engtr,c,"");
            for(j=1; j<=n; j++)
               fst=fst sprintf(" %s", c[j]);
            fst=fst sprintf(" ] > # ;\n");
            # fst=fst sprintf("%s:%s+%s # ;\n", engtr, srslem, anl[i]);
          }
        else
          {
            gsub("="," ",engtr);
            n=split(engtr,c,"");
            for(j=1; j<=n; j++)
               fst=fst sprintf(" %s", c[j]);
            fst=fst " ] : [";
            n=split(srslem,c,"");
              for(j=1; j<=n; j++)
                 fst=fst sprintf(" %s", c[j]);
            for(j=1; j<=ntags; j++)
               fst=fst sprintf(" \"+%s\"", tags[j]);
            fst=fst sprintf(" ] > # ;\n");
            # fst=fst sprintf("%s:%s+%s # ;\n", engtr, srslem, anl[i]);
          }
      }
     gsub("[_]+","% ",fst);
     gsub("[\\(\\)\\-]","%&",fst);
     gsub("   "," %  ",fst);
     if(forms!="all")
       gsub("/","%/",fst);
     else
       gsub(" %[\\(\\)]","",fst);
     gsub("\\| \\]","]",fst);
     gsub("\\[ \\|","[",fst);

   # Outputting eng2srs transcriptor FST
   if(output=="englexc")
     printf "%s\n%s", multichar_symbols, fst;

}'
