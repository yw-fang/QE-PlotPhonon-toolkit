#!/bin/bash
#PBS -N BTO
#PBS -l nodes=1:ppn=20
#PBS -l walltime=80:00:00
#PBS -S /bin/bash
#PBS -j oe
#PBS -q small 

# This job's working directory
cd $PBS_O_WORKDIR    

# Define number of processors
NPROCS=`wc -l < $PBS_NODEFILE`

echo This job has allocated $NPROCS nodes

#VASPEXE=/home/cgduan/VASP/bin/vasp.4.6
#VASPEXE=/home/cgduan/VASP/bin/vasp.5.3.2
#DEFINE EXE NAME
ROOT=/home/cgduan/fyw/software/espresso-5.4.0/bin
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
FSEXE=$ROOT/fs.x

MPIPREFIX="/home/software/intel/impi/4.1.0.024/intel64/bin/mpirun"

#/home/software/mpi/openmpi-1.6-intel/bin/mpirun  --mca btl openib,self,sm --bind-to-core -np $NPROCS -hostfile $PBS_NODEFILE  $VASPEXE
#/home/software/intel/impi/4.1.0.024/intel64/bin/mpirun   -np $NPROCS -hostfile $PBS_NODEFILE  $VASPEXE  #Fang

CASE=alas

##################general part: relax, scf, nscf, band##########################
#$MPIPREFIX  -np $NPROCS -hostfile $PBS_NODEFILE   $PWEXE < $CASE-relax.in   $POOL  > $CASE-relax.out
#$MPIPREFIX  -np $NPROCS -hostfile $PBS_NODEFILE   $PWEXE < $CASE-scf.in   $POOL  > $CASE-scf.out
#$MPIPREFIX  -np $NPROCS -hostfile $PBS_NODEFILE   $PWEXE < $CASE-nscf.in   $POOL  > $CASE-nscf.out
#$MPIPREFIX  -np $NPROCS -hostfile $PBS_NODEFILE   $PWEXE < $CASE-band.in   $POOL  > $CASE-band.out
# $PWDATA < bands.in     > bands.out
# $PLOT < plotbands.in     > plotbands.out


################phonon band, phonon DOS, serial######################################
#$MPIPREFIX  -np $NPROCS -hostfile $PBS_NODEFILE   $PWEXE < $CASE-scf.in   $POOL  > $CASE-scf.out
#$MPIPREFIX  -np $NPROCS -hostfile $PBS_NODEFILE   $PHEXE < $CASE-phonon.in   $POOL  > $CASE-phonon.out
#$MPIPREFIX  -np $NPROCS -hostfile $PBS_NODEFILE    $PHEXE1 < $CASE-q2r.in        > $CASE-q2r.out
$MPIPREFIX  -np $NPROCS -hostfile $PBS_NODEFILE    $PHEXE2 < $CASE-matdyn.in     > $CASE-matdyn.out
#$MPIPREFIX  -np $NPROCS -hostfile $PBS_NODEFILE    $PLOT < $CASE-plotband.in     > $CASE-plotband.out
###after running plotband.x, we can use gnuplot to plot the data in freq.plot, that's band
#$MPIPREFIX  -np $NPROCS -hostfile $PBS_NODEFILE    $PHEXE2 < $CASE-phdos.in     > $CASE-phdos.out
###after running plotband.x, we can use gnuplot to plot the data in freq.plot, that's band

################phonon band, phonon DOS, split q-vectors and irrep#####################
#$MPIPREFIX  -np $NPROCS -hostfile $PBS_NODEFILE   $PWEXE < $CASE-scf.in   $POOL  > $CASE-scf.out
#$MPIPREFIX  -np $NPROCS -hostfile $PBS_NODEFILE   $PHEXE < $CASE-phonon0.in   $POOL  > $CASE-phonon0.out
###generate input files for ph.x using split_q_irr-fyw and submit jobs one by one
#for q in `seq 1 8 ` ; do
#for irr in `seq 1 6` ; do
#$MPIPREFIX  -np $NPROCS -hostfile $PBS_NODEFILE   $PHEXE <input.$q.$irr  $POOL > input.$q.$irr.out
#done
#done
###collect all the results in a single directory using collect_q_irr-fyw and then run ph.x to recover all dyn
#$MPIPREFIX  -np $NPROCS -hostfile $PBS_NODEFILE   $PHEXE < $CASE-phonon.in   $POOL  > $CASE-phonon.out
#$MPIPREFIX  -np $NPROCS -hostfile $PBS_NODEFILE    $PHEXE1 < $CASE-q2r.in        > $CASE-q2r.out
#$MPIPREFIX  -np $NPROCS -hostfile $PBS_NODEFILE    $PHEXE2 < $CASE-matdyn.in     > $CASE-matdyn.out
#$MPIPREFIX  -np $NPROCS -hostfile $PBS_NODEFILE    $PLOT < $CASE-plotband.in     > $CASE-plotband.out
###after running plotband.x, we can use gnuplot to plot the data in freq.plot, that's band
#$MPIPREFIX  -np $NPROCS -hostfile $PBS_NODEFILE    $PHEXE2 < $CASE-phdos.in     > $CASE-phdos.out
###after running plotband.x, we can use gnuplot to plot the data in freq.plot, that's band

