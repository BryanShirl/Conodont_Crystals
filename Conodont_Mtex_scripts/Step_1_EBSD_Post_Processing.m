%% *Post processing of EBSD data from Conodonts*
%% *0.1 Intoduction*
% This code is used to post-process EBSD data for further analysis. Most of 
% the raw data needs to be rotated and cropped into a format that can be used 
% later in the workflow and represents comparable data sets. Here will provide 
% a step by step guide for each of these, and also plot the data such as pole 
% figures/inverse pole figures to help visualize the data.
% 
% 
% First step is to clear up the workspace.
close all;
clear all;
%%
CurPath = matlab.desktop.editor.getActiveFilename;
fprintf('%s\n',CurPath);
%% Now download the data from OSF
% URL of the file to be downloaded 
url = 'https://files.de-1.osf.io/v1/resources/m26qa/providers/osfstorage/652d32c72827450630b86723/?zip='; 
% Specify the local path where you want to save the downloaded file 
WD = fileparts(CurPath)
filename = 'EBSD_data.zip';
ZipPath = fullfile(WD, filename);
% Use websave to download the file 
websave(ZipPath,url); 
unzip('EBSD_data.zip',WD)

%%
%Setting up specific plotting aestetics for consistent plotting later in the code.
setMTEXpref('defaultColorMap',WhiteJetColorMap)
% set pole figure annotation
pfAnnotations = @(varargin) text([vector3d.X,vector3d.Y],{'  X','  Y'},...
  'BackgroundColor','w','tag','axesLabels',varargin{:});
% following line to disable the annotations
pfAnnotations = @(varargin) [];
setMTEXpref('pfAnnotations',pfAnnotations); 
pname = WD;
% Loading polygons representing areas covered in the manuscript 
load('Trip_Poly.mat');
load('Trip_ebsd.mat');
load('Pan_Poly.mat');
load('Pal_Poly.mat');
load('Pro_Poly.mat');
load('Bispa_poly.mat')

% 1.0 Rotation Crop and Plotting of _Proconodontus muelleri_  (Overview of process)
% First step is to import the specific data that we wish to look at.

%%
%%%%%%%% Proconodontus muelleri %%%%%%%%%%
CS = {... 
  'notIndexed',...
  crystalSymmetry('6/m', [9.4 9.4 6.9], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'Apatite', 'color', [0.53 0.81 0.98]),...
  crystalSymmetry('6/m', [9.4 9.4 6.9], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'Hydroxylapatite', 'color', [0.56 0.74 0.56])};

% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','intoPlane');

fname = [pname '\Pro. mulleri.crc'];

ebsd = EBSD.load(fname,CS,'interface','crc',...
  'convertEuler2SpatialReferenceFrame');
%% 
% As our data has two different phases, here we combine them into one and plot.
ebsd(ebsd.phase==2).phase = 1;
plot(ebsd,ebsd.orientations)
ebsd= ebsd('indexed')
%% 
% Here are the pole figures for the data:

plotPDF(ebsd.orientations,Miller({1,1,-2,0},{0,0,0,1},ebsd.orientations.CS, 'UVTW'),'contourf')
text(vector3d.X,'X','horizontalAlignment','left')
text(vector3d.Y,'Y','VerticalAlignment','top')

%% 
% Now we are going to rotate the data so that from left to right represents 
% the hypothetical occlusal plane.

ebsdr = rotate(ebsd,rotation.byAxisAngle(zvector,-53*degree))
plot(ebsdr,ebsdr.orientations)
%% 
% How has this affected the pole figures?

plotPDF(ebsdr.orientations,Miller({1,1,-2,0},{0,0,0,1},ebsdr.orientations.CS),'contourf')
text(vector3d.X,'X','horizontalAlignment','left')
text(vector3d.Y,'Y','VerticalAlignment','top')
%% 
% Now we just want to select the tip of the conodont element by defining a poloygon 
% and using it to crop the data.

