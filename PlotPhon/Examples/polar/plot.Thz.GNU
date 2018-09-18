set term postscript enhanced color "TimesNewRoman" 18
set output 'LWN.525.Thz.ps'

set nokey
set noxtics
set ylabel "Frequency, Thz"
set title "Phonon calculations for LWN.525"
set xzeroaxis lw 3
set border 15 lw 3

set encoding iso_8859_1
 
THz= 33.3000
 
E_min=    -0.6
E_max=    24.8
Label_position=    -1.1
 
set label  "{/Symbol G}"  at   -0.03 , Label_position
set label  "X"  at    0.47 , Label_position
set label  "S"  at    1.46 , Label_position
set label  "Y"  at    1.96 , Label_position
set label  "{/Symbol G}"  at    2.96 , Label_position
set label  "Z"  at    3.46 , Label_position
set label  "U"  at    3.96 , Label_position
set label  "R"  at    4.95 , Label_position
 
set arrow nohead from   0.50000, E_min   to   0.50000, E_max  lw 3
set arrow nohead from   1.49418, E_min   to   1.49418, E_max  lw 3
set arrow nohead from   1.99418, E_min   to   1.99418, E_max  lw 3
set arrow nohead from   2.98836, E_min   to   2.98836, E_max  lw 3
set arrow nohead from   3.48652, E_min   to   3.48652, E_max  lw 3
set arrow nohead from   3.98652, E_min   to   3.98652, E_max  lw 3
 
plot [:] [E_min:E_max] 'Frequency' u 1:($2/THz) w lines lt 1 lw 3
 
