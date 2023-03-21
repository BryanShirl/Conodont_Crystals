%%
import_wizard
%%
%ebsd(ebsd.phase==4).phase =2
figure,
plot(ebsd)

%%
 figure; plot(ebsd,ebsd.orientations)
 %%   
 polyx = selectPolygon;
 %%  
 ebsd = ebsd(inpolygon(ebsd,polyx));
%%
figure; plot(ebsd,ebsd.orientations)
ebsd1 = ebsd %sets a fresh reset point
%%
ebsd.export('B.ctf')

