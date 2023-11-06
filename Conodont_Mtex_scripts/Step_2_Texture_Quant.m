%% Import EBSD Data
%Setting crystal Symmetry, here we use Apatite
CS = {... 
  'notIndexed',...
  crystalSymmetry('6/m', [9.4 9.4 6.9], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'Apatite', 'color', [0.53 0.81 0.98]),...
% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','intoPlane');
% Direct to desired path and data set
pname = '...';
fname = [pname '\...'];

ebsd = EBSD.load(fname,CS,'interface','crc',...
  'convertEuler2SpatialReferenceFrame');

%% Use the function TexCalc to calculate all texture methods
% Function TexCalc(ebsd,boxmin,boxmin,runs)
% "ebsd" is the desired ebsd dataset
% "boxmin" is the minimum size for generated box
% "boxmin" is the maximum size for generated box
%  runs is the number of runs to be conducted
Tindex = TexCalc(ebsd,10,100,20)