pgon = polyshape(Pro_Poly)
plot(ebsdr,ebsdr.orientations)
hold on
plot(pgon)
hold off
%%
plot(ebsdr(inpolygon(ebsdr,Pro_Poly)))
%%
ebsd = ebsdr(inpolygon(ebsdr,Pro_Poly))
%%
cs = crystalSymmetry('6/m')
ori = ebsd.orientations
r = vector3d.Z
%% 
% Here are the orientations by axis observed. From left to right are the x,y,z 
% planes.

plotIPDF(ori,[vector3d.X,vector3d.Y,vector3d.Z])
ipfKey = ipfHSVKey(ebsd);
ipfKey.inversePoleFigureDirection = vector3d.X;
colors = ipfKey.orientation2color(ori)
%% 
% Here is the same EBSD colored by inverse pole figure in the X Direction. 

plot(ebsd, colors)
figure;
plot(ipfKey)
hold on
plotIPDF(ori,vector3d.X,'MarkerSize',2,'MarkerFaceColor','none','MarkerEdgeColor','black','points',2000)
hold off
%%
ipfKey = ipfHSVKey(ebsd);
ipfKey.inversePoleFigureDirection = vector3d.Z;
colors = ipfKey.orientation2color(ori)
figure; plot(ebsd, colors)
%% 
% Here is the same EBSD colored by inverse pole figure in the Z Direction. 

plot(ebsd, colors)
figure;
plot(ipfKey)
hold on
plotIPDF(ori,vector3d.Z,'MarkerSize',2,'MarkerFaceColor','none','MarkerEdgeColor','black','points',1000)
hold off
%% 
% These are the final pole figures:

figure;
plotPDF(ebsd.orientations,Miller({1,1,-2,0},ebsd.orientations.CS, 'UVTW'),'contourf')
text(vector3d.X,'X','horizontalAlignment','left')
text(vector3d.Y,'Y','VerticalAlignment','top')
hold on
   mtexColorbar('location','southoutside') %Sets scale bar to be exported with the image
hold off

figure;
plotPDF(ebsd.orientations,Miller({0,0,0,1},ebsd.orientations.CS, 'UVTW'),'contourf')
text(vector3d.X,'X','horizontalAlignment','left')
text(vector3d.Y,'Y','VerticalAlignment','top')
hold on
   mtexColorbar('location','southoutside')
hold off

%%%%%%%% Rotation Crop and Plotting of Panderodus equicostatus %%%%%%%%%
CS = {... 
  'notIndexed',...
  crystalSymmetry('6/m', [9.4 9.4 6.9], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'Apatite', 'color', [0.53 0.81 0.98]),...
  crystalSymmetry('6/m', [9.4 9.4 6.9], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'Hydroxylapatite', 'color', [0.56 0.74 0.56])};

% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','intoPlane');

fname = [pname '\Pan. equicostatus.crc'];

ebsd = EBSD.load(fname,CS,'interface','crc',...
  'convertEuler2SpatialReferenceFrame');
ebsd(ebsd.phase==2).phase = 1;
plot(ebsd,ebsd.orientations)
plotPDF(ebsd.orientations,Miller({1,1,-2,0},{0,0,0,1},ebsd.orientations.CS, 'UVTW'),'contourf')
text(vector3d.X,'X','horizontalAlignment','left')
text(vector3d.Y,'Y','VerticalAlignment','top')
%%
ebsdr = rotate(ebsd,rotation.byAxisAngle(zvector,-50*degree))
plot(ebsdr,ebsdr.orientations)
plotPDF(ebsdr.orientations,Miller({1,1,-2,0},{0,0,0,1},ebsd.orientations.CS, 'UVTW'),'contourf')
text(vector3d.X,'X','horizontalAlignment','left')
text(vector3d.Y,'Y','VerticalAlignment','top')
%%
pgon = polyshape(Pan_Poly)
plot(ebsdr,ebsdr.orientations)
hold on
plot(pgon)
hold off
%%
plot(ebsdr(inpolygon(ebsdr,Pan_Poly)))
%%
ebsd = ebsdr(inpolygon(ebsdr,Pan_Poly))
%%
cs = crystalSymmetry('6/m')
ori = ebsd.orientations
r = vector3d.Z
plotIPDF(ori,[vector3d.X,vector3d.Y,vector3d.Z])
%%
ebsd=ebsd("indexed")
ipfKey = ipfHSVKey(ebsd);
ipfKey.inversePoleFigureDirection = vector3d.X;
colors = ipfKey.orientation2color(ori)
plot(ebsd, colors)
figure;
plot(ipfKey)
hold on
plotIPDF(ori,vector3d.X,'MarkerSize',2,'MarkerFaceColor','none','MarkerEdgeColor','black','points',1000)
hold off
ipfKey = ipfHSVKey(ebsd);
ipfKey.inversePoleFigureDirection = vector3d.Z;
colors = ipfKey.orientation2color(ori)
plot(ebsd, colors)
figure;
plot(ipfKey)
hold on
plotIPDF(ori,vector3d.Z,'MarkerSize',2,'MarkerFaceColor','none','MarkerEdgeColor','black','points',1000)
hold off
%% Pole figures for the manuscript
figure;
plotPDF(ebsd.orientations,Miller({1,1,-2,0},ebsd.orientations.CS, 'UVTW'),'contourf')
text(vector3d.X,'X','horizontalAlignment','left')
text(vector3d.Y,'Y','VerticalAlignment','top')
hold on
   mtexColorbar('location','southoutside') %Sets scale bar to be exported with the image
