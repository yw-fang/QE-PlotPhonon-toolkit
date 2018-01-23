set term postscript enhanced color "TimesNewRoman" 18
set output 'LWN.444.Thz.ps'

set nokey
set noxtics
set ylabel "Frequency, Thz"
set title "Phonon calculations for LWN.444"
set xzeroaxis lw 3
set border 15 lw 3

set encoding iso_8859_1
 
THz= 33.3000
 
#E_min=    -0.6
E_min=    -5.0
E_max=    37.4
Label_position=    -1.1
 
set label  "{/Symbol G}"  at   -0.03 , Label_position
set label  "L"  at    0.47 , Label_position
set label  "B"  at    0.82 , Label_position
set label  "Z"  at    1.61 , Label_position
set label  "{/Symbol G}"  at    2.48 , Label_position
set label  "X"  at    3.01 , Label_position
 
set arrow nohead from   0.50000, E_min   to   0.50000, E_max  lw 3
set arrow nohead from   0.85355, E_min   to   0.85355, E_max  lw 3
set arrow nohead from   1.64412, E_min   to   1.64412, E_max  lw 3
set arrow nohead from   2.51015, E_min   to   2.51015, E_max  lw 3
 
plot [:] [E_min:E_max] 'Frequency' u 1:($2/THz) w lines lt 1 lw 3
 
