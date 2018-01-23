set term postscript enhanced color "TimesNewRoman" 18
set output 'Fe_AFM.Thz.ps'

set nokey
set noxtics
set ylabel "Frequency, Thz"
set title "Phonon calculations for Fe_AFM"
set xzeroaxis lw 3
set border 15 lw 3

set encoding iso_8859_1
 
THz= 33.3000
 
E_min=     0.0
E_max=    10.2
Label_position=    -0.5
 
set label  "Z"  at   -0.03 , Label_position
set label  "{/Symbol G}"  at    0.29 , Label_position
set label  "X"  at    0.79 , Label_position
set label  "M"  at    1.29 , Label_position
set label  "{/Symbol G}"  at    2.00 , Label_position
set label  "A"  at    2.78 , Label_position
 
set arrow nohead from   0.32379, E_min   to   0.32379, E_max  lw 3
set arrow nohead from   0.82379, E_min   to   0.82379, E_max  lw 3
set arrow nohead from   1.32379, E_min   to   1.32379, E_max  lw 3
set arrow nohead from   2.03090, E_min   to   2.03090, E_max  lw 3
 
plot [:] [E_min:E_max] 'Frequency' u 1:($2/THz) w lines lt 1 lw 3
 