hold off

figure;
plotPDF(ebsd.orientations,Miller({0,0,0,1},ebsd.orientations.CS, 'UVTW'),'contourf')
text(vector3d.X,'X','horizontalAlignment','left')
text(vector3d.Y,'Y','VerticalAlignment','top')
hold on
   mtexColorbar('location','southoutside')
hold off

%% Rotation Crop and Plotting of Wurmiella excavata %%

CS = {... 
  'notIndexed',...
  crystalSymmetry('6/m', [9.4 9.4 6.9], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'Apatite', 'color', [0.53 0.81 0.98])};

% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','intoPlane');

fname = [pname '\Excavata.ctf'];

ebsd = EBSD.load(fname,CS,'interface','ctf',...
  'convertEuler2SpatialReferenceFrame');
plot(ebsd,ebsd.orientations)
plotPDF(ebsd.orientations,Miller({1,1,-2,0},{0,0,0,1},ebsd.orientations.CS, 'UVTW'),'contourf')
%%
ebsdr = rotate(ebsd,rotation.byAxisAngle(zvector,-65*degree))
plot(ebsdr,ebsdr.orientations)
plotPDF(ebsdr.orientations,Miller({1,1,-2,0},{0,0,0,1},ebsd.orientations.CS, 'UVTW'),'contourf')

%%
figure;
plot(ebsdr)
%%
ebsd = ebsdr
%%
cs = crystalSymmetry('6/m')
ori = ebsd.orientations
r = vector3d.Z
plotIPDF(ori,[vector3d.X,vector3d.Y,vector3d.Z])

%%
ebsd=ebsd("indexed")
ipfKey = ipfHSVKey(ebsd);
ipfKey.inversePoleFigureDirection = vector3d.X;
colors = ipfKey.orientation2color(ori)
plot(ebsd, colors)
figure;
plot(ipfKey)
hold on
plotIPDF(ori,vector3d.X,'MarkerSize',2,'MarkerFaceColor','none','MarkerEdgeColor','black','points',1000)
hold off
ipfKey = ipfHSVKey(ebsd);
ipfKey.inversePoleFigureDirection = vector3d.Z;
colors = ipfKey.orientation2color(ori)
plot(ebsd, colors)
figure;
plot(ipfKey)
hold on
plotIPDF(ori,vector3d.Z,'MarkerSize',2,'MarkerFaceColor','none','MarkerEdgeColor','black','points',1000)
hold off
%%
plotPDF(ebsd.orientations,Miller({1,1,-2,0},{0,0,0,1},ebsd.orientations.CS, 'UVTW'),'contourf')

figure;
plotPDF(ebsd.orientations,Miller({1,1,-2,0},{0,0,0,1},ebsd.orientations.CS, 'UVTW'),'contourf')
hold on 
plotPDF(ebsd.orientations,Miller({1,1,-2,0},{0,0,0,1},ebsd.orientations.CS, 'UVTW'),'MarkerSize',1.5,'MarkerFaceColor','grey','MarkerFaceAlpha',0.3,'MarkerEdgeColor','none','points',6000)
hold off

