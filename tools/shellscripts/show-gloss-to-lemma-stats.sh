!/bin/sh

# cat stems/verb_stems.lexc |

egrep -v '^!' |

gawk '{ if(match($0,"^(.+)(\\[[^\\]]+\\])",f)!=0)
          { lemmas[f[2]][f[1]]++;
            if(length(f[2])>maxglosslen)
              maxglosslen=length(f[2]);
          }
}
END { for(i in lemmas)
         {
           n=0;
           for(j in lemmas[i])
              n++;
           printf "(%i) %-"maxglosslen"s:", n, i;
           for(j in lemmas[i])
              printf " %s (%i)", j, lemmas[i][j];
           printf "\n";
         }
}' |

sort -k 2
