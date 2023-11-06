
%% Function to calcuate the T-index, M-Index and IPFT-index from an EBSD dataset %%
% Code associated with the publication "Increasing control over biomineralization in conodont evolution"
% Tested and running in Mtex v5.7.0 MATLAB R2021b

% "ebsd" is the desired ebsd dataset
% "boxmin" is the minimum size for generated box
% "boxmin" is the maximum size for generated box
%  runs is the number of runs to be conducted

function Tindex = TexCalc(ebsd, boxmin, boxmax,runs)

% Loop that takes files and automatically takes EBSD files and pumps out csv file with T-INDEX
% First we find out the x and y co-ords of the EBSD data
   a = round(max(ebsd.prop.x)); %xmax value 
   b = round(min(ebsd.prop.x)); %xmin value 
   c = round(max(ebsd.prop.y)); %ymax value 
   d = round(min(ebsd.prop.y)); %ymin value 
 
 %Then we define the upper and lower limits of the area to be subsampled          
   boxwhmin = boxmin; % Sets min width and height of box for the analysis
   boxwhmax = boxmax; % Sets max width and height of box for the analysis 


%% Step 5 Running the loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%First we define the number of runs we want by defining the variable "n"
    n = runs; % number of random boxes you want to place
%Set up an empty double to fill with outputs
    Tindex = nan(n,5);
    ebsd1 = ebsd % Used to reset the loop
    plot(ebsd,ebsd.orientations)
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
        %hold on
        %rec = rectangle('Position', [xLeft, yBottom, width, height], 'EdgeColor', 'b', 'LineWidth', 3);
        ebsd = ebsd(inpolygon(ebsd,[xLeft, yBottom, width, height]));

        %check if the data is more than 50 of fov. If not nan returned
        if length(ebsd(ebsd.phase==1)) > length(ebsd(ebsd.phase==0)) 
          
         
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
% Calculate pfTi for C and A axis
h1= Miller({0,0,0,1},ebsd.orientations.CS);
h2= Miller({1,1,-2,0},ebsd.orientations.CS);
pfg1 = calcPDF(odf,h1);
pfTC = (pfg1.norm).^2/sqrt(4*pi);
pfg2 = calcPDF(odf,h2);
pfTA = (pfg2.norm).^2/sqrt(4*pi);

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
save ('Tindex.mat', 'Tindex')
        %close(f)
end