#!/bin/sh

# Usage:
## cat ~/GDrive/Tsuut\'ina/Starlight2.xml |
# cat ~/altlab2/srs/inc/TVPD1.xml |
# inc/analyze-tvpd-english-translations-as-cree.sh ../lang-crk/english-phrase-analysis.fomabin
# | less

gawk -v FST=$1 'BEGIN { engfst=FST; }
{ m=match($0, "<paradigm aspect=\"([^\"]+)\" lemma=\"([^\"]+)\"", f);
  if(m!=0)
    { aspect=f[1]; gsub(" ","",aspect); lemma=f[2]; }
  gsub("they will","he/she will",lemma);

  m=match($0,"<eng>([^<]+)</eng><srs>([^<]+)</srs>",paradigm);
  flookup="flookup -i -b -x "engfst;

  if(m!=0 && paradigm[1]!="")
    {
      gsub("\\<i\\>","I",paradigm[1]);
      tr=paradigm[1]; src=paradigm[2];
      sub("\\.$","",src);
      gsub(" all\\>","",tr);
      gsub("to (him/her/it|him/her|him|her)","to Bruce",tr);
      gsub("[Yy]ou(ˢᶢ|ˢᵍ|ˢᶢ·|ˢᵍ∙|ˢᶢ∙|_sg)","you",tr);
      gsub("[Yy]ou(ᵖˡ|ᵖˡ·|ᵖˡ∙|ᵖᴵ∙|_pl)","you all ",tr);
      gsub("\\<([Hh]e/[Ss]he/[Ii]t|[Hh]e/[Ss]he|[Hh]e|[Ss]he)\\>","she", tr);
      gsub("\\<It\\>","it",tr);
      gsub("\\<We\\>","we",tr);
      gsub("\\<They\\>","they",tr);
      gsub("[Ss]omeone|[Ss]omebody","someone",tr);
      gsub("[Ss]omeone_pl","someone",tr);
      gsub("\\<(him/her/it|him/her)\\>","him",tr);
      gsub("\\<it/them\\>","it",tr);
      gsub("\\<something(/s)?\\>","it",tr);
      gsub("="," ",tr);

      gsub("[ ]+"," ",tr);

      # Contractions
      gsub("don’t","don'\''t",tr);
      gsub("can’t","can'\''t",tr);

      # Reflexive
      gsub("himself/herself","himself",tr);

      # Distributive cases
      gsub("each and every one of us","we each and every one",tr);
      gsub("each and every one of you_pl","you all each and every one",tr);
      gsub("each and every one of them","they each and every one",tr);

      gsub("/"," / ",tr);
      gsub("\\<You\\>","you",tr);
      gsub("ᵖʳᵒᶢ","",tr);
      gsub("\\([^\\)]+\\)","",tr);
      sub("\\.$","",tr);

      print tr |& flookup;
      flookup |& getline line;
      close(flookup);

      gsub("[ ]+"," ",line);
      sub("^[ ]+","",line);
      sub("[ ]+$","",line);
      split(line,anl," \\+");

      # Interpreting some Tsuutina-specific miniphrases
      if(gsub("each and every one ","",anl[1])!=0)
        distr="+Distr";
      else distr="";
      if(gsub(" to Bruce","",anl[1])!=0)
        iobj="+IObj3Sg";
      else
        iobj="";

      # Identifying parenthesized word-classes in lemma definitions that should be added to word-form translations
      n=split(lemma,w," ");
      class="";
      while(match(w[n],"^\\(.+\\)$")!=0)
         { if(match(w[n],"[[:upper:]]")==0 && index(paradigm[1],w[n])==0) class=" " w[n] class; n--; }
      
      if(index(line,"+?")!=0)
        printf "%i\t%s\t%s\t+?\n", NR, paradigm[1], tolower(src);
      else
        printf "%i\t%s%s\t%s\t%s\t%s%s%s+%s\n", NR, paradigm[1], class, tolower(src), lemma, anl[2], distr, iobj, toupper(aspect);
    }
}'
