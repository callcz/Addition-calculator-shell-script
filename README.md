# Addition-calculator-shell-script

## This is an addition shell script, Calculate decimals using command 'expr'.

## Writen by callcz 20220801


Usage : ./addition.sh [OPTIONS] [FACTOR 0] [FACTOR 1] [FACTOR 2] ...

        example: `./addition.sh 1 0.2 -3` as '1+0.2+(-3)'.
        
options:

  -     Using shell pipes as input sources.
    
        example: `echo 1 0.2| ./addition.sh - -3` as '1 + 0.2 + (-3)'.
        
  --help,-h     List this help.


example:

$./addition.sh 1 2 3 4

10

$./addition.sh 0.01 0.2 3 40

43.21

$./addition.sh -100 2.3 4

-72.5

$echo 1 2 3 | ./addition.sh - -1 -2 -3

0
