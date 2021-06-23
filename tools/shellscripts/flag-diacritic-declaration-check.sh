#!/bin/sh

# flag-diacritic-declaration-check.sh

# Usage:
# cat *.lexc | ./flag-diacritic-declaration-check.sh OPTIONS

# Output LEXC file to be examined as stdin to script.
# Options:
# m: output results from Multichar_Symbols
# l: output results from LEXICONs

gawk -v OPTIONS=$1 'BEGIN { mchars=0; opts=OPTIONS; }
{ 
  if(index($0,"Multichar_Symbols")!=0)
    mchars=1;
  while(match($0,"@[^@]*@",f)!=0 && mchars)
       {
         # gsub("\\.","\\.",f[0]);
         sub(f[0],"");
         flags[f[0]]++;
       }
  if(index($0,"LEXICON")!=0)
    mchars=0;
}
{ while(match($0,"@[^@]*@",f)!=0 && !mchars)
       {
         # gsub("\\.","\\.",f[0]);
         sub(f[0],"");
         flags2[f[0]]++;
       }
}
END { PROCINFO["sorted_in"]="@val_num_desc";
  if(index(opts,"m")!=0)
    {
      print "MULTICHAR_SYMBOLS - FLAG DECLARATIONS";
      for(flag in flags)
         printf "%i\t%s\n", flags[flag], flag;
      printf "\n";
    }
  if(index(opts,"l")!=0)
    {
      print "LEXICONS - FLAG REFERENCES";
      for(flag in flags2)
         printf "%i\t%s\n", flags2[flag], flag;
      printf "\n";
    }
  print "CHECK OF FLAGS IN LEXICONS DECLARED AS MULTICHAR_SYMBOLS";
  undecl=0;
  for(flag in flags2)
     if(!(flag in flags))
       {
         ++undecl;
         printf "UNDECLARED: %s\n", flag;
       }
     else
       if(index(opts,"d")!=0)
         printf "DECLARED: %s\n", flag;
  if(undecl==0)
    printf "NO UNDECLARED FLAGS.\n";
}'
