!/bin/sh

# show-gloss-to-lemma-stats.sh

# Prints:
# 1) glosses in square brackets [...] in LEXC code,
# 2) the number of lemmas,
# 3) the associated lemmas, and
# 4) the stems linked to a lemmas, and
# 5) the number of alternative stems linked to a lemma
# 6) the stems and associated aspects, if argument 'stems' given

# Usage:
#    cat stems/verb_stems.lexc | show-gloss-to-lemma-stats.sh | less
#    OR
#    cat stems/verb_stems.lexc | show-gloss-to-lemma-stats.sh 'stems' | less

egrep -v '^!' |

gawk -v STEMS=$1 'BEGIN { if(STEMS=="stems") print_stems=1; } 
{ if(match($0,"^(.+)\\[([^\\]]+)\\]:([^ \t]+)[ \t][^ ]+[-]([^ ]+)",f)!=0)
    { lemmas[f[2]][f[1]]++;
      stems[f[2]][f[1]]=stems[f[2]][f[1]] " - " f[4] ": " f[3];
      if(length(f[2])>maxglosslen)
        maxglosslen=length(f[2]);
    }
}
END { for(i in lemmas)
         {
           n=0;
           for(j in lemmas[i])
              n++;
           printf "%-"maxglosslen"s [L: %i] :", i, n;
           for(j in lemmas[i])
              {
                printf " %s (S: %i", j, lemmas[i][j];
                if(print_stems)
                  printf "%s", stems[i][j];
                printf ")";
              }           
           printf "\n";
         }
}' |

sort -k 1
