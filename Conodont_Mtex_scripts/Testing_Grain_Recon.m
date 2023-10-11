clear
close all
home
%%
CS = {... 
  'notIndexed',...
  crystalSymmetry('6/m', [9.4 9.4 6.9], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'Apatite', 'color', [0.53 0.81 0.98])};

% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','intoPlane');

%% Specify File Names

% path to files
pname = 'C:\Users\Shirl001\Documents\GitHub\Conodont_Crystals\EBSD data (ctf)';

% which files to be imported
fname = [pname '\GrainTestData.ctf'];

%% Import the Data

% create an EBSD variable containing the data
ebsd = EBSD.load(fname,CS,'interface','ctf',...
  'convertEuler2SpatialReferenceFrame');


%%
 
n=16
ebsd1 = ebsd

%%
reconstructed = struct()

for r = 1:n
ebsd = ebsd1
[reconstructed(r).grains,reconstructed(r).ebsd.grainId,reconstructed(r).ebsd.mis2mean] = calcGrains(ebsd, 'angle', r*degree, "boundary", "tight");
reconstructed(r).grains(reconstructed(r).grains.grainSize <5) = []
[reconstructed(r).grains,reconstructed(r).ebsd.grainId,reconstructed(r).ebsd.mis2mean] = calcGrains(ebsd, 'angle', r*degree, "boundary", "tight");
end
 

%%
close all

mtexFig = newMtexFigure('layout',[3,4]);

for r = 4:4:16
plot(ebsd,ebsd.bc)
colormap gray
title (sprintf('%d°',r),'FontSize', 10)
hold on
plot(reconstructed(r).grains.boundary,'linewidth',0.8)
hold off
nextAxis
end

for r = 4:4:16
plot(ebsd,ebsd.orientations)
colormap gray
title (sprintf('%d°',r),'FontSize', 10)
hold on
plot(reconstructed(r).grains.boundary,'linewidth',0.8)
hold off
nextAxis
end

for r = 4:4:16
ebsdSub_filled = fill(reconstructed(r).ebsd, reconstructed(r).grains);
plot(ebsdSub_filled,ebsdSub_filled.orientations);
title (sprintf('%d°',r),'FontSize', 10)
hold on
plot(reconstructed(r).grains.boundary,'linewidth',0.8)
hold off
nextAxis
end