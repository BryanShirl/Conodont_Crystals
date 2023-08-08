
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
mtexpath = 'C:\Users\hohma004\Documents\Mtex'; %Set this to your own path to mtex
addpath(mtexpath)
startup_mtex


%% Step 2 Import, cleaning and cropping of the data %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setting up an convention for how to import our data! 
% X to the east, Y to the south, and Z into the plane
% This can all be done via the import wizard
% crystal symmetry
CS = {... 
  'notIndexed',...
  crystalSymmetry('6/m', [9.4 9.4 6.9], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'Apatite', 'color', [0.53 0.81 0.98])};
% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','intoPlane');
% Specify File Names
% path to files
pname = 'C:\Users\Shirl001\Documents\GitHub\Conodont_Crystals\EBSD data (ctf)'; %Set your own directoryww
% which files to be imported
fname = [pname '\B.ctf'];% Change to the ctf file you want
% Import the Data
% create an EBSD variable containing the data
ebsd = EBSD.load(fname,CS,'interface','ctf',...
  'convertEuler2SpatialReferenceFrame');


 %% Checking the data
figure,
plot(ebsd)

%% Orientation Map
figure; plot(ebsd,ebsd.orientations)

ebsd1 = ebsd %sets a fresh reset point

%% Step 3 Plotting Pole figures %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot pole figures
hw = 4; % Setting the half width at 4 degrees
odfimp =calcDensity(ebsd.orientations,'halfwidth',hw*degree); %ODF calcutlation for the whole data set

   figure;
   plotPDF(odfimp,Miller({0,0,0,1},{1,1,-2,0},ebsd('Apatite').orientations.CS),'contourf') % Plotting the pole figures from said data set
hold on
   mtexColorbar('location','southoutside') %Sets scale bar to be exported with the image
   %% 
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
   boxwhmin = 10; % Sets min width and height of box for the ana (Here 20, but sample dependent)
   boxwhmax = 50; % Sets max width and height of box for the ana (Here 100, but sample dependent)


%% Step 5 Running the loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%First we define the number of runs we want by defining the variable "n"
    n = 200; % number of random boxes you want to place
%Set up an empty double to fill with outputs
    Tindex = nan(n,5);
%Setting filter parameters. NOTE: does not filter by default, its
%commented out in the below loop.
    F = medianFilter;
    F.numNeighbours = 3;
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
            %rec = rectangle('Position', [xLeft, yBottom, width, height], 'EdgeColor', 'b', 'LineWidth', 3);
        ebsd = ebsd(inpolygon(ebsd,[xLeft, yBottom, width, height]));

        %pause(0.5)
        %check if the data is more than 50 of fov. If not nan returned
        if length(ebsd(ebsd.phase==1)) > length(ebsd(ebsd.phase==0)) 
          
        %Do we want the data smoothed? Tick this box
        %ebsd = smooth(ebsd,F);
         
                crys = Miller({0,0,0,1},{1,1,-2,0},ebsd.CS); %Setting miller index
                    ori = ebsd.orientations;
                    odf = calcDensity(ori);
        % Calculate texture index
          t = textureindex (odf); 
                
           %Calculating the m-index (Function copy and pasted from mtex function)
                % Step 1 : Uniform misorientation angle distribution for Crystal symmetry (CS)
                [density_uniform,~] = calcAngleDistribution(odf.CS,odf.SS);
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
      
%Not yet implimented in mtex but from 
% Calculate pfTi for C axis
 h= Miller({0,0,0,1},ebsd('Apatite').orientations.CS);                
       for i = 1:length(h)
    pfg = calcPDF(odf, h(i));
    if pfg.bandwidth ~=0
    pfg_max(i) =  max(pfg);
    else
    pfg_max(i) =1;
    end
    pfTindex(i) = pfg.norm/sqrt(4*pi);
    % calculate the multiplicity
    m(i)=length(symmetrise(h(i)));
end
 ebsd = ebsd1
resolution = 1;
reg = regularS2Grid('resolution', resolution *degree);
[theta]= polar(reg);
dr = (resolution.*degree).^2.*cos(resolution*degree)./4./pi;
for i = 1:length(h)
    pfg = calcPoleFigure(odf, h(i), reg,'complete');
    pfg_max(i) =  max(pfg);
    int =pfg.intensities;
    int = reshape(int,size(reg));
    pfTindex(i) = sqrt(sum(sum(dr.*sin(theta).*int.^2)));
    % calculate the multiplicity
    m(i)=length(symmetrise(h(i)));
    %pfTindex_M(i) = m(i)*pfTindex(i);
    pfTC = pfTindex
end

% Calculate pfTi for other axis
 ebsd = ebsd1
 h= Miller({1,1,-2,0},ebsd('Apatite').orientations.CS);                
       for i = 1:length(h)
    pfg = calcPDF(odf, h(i));
    if pfg.bandwidth ~=0
    pfg_max(i) =  max(pfg);
    else
    pfg_max(i) =1;
    end
    pfTindex(i) = pfg.norm/sqrt(4*pi);
    % calculate the multiplicity
    m(i)=length(symmetrise(h(i)));
end

resolution = 1;
reg = regularS2Grid('resolution', resolution *degree);
[theta]= polar(reg);
dr = (resolution.*degree).^2.*cos(resolution*degree)./4./pi;
for i = 1:length(h)
    pfg = calcPoleFigure(odf, h(i), reg,'complete');
    pfg_max(i) =  max(pfg);
    int =pfg.intensities;
    int = reshape(int,size(reg));
    pfTindex(i) = sqrt(sum(sum(dr.*sin(theta).*int.^2)));
    % calculate the multiplicity
    m(i)=length(symmetrise(h(i)));
    %pfTindex_M(i) = m(i)*pfTindex(i);
    pfTA= pfTindex
end
    clear reg


                Tindex(r,1) = t; % Export T-index to table
                Tindex(r,3) = width % Export area data to table
    	        Tindex(r,2) = MI % Add M index to table
                Tindex(r,4) = pfTC % Add M index to table
                Tindex(r,5) = pfTA % Add M index to table
                    %close all
               
                else       
                
                    %close all
                
                end  

        waitbar(r/n, f, sprintf('Progress: %d %%', floor(r/n*100)));
                
    end

Tindex = rmmissing(Tindex)
        %close(f)
