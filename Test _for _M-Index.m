% Code that is used to test the application of M-index on simulated data sets
% which files to be imported
fname = [pname '\Perfect 2000.ctf'];
ebsd = EBSD.load(fname,CS,'interface','ctf',...
  'convertEuler2SpatialReferenceFrame');
%%
figure; plot(ebsd,ebsd.orientations)
%%
ebsd1 = ebsd
ori = (ebsd('Apatite').orientations);
odf = calcDensity(ori)
%figure;
%plotPDF(odf,Miller({0,0,0,1},ebsd('Apatite').orientations.CS),'contourf')
%%
%%Calcualtion of m-index %Taken from the mtex function which doesnt work? 

% Step 1 : Uniform misorientation angle distribution for Crystal symmetry (CS)
[density_uniform,~] = calcAngleDistribution(ebsd.CS,odf.SS);

% normalize the misorientation angle distribution
density_uniform = density_uniform/sum(density_uniform);

% Step 2 : calculate the uncorrelated MDF from ODF
uncorrelated_MDF = calcMDF(odf);

% Step 3 : uncorrelated misorientation angle distribution from MDF
[uncorrelated_density_MDF,~] = calcAngleDistribution(uncorrelated_MDF,'resolution',1*degree);

% normalize the misorientation angle distribution
uncorrelated_density_MDF = uncorrelated_density_MDF/sum(uncorrelated_density_MDF);

% Step 4 : calculate the M-index
MI = (sum((abs(density_uniform - uncorrelated_density_MDF))/2));

%% 
% pole figure intensi
plotPDF(odfimp,Miller({0,0,0,1},{1,1,-2,0},ebsd('Apatite').orientations.CS),'contourf')

