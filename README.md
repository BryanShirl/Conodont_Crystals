# Code and data associated with the article "Increasing control or biomineralization in conodont evolution"

## Authors

__Bryan Shirley__  
Utrecht University  
Formerly: Fachgruppe Paläoumwelt, Friedrich-Alexander-Universität Erlangen-Nürnberg   
email: b.o.shirley [at] uu.nl   
Web page: [www.uu.nl/staff/EBJarochowska](https://www.uu.nl/staff/BOShirley)   
ORCID: [0000-0002-8532-3890](https://orcid.org/0000-0002-8532-3890)   

__Isabella Leonhard__   
Department of Palaeontology, Universität Wien  
Formerly: Institute of Evolutionary Biology, Biological and Chemical Research Centre, Faculty of Biology, University of Warsaw  
email: isabella.leonhard [at] univie.ac.at  

__Duncan Murdock__  
Oxford University Museum of Natural History  

__John Repetski__  
US Geological Survey-Emeritus  

__Przemysław Świś__  
Institute of Evolutionary Biology, Biological and Chemical Research Centre, Faculty of Biology, University of Warsaw  

__Michel Bestmann__  
Department of Geology, Universität Wien  

__Pat Trimby__  
Oxford Instruments, High Wycombe, UK  

__Markus Ohl__  
Utrecht University    
email: m.ohl [at] uu.nl  

__Oliver Plümper__  
Utrecht University    
email: O.Plumper [at] uu.nl  

__Helen King__  
Utrecht University    
email: H.E.King [at] uu.nl  

__Emilia Jarochowska (maintainer)__    
Utrecht University  
Formerly: Fachgruppe Paläoumwelt, Friedrich-Alexander-Universität Erlangen-Nürnberg  
email: e.b.jarochowska [at] uu.nl    
Web page: [www.uu.nl/staff/EBJarochowska](https://www.uu.nl/staff/EBJarochowska)    
ORCID: [0000-0001-8937-9405](https://orcid.org/0000-0001-8937-9405)  

### Running instructions

#### EBSD datasets: Importing, postprocessing, plotting and calculations

Detailed instructions are in `Conodont_Mtex_scripts/INSTRUCTION.md`. In this step, datasets required for reproducing plots and tables used in the manuscript are produced. 
Datasets produced are also provided here as ready files, for users with no access to Matlab. Users without Matlab can reproduce the analysis of EBSD results by using R Studio:

#### Comparison of methods used to quantify crystallographic textures

In R Studio, run `Texture methods comparison/Testing_Quant_Methods_extended.Rmd`. It will download the data produced in Matlab, generate the plots and regression results presented in the manuscript. Run time on MacOS Sonoma 14.2.1 with 8 GB RAM: 9 s.

#### Analysis and plotting of Raman spectroscopy data

In R or R Studio, run `Raman.R`. It will download the data produced in Matlab, generate the plots and regression results presented in the manuscript. Run time on MacOS Sonoma 14.2.1 with 8 GB RAM: 8 s.

### Dependencies

For manipulating EBSD data:

* [MTEX](https://mtex-toolbox.github.io/) 5.9, which uses the [NFFT](https://www-user.tu-chemnitz.de/~potts/nfft/) library
* MATLAB; the code was written in version 2023a

For plotting and calculations on datasets output from Matlab:

* [R Software](https://www.r-project.org/); the code was written in version 4.3.0
* [R Studio](https://www.rstudio.com/categories/rstudio-ide/), we used 2023.12.0
* Packages:
  - ggplot2 3.4.2
  - ggpubr 0.6.0
  - lmodel2 1.7-3
  - utils 4.3.1
  - osfr 0.2.9
  - knitr 1.42

The code has been tested and ran on Windows 10 and MacOS Sonoma 14.2.1. The loading and installation time were below 2 min for Matlab and instantaneous for all 

*Credits:*

* R Core Team (2023). _R: A Language and Environment for Statistical Computing_. R Foundation for
  Statistical Computing, Vienna, Austria. <https://www.R-project.org/>.
* Kassambara A (2023). _ggpubr: 'ggplot2' Based Publication Ready Plots_. R package version 0.6.0,
  <https://CRAN.R-project.org/package=ggpubr>.
* Legendre P (2018). _lmodel2: Model II Regression_. R package version 1.7-3,
  <https://CRAN.R-project.org/package=lmodel2>.
* H. Wickham. ggplot2: Elegant Graphics for Data Analysis. Springer-Verlag New York, 2016.
* Wolen et al., (2020). osfr: An R Interface to the Open Science Framework. Journal of Open Source
  Software, 5(46), 2071, [https://doi.org/10.21105/joss.02071](https://doi.org/10.21105/joss.02071)

## Citation

Shirley, B., Leonhard, I., Murdock, D.J.E., Repetski, J.E., Świś, P., Bestmann, M., Trimby, P., Ohl, M., Plümper, O., King, H., and Jarochowska, E., 2023, Code for Increasing control over biomineralization in conodont evolution: https://github.com/BryanShirl/Conodont_Crystals. https://github.com/BryanShirl/Conodont_Crystals/

```
@code{shirley_code_2023,
	title = {Code for Increasing control over biomineralization in conodont evolution},
	url = {https://github.com/BryanShirl/Conodont_Crystals},
	author = {Shirley, Bryan and Leonhard, Isabella and Murdock, Duncan J. E. and Repetski, John E. and Świś, Przemysław and Bestmann, Michel and Trimby, Pat and Ohl, Markus and Plümper, Oliver and King, Helen and Jarochowska, E.},
	year = {2023},
}
```

## License

Code: Apache 2.0 License, see LICENSE file for license text.

Data: [Creative Commons CC BY-SA 4.0 Attribution-ShareAlike 4.0 International](https://creativecommons.org/licenses/by-sa/4.0/legalcode.en)

You are free to:

* Share — copy and redistribute the material in any medium or format for any purpose, even commercially.
* Adapt — remix, transform, and build upon the material for any purpose, even commercially.

Under the following terms:

*  Attribution - You must give appropriate credit , provide a link to the license, and indicate if changes were made . You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.
* ShareAlike - If you remix, transform, or build upon the material, you must distribute your contributions under the same license as the original. 

## Funding

* Deutsche Froschungsgemeinschaft grant to Emilia Jarochowska (project JA 2718/3-1)
* DAAD Scholarship to Bryan Shirley
* This publication results from work carried out under Trans-National Access action under the support of EXCITE - EC- HORIZON 2020 -INFRAIA 2020 Integrating Activities for Starting Communities under grant agreement N.101005611
  
