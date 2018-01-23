set term postscript enhanced color "TimesNewRoman" 18
set output 'BTO.Thz.ps'

set nokey
set noxtics
set ylabel "Frequency, Thz"
set title "Phonon calculations for BTO"
set xzeroaxis lw 3
set border 15 lw 3

set encoding iso_8859_1
 
THz= 33.3000
 
E_min=    -6.8
E_max=    25.9
Label_position=    -7.3
 
set label  "{/Symbol G}"  at   -0.03 , Label_position
set label  "S"  at    0.97 , Label_position
set label  "{/Symbol G}"  at    1.48 , Label_position
set label  "Z"  at    1.78 , Label_position
 
set arrow nohead from   1.00000, E_min   to   1.00000, E_max  lw 3
set arrow nohead from   1.51382, E_min   to   1.51382, E_max  lw 3
 
plot [:] [E_min:E_max] 'Frequency' u 1:($2/THz) w lines lt 1 lw 3
 
