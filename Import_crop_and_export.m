%%
import_wizard
%%
figure,
plot(ebsd)
ebsd(ebsd.phase==2).phase =1
figure,
plot(ebsd)

%%
 figure; plot(ebsd,ebsd.orientations)
    polyx = selectPolygon;
    ebsd = ebsd(inpolygon(ebsd,polyx));
%%
figure; plot(ebsd,ebsd.orientations)
ebsd1 = ebsd %sets a fresh reset point
%%
ebsd.export('Excavata.ctf')

