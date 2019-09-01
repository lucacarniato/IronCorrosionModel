PHREEQC iron corrosion model of the paper:

Velimirovic, M., Auffan, M., Carniato, L., Batka, V. M., Schmid, D., Wagner, S., ... & Hofmann, T. (2018). Effect of field site hydrogeochemical conditions on the corrosion of milled zerovalent iron particles and their dechlorination efficiency. Science of The Total Environment, 618, 1619-1627.

To reproduce the results run "OptimizeParameters.m" inside a matlab session. Otherwise you can use the script in octave. 
Octave installer can be dowloaded here: https://ftp.gnu.org/gnu/octave/windows/octave-4.2.1-w64-installer.exe. 

The PL variable is used to control the optimization (PL=0, optimiza, PL=1 plot the results).
Make sure the phreeqc.exe and the files sceua.m and cceua.m are inside the working directory. These are the files of the Shuffled Complex Evolution (SCE-UA) method.

https://www.mathworks.com/matlabcentral/fileexchange/7671-shuffled-complex-evolution-sce-ua-method

If you use this work please cite the paper above.