%% Pole figures for the manuscript
figure;
plotPDF(ebsd.orientations,Miller({1,1,-2,0},ebsd.orientations.CS, 'UVTW'),'contourf')
text(vector3d.X,'X','horizontalAlignment','left')
text(vector3d.Y,'Y','VerticalAlignment','top')
hold on
   mtexColorbar('location','southoutside') %Sets scale bar to be exported with the image
hold off

figure;
plotPDF(ebsd.orientations,Miller({0,0,0,1},ebsd.orientations.CS, 'UVTW'),'contourf')
text(vector3d.X,'X','horizontalAlignment','left')
text(vector3d.Y,'Y','VerticalAlignment','top')
hold on
   mtexColorbar('location','southoutside')
hold off

%%%%%%%%%% Rotation Crop and Plotting of Tripodellus sp. %%%%%%%%%%%

ebsd = Trip_ebsd 
plot(ebsd,ebsd.orientations)
plotPDF(ebsd.orientations,Miller({1,1,-2,0},{0,0,0,1},ebsd.orientations.CS, 'UVTW'),'contourf')
%%
pgon = polyshape(Trip_Poly)
plot(ebsd,ebsd.orientations)
hold on
plot(pgon)
hold off
%%
rot = rotation.byAxisAngle(xvector,90*degree);
ebsdr = rotate(ebsd,rot,'keepXY');
figure;
plot(ebsdr(inpolygon(ebsdr,Trip_Poly)))
%%
ebsd = ebsdr(inpolygon(ebsdr,Trip_Poly))
%%
cs = crystalSymmetry('6/m')
ori = ebsd.orientations
r = vector3d.Z
plotIPDF(ori,[vector3d.X,vector3d.Y,vector3d.Z])
%%
ebsd=ebsd("indexed")
ipfKey = ipfHSVKey(ebsd);
ipfKey.inversePoleFigureDirection = vector3d.Z;
colors = ipfKey.orientation2color(ori)
plot(ebsd, colors)
%%
figure;
plot(ipfKey)
hold on
plotIPDF(ori,vector3d.X,'MarkerSize',2,'MarkerFaceColor','none','MarkerEdgeColor','black','points',1000)
hold off
ipfKey = ipfHSVKey(ebsd);
ipfKey.inversePoleFigureDirection = vector3d.Z;
colors = ipfKey.orientation2color(ori)
plot(ebsd, colors)
figure;
plot(ipfKey)
hold on
plotIPDF(ori,vector3d.Z,'MarkerSize',2,'MarkerFaceColor','none','MarkerEdgeColor','black','points',1000)
hold off
%%
plotPDF(ebsd.orientations,Miller({1,1,-2,0},{0,0,0,1},ebsd.orientations.CS, 'UVTW'),'contourf')

figure;
plotPDF(ebsd.orientations,Miller({1,1,-2,0},{0,0,0,1},ebsd.orientations.CS, 'UVTW'),'contourf')
hold on 
plotPDF(ebsd.orientations,Miller({1,1,-2,0},{0,0,0,1},ebsd.orientations.CS, 'UVTW'),'MarkerSize',1.5,'MarkerFaceColor','grey','MarkerFaceAlpha',0.3,'MarkerEdgeColor','none','points',6000)
hold off
%%
figure;
plotPDF(ebsd.orientations,Miller({1,1,-2,0},ebsd.orientations.CS, 'UVTW'),'contourf')
text(vector3d.X,'X','horizontalAlignment','left')
text(vector3d.Y,'Y','VerticalAlignment','top')
hold on
   mtexColorbar('location','southoutside') %Sets scale bar to be exported with the image
hold off

figure;
plotPDF(ebsd.orientations,Miller({0,0,0,1},ebsd.orientations.CS, 'UVTW'),'contourf')
text(vector3d.X,'X','horizontalAlignment','left')
text(vector3d.Y,'Y','VerticalAlignment','top')
hold on
   mtexColorbar('location','southoutside')
