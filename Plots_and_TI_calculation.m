% Code associated with the publication "Quanitifying conodont crystals" by
% Tested and running in Mtex v5.7.0 MATLAB R2021b

%% Step 1 get Mtex up and running %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is used to do data analysis of ebsd data
% Clear the data before we begin
clear
close all
home
%% Start up Mtex
%Set WD to the path in which mtex is stored
mtexpath = 'C:\Mtex\mtex-5.7.0';
addpath(mtexpath)
startup_mtex


%% Step 2 Import, cleaning and cropping of the data %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setting up an convention for how to import our data! 
% X to the east, Y to the south, and Z into the plane
% This can all be done via the import wizard
import_wizard

 %% Checking the data
figure,
plot(ebsd)

%% This will sort out both our phases into one and also only consider our indexed pixels
%Converting Hydroxylapatite to apatite
     ebsd(ebsd.phase==2).phase =1;
     plot(ebsd)

%% Cropping the data
    polyx = selectPolygon;
    ebsd = ebsd(inpolygon(ebsd,polyx));

    %% Orientation Map
figure; plot(ebsd,ebsd.orientations)


%% Step 3 Plotting Pole figures %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot pole figures
hw = 4; % Setting the half width at 4 degrees
odfimp =calcDensity(ebsd.orientations,'halfwidth',hw*degree); %ODF calcutlation for the whole data set

   figure;
   plotPDF(odfimp,Miller({0,0,0,1},{1,1,-2,0},ebsd('Apatite').orientations.CS),'contourf') % Plotting the pole figures from said data set
hold on
   mtexColorbar('location','southoutside') %Sets scale bar to be exported with the image
hold off

%% Step 4 Calculating texture index %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Loop that takes files and automatically takes EBSD files and pumps out csv file with T-INDEX
% First we find out the x and y co-ords of the EBSD data
   a = round(max(ebsd.prop.x)); %xmax value 
   b = round(min(ebsd.prop.x)); %xmin value 
   c = round(max(ebsd.prop.y)); %ymax value 
   d = round(min(ebsd.prop.y)); %ymin value 
 
 %Then we define the upper and lower limits of the area to be subsampled          
   boxwhmin = 20; % Sets min width and height of box for the ana (Here 20, but sample dependent)
   boxwhmax = 100; % Sets max width and height of box for the ana (Here 100, but sample dependent)


%% Step 5 Running the loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%First we define the number of runs we want by defining the variable "n"
    n = 100; % number of random boxes you want to place
    Tindex = nan(n,2);
    ebsd1 = ebsd %Used to reset the loop

%% Runining the loop
    f = waitbar(0, 'Starting'); % Starts a progress bar 
    for r = 1:n

        ebsd = ebsd1
            %figure; 
                %plot(ebsd)
            % Randomly defining the dimentions of the subset
            width = randi(boxwhmax-boxwhmin)+boxwhmin
            height = width;

            % Randomly defining the x,y co-ords of the box
            xCenter = randi(a-b)+b; % Wherever...
            yCenter = randi(c-d)+ d; % Wherever...
            xLeft = xCenter - width/2;
            yBottom = yCenter - height/2
            
            % Placement of the box and subsetting the EBSD data
            rec = rectangle('Position', [xLeft, yBottom, width, height], 'EdgeColor', 'b', 'LineWidth', 3);
            ebsd = ebsd(inpolygon(ebsd,[xLeft, yBottom, width, height]));

            %pause(0.5)
%%  
                if length(ebsd(ebsd.phase==1)) > length(ebsd(ebsd.phase==0))
                
                crys = Miller({0,1,0},{0,0,1},ebsd.CS); %Setting miller index
                    ori = ebsd.orientations;
                    odf = calcDensity(ori);
                t = textureindex (odf); % Calculate texture index
                Tindex(r,1) = t; % Export T-index to table
                Tindex(r,2) = width % Export area data to table
                
                    close all
               
                else       
                
                    close all
                
                end  

        waitbar(r/n, f, sprintf('Progress: %d %%', floor(r/n*100)));
                
        end
        
        close(f)