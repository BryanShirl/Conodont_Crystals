%% Plotting a pole figure of all the possible orientations
h = Miller({0,1,0},{0,0,1},ebsd('Apatite').CS);
%%
h = [Miller(1,0,-1,0,ebsd('Apatite').CS),
      Miller(0,0,0,1,ebsd('Apatite').CS),
       Miller(1,0,-1,1,ebsd('Apatite').CS),
        Miller(1,0,-1,2,ebsd('Apatite').CS),
         Miller(2,0,-2,1,ebsd('Apatite').CS),
          Miller(1,1,-2,2,ebsd('Apatite').CS),
           Miller(1,1,-2,1,ebsd('Apatite').CS),
            Miller(2,1,-3,1,ebsd('Apatite').CS),
             Miller(3,1,-4,1,ebsd('Apatite').CS),
              Miller(2,1,-3,0,ebsd('Apatite').CS),
                                                  ];
%%
figure,
    plotPDF(ebsd('Apatite').orientations,h,'grid',...
    'projection','eangle','upper','markerSize',2,'points',4000)
%%
