#!/usr/bin/python

"""
Calculate phonon dispersion with QE's matdyn and plot: example from wz-AlN.

Define special points path in the BZ, construct fine k-path for dispersion,
write matdyn.x input file, call matdyn.x to calculate the dispersion using
the 'q2r.fc' force constants in this dir, load and plot dispersion. Python
rocks!

Note that for this script to work, we need a working QE install (matdyn.x)
and these files:
    q2r.fc
        force constant file from phonon calculation
    pw.out
        SCF output to read atom types and cell to calculate rcell_reduced
"""

import numpy as np
from pwtools import kpath, common, pwscf, io, crys, mpl

sp_symbols = ['L$_1$','X','$\Gamma$', 'L', 'B$_1$', 'P$_2$', 'F', 'Q', 'B', 'P$_1$', 'Z', 'P']
# fractional k-space coords for special points
sp_points_frac = np.array([\
    [0,0,-0.5],
    [0.36959443,0,-0.36959443],
    [0,0,0],
    [0.5,0,0],
    [0.5000,0.23918886,-0.23918886],
    [0.36959443, 0.36959443, -0.23918886],
    [0.5, 0.5, 0. ],
    [0.63040557, 0.36959443, 0.        ],
    [0.76081114, 0.5,  0.23918886],
    [0.63040557, 0.63040557, 0.23918886],
    [0.5, 0.5, 0.5],
    [0.76081114, 0.36959443, 0.36959443],
    ])

# recip. cell in 2*pi/alat units, need this to make QE happy, q-points in
# matdyn.in and matdyn.freq output file are cartesian in 2*pi/alat
st = io.read_pw_scf('pw.out')
rcell_reduced = crys.recip_cell(st.cell) / 2.0 / np.pi * st.cryst_const[0]
sp_points = np.dot(sp_points_frac, rcell_reduced)

# fine path: use N=500 for nice LO-TO split jumps [see below for more comments
# on that]
ks_path = kpath.kpath(sp_points, N=100)

# call matdyn.x
templ_txt = """
&input
    asr='crystal',
XXXMASS
    flfrc='q2r.fc',
    flfrq='XXXFNFREQ'
/
XXXNKS
XXXKS
"""
matdyn_in_fn = 'matdyn.disp.in'
matdyn_freq_fn = 'matdyn.freq.disp'
mass_str = '\n'.join("amass(%i)=%e" %(ii+1,m) for ii,m in \
                      enumerate(st.mass_unique))
rules = {'XXXNKS': ks_path.shape[0],
         'XXXKS': common.str_arr(ks_path),
         'XXXMASS': mass_str,
         'XXXFNFREQ': matdyn_freq_fn,
         }
txt = common.template_replace(templ_txt,
                              rules,
                              conv=True,
                              mode='txt')
common.file_write(matdyn_in_fn, txt)
redo_matdyn = input('redo the matdyn.x calculation? Y/N')
if redo_matdyn=="Y":
    common.system("gunzip q2r.fc.gz; /gpfsnyu/home/yf1159/qe-6.5/bin/matdyn.x < %s; gzip q2r.fc" %matdyn_in_fn)
else:
    pass

# parse matdyn output and plot

# define special points path, used in plot_dis() to plot lines at special
# points and make x-labels
sp = kpath.SpecialPointsPath(ks=sp_points, ks_frac=sp_points_frac,
                             symbols=sp_symbols)

# QE 4.x, 5.x
# ks is the coordinates of kpoints and the freqs is the frequencies for each band
ks, freqs = pwscf.read_matdyn_freq(matdyn_freq_fn)
print(type(sp))
print(dir(sp))
print(sp.path_norm)
ylim=(-10,1000)

#print(dir(sp_points))
fig,ax,t = kpath.plot_dis(kpath.get_path_norm(ks_path), freqs, sp, marker='', ls='-', color='blue', ylim=ylim) #t after 'ax,' was added by ywfang
nrm = sp.path_norm
print('nrm is', nrm)
print(type(nrm))
ax.vlines(nrm, ylim[0], ylim[1], color='k',linestyle='--')
ax.hlines(y=0, xmin=nrm[0], xmax=nrm[-1], color='red')
ax.set_ylim(list(ylim))
# QE 5.x
##d = np.loadtxt(matdyn_freq_fn + '.gp')
##fig,ax = kpath.plot_dis(d[:,0], d[:,1:], sp, marker='', ls='-', color='k')

# if needed
#ax.set_ylim(...)
#ax.set_ylim([0,1000])
ax.set_ylabel("Frequency (cm$^{-1}$)")
#ax.vlines(nrm, 0, 1000)

##yue-wen fang
#mpl.plt.show()
from matplotlib.backends.backend_pdf import PdfPages
pp1 = PdfPages('phbands.pdf')
pp1.savefig(fig)
pp1.close()


# Band jumps at Gamma
# -------------------
# Either use many points in kpath() or split sp_points in two sets: sp_points_1
# = something--Gamma and sp_points_2=Gamma--something_else. Do the whole
# call-matdyn-and-parse stuff twice. Parse matdyn.freq.disp for both sets and
# plot both dispersions (for sp_points_1 and sp_points_2) into one plot.
