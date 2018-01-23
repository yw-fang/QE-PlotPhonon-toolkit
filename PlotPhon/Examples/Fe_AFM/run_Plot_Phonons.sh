#!/bin/bash
####################################################################
#
# set the needed environment variables
#
. ../environment_variables
#

# IFC name w/o extenstion
FC_name='Fe_AFM'

# Specify atomic masses in the same order as in ph.in file
cat > Atomic_mass <<EOF
    amass(1)=55.845,
    amass(2)=55.845
EOF

# Label for Y (Frequency) axis: THz, cm, or meV
freq=Thz

# Check whether IFC file exists
if [ ! -f $FC_name.fc  ]; then
   echo 'You have no IFC file' $FC_name.fc 'in this directory.'
   echo 'Please find it and copy to this directory'
   exit
fi
# 1. q-points are in units of 2*\pi/a
# 2. If you use cartesian for q-points then leave basis vectors unchanged
# 3. q-points for FCC and BCC lattices are well-known in Cartesian and 
#    there is no need to use basis vectors (so leave basis vectors unchanged)
# 4. Otherwise you should provide correct basis vectors and 
#    q-vectors wrt basis vectors (as "crystal" in scf-file)
# 
# Basis vectors and vortex coordianates are due to Bradley, Cracknell Textbook 
# Except Simple cubic, Face Centered Cubic, Body Centered Cubic which are Cartesian

cell=`head -1 $FC_name.fc | cut -c 9-11 `
echo $cell

if [ $cell == 0 ]; then

    if [ ! -f Generic]; then
    echo 'You should define basis vectors and high symmetry points manually'
    echo 'If you choose  coordinates of these points in Cartesian '
    echo 'then you can choose a diagonal unitary matrix'
    exit
    fi

    cp  $PLOT_DIR/Include/Generic K_points
    echo 'Manually given basis vectors and high symmetry k-points coordinates'

 elif [ $cell == 1 ]; then
    cp  $PLOT_DIR/Include/Cubic_SC K_points
    echo 'Simple cubic'

 elif [ $cell == 2 ]; then
    cp  $PLOT_DIR/Include/Cubic_FCC K_points
    echo 'Face Centered Cubic'

 elif [ $cell == 3 ]; then 
    cp  $PLOT_DIR/Include/Cubic_BCC K_points
    echo 'Body Centered Cubic'

 elif [ $cell == 4 ]; then 
    c2a=`head -1 $FC_name.fc | cut -c 34-44   `
    c2a1=`echo "scale=8; 1./$c2a" | bc -l `
    cp  $PLOT_DIR/Include/Hexagonal Kpts_tmp
    sed 's/XX/'$c2a1'/g' Kpts_tmp > ./K_points 
    mv Kpts_tmp
    echo 'Hexagonal or Trigonal P'

 elif [ $cell == 5 ]; then 

    echo 'Rhombohedrical, Trigonal R is not implemented yet'
    exit
    
 elif [ $cell == 6 ]; then 

    c2a=`head -1 $FC_name.fc | cut -c 34-44   `
    c2a1=`echo "scale=8; 1./$c2a" | bc -l `
    cp  $PLOT_DIR/Include/Tetragonal_Simple Kpts_tmp
    echo $c2a
    sed 's/XX/'$c2a1'/g' Kpts_tmp > ./K_points 
    mv Kpts_tmp
    echo 'Simple Tetragonal'

 elif [ $cell == 7 ]; then 

    echo 'Body Centered Tetragonal is not implemented yet'
    exit

 elif [ $cell == 8 ]; then

    b2a=`head -1 $FC_name.fc | cut -c 23-33 `
    c2a=`head -1 $FC_name.fc | cut -c 34-44 `
    b2a1=`echo "scale=8; 1./$b2a" | bc -l `
    c2a1=`echo "scale=8; 1./$c2a" | bc -l `

    cp  $PLOT_DIR/Include/Orthorhombic_Simple Kpts_tmp
    echo $b2a
    echo $c2a

    sed 's/XX/'$b2a1'/g' Kpts_tmp > ./Kpts_tmp1 
    sed 's/YY/'$c2a1'/g' Kpts_tmp1 > ./K_points 
    rm -f Kpts_tmp Kpts_tmp1

    echo 'Simple Orthorhombic'

 elif [ $cell == 9 ]; then
 
    echo 'Base  Centered Orthorhombic is not implemented yet'
    exit
    
 elif [ $cell == 10 ]; then

    echo 'Face Centered Orthorhombic is not implemented yet'
    exit 

 elif [ $cell == 11 ]; then

    echo 'Orthorhomic Body Centered is not implemented yet'
    exit
    
 elif [ $cell == 12 ]; then

 echo 'Monoclinic system is not implemented yet'
 exit

 elif [ $cell == 13 ]; then

 echo 'Monoclilic Base Centered  is not implemented yet'
 exit

 elif [ $cell == 14 ]; then

 echo 'Triclinic system is not implemented yet'
 exit

fi



####    You should not either edit or run this file ####################################
############## Below there is NOTHING to edit ##########################################
########################################################################################

case  $freq in
THz)  scale=33.3;;
Thz)  scale=33.3;;
thz)  scale=33.3;;
cm)   scale=1 ;;
Cm)   scale=1 ;;
CM)   scale=1 ;;
meV)  scale=8.0532;;
mev)  scale=8.0532;;
esac

cat > Freq_plot_unit <<EOF
$scale
EOF

$PLOT_DIR/bin/k_for_bands.x < K_points

cat > matdyn.in.tmp1 <<EOF
 &input
EOF
 
cat > matdyn.in.tmp2 <<EOF
    asr='crystal',
    flfrc='$FC_name.fc',
    flfrq='$FC_name.freq'
 &end
EOF

cat  matdyn.in.tmp1 Atomic_mass matdyn.in.tmp2  ph.grid >matdyn.in
rm -f matdyn.in.tmp1 matdyn.in.tmp2 Atomic_mass

echo ' Recalculating omega(q) from C(R) ... '
$BIN_DIR/matdyn.x < matdyn.in > matdyn.out
echo ' Well  done'

$PLOT_DIR/bin/bands_to_gnuplot.x <$FC_name.freq

cat > plot.GNU.begin << EOF
set term postscript enhanced color "TimesNewRoman" 18
set output '$FC_name.$freq.ps'

set nokey
set noxtics
set ylabel "Frequency, $freq"
set title "Phonon calculations for $FC_name"
set xzeroaxis lw 3
set border 15 lw 3

set encoding iso_8859_1
EOF

$PLOT_DIR/bin/E_min_max.x <$FC_name.freq 

cat plot.GNU.begin plot.GNU.tmp  > plot.$freq.GNU 
rm -f plot.GNU.begin plot.GNU.tmp 

gnuplot plot.$freq.GNU 
ps2pdf $FC_name.$freq.ps


echo '###############################################################################################'
echo '###############################################################################################'
echo ' '
echo 'You have got phonon dispersion relations plotted using  gnuplot (www.gnuplot.info) '
echo 'Now you can edit' plot.$freq.GNU 'in order to define E_min, E_max and Label_position '
echo 'more accurately to get publication-quality Postscript and PDF files. '
echo 'You can also redefine default parameters and add experimental data, too.'
echo ' '
echo '###############################################################################################'
echo '###############################################################################################'