hold off
% Rotation Crop and Plotting of Palmatolepis sp.
%%
%%%%%%%%%% Palmatolepis sp. %%%%%%%%%%
CS = {... 
  'notIndexed',...
  crystalSymmetry('6/m', [9.5 9.5 6.8], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'Apatite', 'color', [0.53 0.81 0.98]),...
  crystalSymmetry('6/m', [9.4 9.4 6.9], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'Hydroxylapatite', 'color', [0.85 0.65 0.13]),...
  crystalSymmetry('6/m', [9.4 9.4 6.9], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'Apatite_mix_1', 'color', [0.94 0.5 0.5])};

% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','intoPlane');

% which files to be imported
fname = [pname '\Palmatolepis.crc'];

%% Import the Data

% create an EBSD variable containing the data
ebsd = EBSD.load(fname,CS,'interface','crc',...
  'convertEuler2SpatialReferenceFrame');
%%
ebsd(ebsd.phase==3).phase = 2;
ebsd(ebsd.phase==4).phase = 2;
plot(ebsd,ebsd.orientations)
plotPDF(ebsd.orientations,Miller({1,1,-2,0},{0,0,0,1},ebsd.orientations.CS, 'UVTW'),'contourf')
%%
ebsdr = rotate(ebsd,rotation.byAxisAngle(zvector,-150*degree))
plot(ebsdr,ebsdr.orientations)
plotPDF(ebsdr.orientations,Miller({1,1,-2,0},{0,0,0,1},ebsd.orientations.CS, 'UVTW'),'contourf')
%%
rot = rotation.byAxisAngle(xvector,90*degree);
ebsdr = rotate(ebsdr,rot,'keepXY');
%%
pgon = polyshape(Pal_Poly)
plot(ebsdr,ebsdr.orientations)
hold on
plot(pgon)
hold off
%%
figure;
plot(ebsdr(inpolygon(ebsdr,Pal_Poly)))
%%
ebsd = ebsdr(inpolygon(ebsdr,Pal_Poly))
%%
cs = crystalSymmetry('6/m')
ori = ebsd.orientations
r = vector3d.Z
plotIPDF(ori,[vector3d.X,vector3d.Y,vector3d.Z])
%%
ebsd=ebsd("indexed")
ipfKey = ipfHSVKey(ebsd);
ipfKey.inversePoleFigureDirection = vector3d.Y;
colors = ipfKey.orientation2color(ori)
plot(ebsd, colors)
figure;
plot(ipfKey)
hold on
plotIPDF(ori,vector3d.X,'MarkerSize',2,'MarkerFaceColor','none','MarkerEdgeColor','black','points',1000)
hold off
ipfKey = ipfHSVKey(ebsd);
ipfKey.inversePoleFigureDirection = vector3d.Z;
colors = ipfKey.orientation2color(ori)
plot(ebsd, colors)
figure;
plot(ipfKey)
hold on
plotIPDF(ori,vector3d.Z,'MarkerSize',2,'MarkerFaceColor','none','MarkerEdgeColor','black','points',1000)
hold off
%%
plotPDF(ebsd.orientations,Miller({1,1,-2,0},{0,0,0,1},ebsd.orientations.CS, 'UVTW'),'contourf')

figure;
plotPDF(ebsd.orientations,Miller({1,1,-2,0},{0,0,0,1},ebsd.orientations.CS, 'UVTW'),'contourf')
hold on 
plotPDF(ebsd.orientations,Miller({1,1,-2,0},{0,0,0,1},ebsd.orientations.CS, 'UVTW'),'MarkerSize',1.5,'MarkerFaceColor','grey','MarkerFaceAlpha',0.3,'MarkerEdgeColor','none','points',6000)
hold off
%%
figure;
plotPDF(ebsd.orientations,Miller({1,1,-2,0},ebsd.orientations.CS, 'UVTW'),'contourf')
text(vector3d.X,'X','horizontalAlignment','left')
text(vector3d.Y,'Y','VerticalAlignment','top')
hold on
   mtexColorbar('location','southoutside') %Sets scale bar to be exported with the image
hold off

figure;
plotPDF(ebsd.orientations,Miller({0,0,0,1},ebsd.orientations.CS, 'UVTW'),'contourf')
text(vector3d.X,'X','horizontalAlignment','left')
text(vector3d.Y,'Y','VerticalAlignment','top')
hold on
   mtexColorbar('location','southoutside')