################phonon band, phonon DOS, split q-vectors: can be used in different machines ####################
#$MPIPREFIX  -np $NPROCS -hostfile $PBS_NODEFILE   $PWEXE < $CASE-scf.in   $POOL  > $CASE-scf.out
#$MPIPREFIX  -np $NPROCS -hostfile $PBS_NODEFILE   $PHEXE < $CASE-phonon0.in   $POOL  > $CASE-phonon0.out
###generate input files for ph.x using split_q_irr-fyw and submit jobs one by one
#for q in `seq 9 10 ` ; do
#$MPIPREFIX  -np $NPROCS -hostfile $PBS_NODEFILE   $PHEXE <input.$q $POOL > input.$q.out
#done
#$MPIPREFIX  -np $NPROCS -hostfile $PBS_NODEFILE   $PHEXE <input.4 $POOL > input.4.out
#if dyn are generated in different machines, we need mv them into a single directory
#$MPIPREFIX  -np $NPROCS -hostfile $PBS_NODEFILE    $PHEXE1 < $CASE-q2r.in        > $CASE-q2r.out
#$MPIPREFIX  -np $NPROCS -hostfile $PBS_NODEFILE    $PHEXE2 < $CASE-matdyn.in     > $CASE-matdyn.out
#$MPIPREFIX  -np $NPROCS -hostfile $PBS_NODEFILE    $PLOT < $CASE-plotband.in     > $CASE-plotband.out
###after running plotband.x, we can use gnuplot to plot the data in freq.plot, that's band
#$MPIPREFIX  -np $NPROCS -hostfile $PBS_NODEFILE    $PHEXE2 < $CASE-phdos.in     > $CASE-phdos.out
###after running plotband.x, we can use gnuplot to plot the data in freq.plot, that's band
#  $PLOT < $CASEplotphonon.in     > $CASEplotphonon.out

#$MPIPREFIX  -np $NPROCS -hostfile $PBS_NODEFILE   $PHEXE < $CASEphonon.1.in   $POOL  > $CASEphonon.1.out
#$MPIPREFIX  -np $NPROCS -hostfile $PBS_NODEFILE   $PHEXE < $CASEphonon.2.in   $POOL  > $CASEphonon.2.out
#$MPIPREFIX  -np $NPROCS -hostfile $PBS_NODEFILE   $PPEXE < $CASE-pp.in   $POOL  > $CASE-pp.out
# $AVGEXE < $CASE-avg.#in     > $CASE-avg.out
#$DOS < $CASE-dos.in     > $CASE-dos.out
#
#
##################################lamda calculation##########
#$MPIPREFIX  -np $NPROCS -hostfile $PBS_NODEFILE   $PWEXE < $CASE-relax.in   $POOL  > $CASE-relax.out
#$MPIPREFIX  -np $NPROCS -hostfile $PBS_NODEFILE   $PWEXE < $CASE-scf.fit.in   $POOL  > $CASE-scf.fit.out
#$MPIPREFIX  -np $NPROCS -hostfile $PBS_NODEFILE   $PWEXE < $CASE-scf.in   $POOL  > $CASE-scf.out
#$MPIPREFIX  -np $NPROCS -hostfile $PBS_NODEFILE   $PWEXE < $CASE-nscf-fs.in   $POOL  > $CASE-nscf-fs.out
#$MPIPREFIX  -np $NPROCS -hostfile $PBS_NODEFILE   $FSEXE < $CASE-FS.in   $POOL  > $CASE-FS.out
#$MPIPREFIX  -np $NPROCS -hostfile $PBS_NODEFILE   $PHEXE < $CASE-elph.in   $POOL  > $CASE-elph.out
#$MPIPREFIX  -np $NPROCS -hostfile $PBS_NODEFILE   $PHEXE1 < $CASE-q2r.in   $POOL  > $CASE-q2r.out
#$MPIPREFIX  -np $NPROCS -hostfile $PBS_NODEFILE   $PHEXE2 < $CASE-matdyn.in.freq   $POOL  > $CASE-matdyn.in.freq.out
#$MPIPREFIX  -np $NPROCS -hostfile $PBS_NODEFILE   $PHEXE2 < $CASE-matdyn.in.dos   $POOL  > $CASE-matdyn.in.dos.out
#$MPIPREFIX  -np $NPROCS -hostfile $PBS_NODEFILE   $LAMBDAEXE < $CASE-lambda.in   $POOL  > $CASE-lambda.out
#
#
exit 0
