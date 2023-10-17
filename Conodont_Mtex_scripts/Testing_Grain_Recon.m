% Code associated with the publication "Increasing control over biomineralization in conodont evolution"
% Tested and running in Mtex v5.7.0 MATLAB R2021b
%% Clean up workspace %%
clear
close all
home
%% Specify Directories and download sample data from OSF %%
%Finds the current work path where .m is stored
CurPath = matlab.desktop.editor.getActiveFilename; 
fprintf('%s\n',CurPath);
% URL of the file to be downloaded 
url = 'https://osf.io/download/5sw9z/'; 
% Specify the local path where you want to save the downloaded file 
WD = fileparts(CurPath);
filename = 'GrainTestData.ctf';
SavePath = fullfile(WD, filename);
% Use websave to download the file 
websave(SavePath,url);
fname = [WD '\GrainTestData.ctf'];

%% Import the EBSD data %%
CS = {... 
  'notIndexed',...
  crystalSymmetry('6/m', [9.4 9.4 6.9], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'Apatite', 'color', [0.53 0.81 0.98])};

% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','intoPlane');

% create an EBSD variable containing the data
ebsd = EBSD.load(fname,CS,'interface','ctf',...
  'convertEuler2SpatialReferenceFrame');

%% Running grain reconstruction for different misorientaions %%
n=20
ebsd1 = ebsd
reconstructed = struct() %Empty struct for EBSD data
reconGrains = struct() %Empty struct for Grain data
%Loop to run grain reconstruction for each degree from 1-20 and save to
%struct for plotting
for r = 1:n
ebsd = ebsd1
[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd, 'angle', r*degree, "boundary", "tight");
ebsd(grains(grains.grainSize <2)) = []
[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd, 'angle', r*degree, "boundary", "tight");
reconstructed(r).ebsd = ebsd
reconGrains(r).grains = grains
end



%% Plotting the results %%
% The following code contains three loops that plot the EBSD data in
% various ways
% Loop one is for band contrast vs grain bounderies
% Loop two plots EBSD orientations vs grain bounderies 
% Loop three plots EBSD orientations with filled grains.

close all
mtexFig = newMtexFigure('layout',[1,5]);

for r = 1:4:20
ebsd = reconstructed(r).ebsd
grains = reconGrains(r).grains
plot(ebsd,ebsd.bc)
colormap gray
title (sprintf('%d°',r),'FontSize', 10)
hold on
plot(grains.boundary,'linewidth',0.4)
hold off
nextAxis
end

for r = 1:4:20
ebsd = reconstructed(r).ebsd
grains = reconGrains(r).grains
plot(ebsd,ebsd.orientations)
colormap gray
title (sprintf('%d°',r),'FontSize', 10)
hold on
plot(grains.boundary,'linewidth',0.4)
hold off
nextAxis
end

for r = 1:4:20
ebsd = reconstructed(r).ebsd
grains = reconGrains(r).grains
ebsdSub_filled = fill(ebsd, grains);
plot(ebsdSub_filled,ebsdSub_filled.orientations);
title (sprintf('%d°',r),'FontSize', 10)
hold on
plot(grains.boundary,'linewidth',0.4)
hold off
nextAxis
end
