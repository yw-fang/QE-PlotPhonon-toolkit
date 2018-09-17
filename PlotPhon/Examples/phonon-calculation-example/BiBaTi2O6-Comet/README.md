Note: Pmm2.dyn files and matdyn.modes file are compressed.

The computations were carried out in Comet of XSEDE.

# The steps of calculations:

- relax: mpirun $PWEXE <  $CASE-relax.in > $CASE-relax.out

- scf calculations: mpirun $PWEXE <  $CASE-scf.in > $CASE-scf.out

- get dyn files (we can calculate in parallel of q):  mpirun $PHEXE <  $CASE-phonon0-gamma.in > $CASE-phonon0-gamma.out

- get fc file: mpirun $PHEXE1 <  $CASE-q2r.in > $CASE-q2r.out

## The following three command can be run in bash lines

mpirun $PHEXE2 < $CASE-matdyn.in.freq   > $CASE-matdyn.in.freq.out
The qpoints in Pmm2-matdyn.in.freq
is same to those in my VASP-phonopy calculations of
Pmm2 BiBaTi2O6. We can use 'grep q-point' from the band.yaml to get these q-points.

Note: PHEXE1 PHEXE2 PWEXE are defined in the job-pw.sh


# About plot phonon dispersions

plotband.x built in Quatnum Espresso can help plot phonon dispers, you can also use pwtools (see ./pwtools-plot)

For me, I use another way combine the tools in '
QE-PlotPhonon-toolkit'. Details can be found in
QE-PlotPhonon-toolkit/PlotPhon/Examples/polar.