hold off

%% Rotation Crop and Plotting of Bispathodus cf. aculeatus
CS = {... 
  'notIndexed',...
  crystalSymmetry('6/m', [9.4 9.4 6.9], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'Apatite', 'color', [0.53 0.81 0.98]),...
  crystalSymmetry('6/m', [9.4 9.4 6.9], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'Hydroxylapatite', 'color', [0.56 0.74 0.56])};

% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','intoPlane');

fname = [pname '\Bisp.crc'];

ebsd = EBSD.load(fname,CS,'interface','crc',...
  'convertEuler2SpatialReferenceFrame');
ebsd(ebsd.phase==2).phase = 1;
plot(ebsd,ebsd.orientations)
%%
ebsd= ebsd('indexed')
plotPDF(ebsd.orientations,Miller({1,1,-2,0},{0,0,0,1},ebsd.orientations.CS, 'UVTW'),'contourf')

ebsdr = rotate(ebsd,rotation.byAxisAngle(zvector,190*degree))
plot(ebsdr,ebsdr.orientations)
plotPDF(ebsdr.orientations,Miller({1,1,-2,0},{0,0,0,1},ebsdr.orientations.CS),'contourf')
rot = rotation.byAxisAngle(xvector,90*degree);
ebsdr = rotate(ebsdr,rot,'keepXY');

%%
pgon = polyshape(Bispa_poly)
plot(ebsdr,ebsdr.orientations)
hold on
plot(pgon)
hold off
figure;
plot(ebsdr(inpolygon(ebsdr,Bispa_poly)))
%%
ebsd = ebsdr(inpolygon(ebsdr,Bispa_poly))
cs = crystalSymmetry('6/m')
ori = ebsd.orientations
r = vector3d.Z
plotIPDF(ori,[vector3d.X,vector3d.Y,vector3d.Z])
ipfKey = ipfHSVKey(ebsd);
ipfKey.inversePoleFigureDirection = vector3d.X;
colors = ipfKey.orientation2color(ori)
plot(ebsd, colors)
figure;
plot(ipfKey)
hold on
plotIPDF(ori,vector3d.X,'MarkerSize',2,'MarkerFaceColor','none','MarkerEdgeColor','black','points',1000)
hold off
ipfKey = ipfHSVKey(ebsd);
ipfKey.inversePoleFigureDirection = vector3d.Z;
colors = ipfKey.orientation2color(ori)
plot(ebsd, colors)
figure;
plot(ipfKey)
hold on
plotIPDF(ori,vector3d.Z,'MarkerSize',2,'MarkerFaceColor','none','MarkerEdgeColor','black','points',1000)
hold off

plotPDF(ebsd.orientations,Miller({1,1,-2,0},{0,0,0,1},ebsd.orientations.CS, 'UVTW'),'contourf')

figure;
plotPDF(ebsd.orientations,Miller({1,1,-2,0},{0,0,0,1},ebsd.orientations.CS, 'UVTW'),'contourf')
hold on 
plotPDF(ebsd.orientations,Miller({1,1,-2,0},{0,0,0,1},ebsd.orientations.CS, 'UVTW'),'MarkerSize',1.5,'MarkerFaceColor','grey','MarkerFaceAlpha',0.3,'MarkerEdgeColor','none','points',6000)
hold off
%% Final pole figures for the manuscript
figure;
plotPDF(ebsd.orientations,Miller({1,1,-2,0},ebsd.orientations.CS, 'UVTW'),'contourf')
text(vector3d.X,'X','horizontalAlignment','left')
text(vector3d.Y,'Y','VerticalAlignment','top')
hold on
   mtexColorbar('location','southoutside') %Sets scale bar to be exported with the image
hold off

figure;
plotPDF(ebsd.orientations,Miller({0,0,0,1},ebsd.orientations.CS, 'UVTW'),'contourf')
text(vector3d.X,'X','horizontalAlignment','left')
text(vector3d.Y,'Y','VerticalAlignment','top')
hold on
   mtexColorbar('location','southoutside')
hold off
