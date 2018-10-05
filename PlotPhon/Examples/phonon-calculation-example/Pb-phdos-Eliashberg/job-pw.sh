#!/bin/bash


#SBATCH --job-name="Fang"  
#SBATCH --output="%j.%N.out"  
#SBATCH --partition=shared  
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=20  
#SBATCH --export=ALL  
#SBATCH -t 02:00:00  

### Set up Intel MPI environment
export MODULEPATH=/share/apps/compute/modulefiles:$MODULEPATH
module purge
module load gnutools
module load intel/2015.6.233 
module load intelmpi/2015.6.233

touch RUNNING
#ROOT=/share/apps/compute/qe/v5.3.0impi2015/
ROOT=/share/apps/compute/qe/v6.3impi2018/bin/
#ROOT=/home/ywfang/software/qe-6.2.1/bin/
PWEXE=$ROOT/pw.x
PWDATA=$ROOT/bands.x
PLOT=$ROOT/plotband.x
PHEXE=$ROOT/ph.x
PHEXE1=$ROOT/q2r.x
PHEXE2=$ROOT/matdyn.x
LAMBDAEXE=$ROOT/lambda.x
PPEXE=$ROOT/pp.x
AVGEXE=$ROOT/average.x
DOS=$ROOT/dos.x

CASE=pb
#mpirun $PWEXE <  $CASE-relax.in > $CASE-relax.out
######phonon calculations#############
#mpirun $PWEXE <  $CASE-scf.in > $CASE-scf.out
#mpirun $PHEXE <  $CASE-phonon0-gamma.in > $CASE-phonon0-gamma.out
#mpirun $PWEXE <  $CASE-q2r.in > $CASE-q2r.out
#mpirun $PWEXE <  $CASE-matdyn.in > $CASE-matdyn.out
#mpirun $PWEXE <  $CASE-plotband.in > $CASE-plotband.out

########e-p calculations########
#mpirun $PWEXE <  $CASE-scf.fit.in > $CASE-scf.fit.out
#mpirun $PWEXE <  $CASE-scf.in > $CASE-scf.out
#mpirun $PHEXE < $CASE-elph.in > $CASE-elph.out
#mpirun $PHEXE1 < $CASE-q2r.in > $CASE-q2r.out
#mpirun $PHEXE2 < $CASE-matdyn.in.freq > $CASE-matdyn.out.freq
#mpirun $PHEXE2 < $CASE-matdyn.in.dos > $CASE-matdyn.out.dos
mpirun $LAMBDAEXE < $CASE-lambda.in > $CASE-lambda.out

#ibrun -v /home/hchen/codes-Comet/vasp/vasp.5.4.1/bin/vasp_ncl

touch done

\rm RUNNING
