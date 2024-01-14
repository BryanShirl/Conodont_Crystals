# Introduction
This instruction will guide you through the process of how the data for "Increasing control over biomineralization in conodont evolution" was processed and aquired.
 Tested and running in Mtex v5.7.0 MATLAB R2021b
 
## Table of Contents  

[Prerequisites](#prerequisites) 
[Usage](#usage)

### Prerequisites 

This code is run in Matlab (R2022b) using the MTEX tool box. Further information on the installation of MTEX can be found at https://mtex-toolbox.github.io/.

### Usage

#### Step 1 - Post processing

Open and run `Step_1_EBSD_Post_Processing.m`

This code is used to post-process EBSD data for further analysis. This downloads the raw EBSD data from an online repository (OSF) as well as predefined polygons.
This raw data is then rotated and cropped into a format that can be used later in the workflow (Step 2) and represents comparable data sets. Within a step by step guide is provided for each of these, and  data such as pole figures/inverse pole figures are also plotted.

#### Step 2 
Open and run `Step_2_Texture_Quant.m`

This code is dependent on the function `TexCalc.m`. This function calculates the T-index, M-Index and IPFT-index from an EBSD dataset. The function takes a user defined EBSD data set, and creates a series of subsets with a random location. The subsets are quare-shaped and the size is varied within a range provided by the user.

##### Function usage

```
Tindex = TexCalc(ebsd, boxmin, boxmax, runs)
```

`ebsd` is the desired EBSD dataset as a Matlab object
`boxmin` is the minimum size for generated square
`boxmin` is the maximum size for generated square
`runs` is the number of runs to be conducted

Output is a table containing the T-index, M-Index and IPFT-index for each run.
