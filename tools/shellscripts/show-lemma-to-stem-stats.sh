!/bin/sh

# cat stems/verb_stems.lexc |

gawk 'BEGIN { FS="\n"; RS=""; }
$0 ~ /;/ && $0 ~ /:/ {
  n=gsub("Imperfective !","&");
  if(n!=0)
    ipfv="IPFV("n")";
  else
    ipfv="-------";
  n=gsub("Perfective !","&");
  if(n!=0)
    pfv="PFV("n")";
  else
    pfv="------";
  n=gsub("Progressive !","&");
  if(n!=0)
    prog="PROG("n")";
  else
    prog="-------";
  n=gsub("Optative !","&");
  if(n!=0)
    opt="OPT("n")";
  else
    opt="------";
  n=gsub("Potential !","&");
  if(n!=0)
    pot="POT("n")";
  else
    pot="------";
  n=gsub("Imperfective \\+ Repetitive","&");
  if(n!=0)
    ipfvrept="IPFV+REPT("n")";
  else
    ipfvrept="------------";
  n=gsub("Perfective \\+ Repetitive","&");
  if(n!=0)
    pfvrept="PFV+REPT("n")";
  else
    pfvrept="-----------";
  if(match($0,"\n([^:]+)",f)!=0)
    printf "%s %s %s %s %s %s %s\t%s\n", ipfv, ipfvrept, pfv, pfvrept, prog, opt, pot, f[1];
}' |

# Sorting based on lemma
    
sort -k 8 |

# Counting and outputting the number of various aspects with a stem
    
gawk '{ n=gsub("(^[-])|( [-])","&");
  printf "%i\t%s\n", 7-n, $0;
}'
