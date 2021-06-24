#!/bin/sh

# Converts a list of pairs into a LEXC file

# Input: pairs.txt

# Usage: cat pairs.txt | ./pairs2lexc.sh > pairs.lexc

gawk 'BEGIN { output="LEXICON Root\n"; }
{ output=output sprintf("%s:%s # ;\n", $1, $2);
  while(match($1,"\\+([^\\+]+)",t)!=0)
       { mchars["+"t[1]]++; sub("\\+"t[1],""); }
}
END { print "Multichar_Symbols";
  for(i in mchars) print i;
  print "";
  print output;
}'
