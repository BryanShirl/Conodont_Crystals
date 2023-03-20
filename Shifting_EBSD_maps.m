%Probably the worst way to align data sets, but I didnt have the time to do
%it another way
%Inport a dataset
import_wizard
%%
%B3 = ebsd
block1= Btot
%%
%A slow and painful way of scaling mtex data
x=73
y=-48
B3shift = shift(B3,[x,y])

%figure; plot(ebsd,ebsd.orientations)
Btot= [block1,B3shift]
figure; plot(Btot,Btot.orientations)
%%
ebsd=Btot
ebsd.export('B.ctf')
