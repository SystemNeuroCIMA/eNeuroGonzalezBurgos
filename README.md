# Parametrization of Power Spectrum
This code decomposes a Power Spectrum signal into its periodic and aperiodic components. <br>
<br>
This code has an associated article (Gonzalez-Burgos et al. 2023). It generates Figure 1 D-H  <br><br>
![Captura de Pantalla 2023-02-07 a las 9 02 23](https://user-images.githubusercontent.com/114731759/217186435-c6781484-4137-4d22-a02a-663a9083a568.png)
<br>
It also generates figure 5C <br>
![image](https://user-images.githubusercontent.com/114731759/217198161-071aa53f-1c4c-42f2-aa2a-98c67e6558a0.png)

# Information
The script 'gonzalez_burgos_PSD_processing.m' loads the 'example_PSD.csv' and calls function 'fit_psd.m' to extract the periodic and aperiodic components.
<br>
The script 'gonzalez_burgos_gaussian_fit.m' loads the 'example_gaussian.csv' and fits a kernel-density estimator (KDE) to the frequency distribution of gaussians to determine the limits of the frequency bands. 
<br>
# Citation
To use this software, please cite: 
