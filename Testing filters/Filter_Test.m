%% Filter tests
%Load a simulated data set
import_wizard
%%
ebsd1 = ebsd
figure; plot(ebsd,ebsd.orientations)
%%
%F = meanFilter;
%%
F = medianFilter;
%%
F = KuwaharaFilter;
%%
%F = splineFilter;
%%
%F = halfQuadraticFilter;
%%
%F = infimalConvolutionFilter;
%F.lambda = 0.01; % sssmoothing parameter for the gradient
%F.mu = 0.005;    % smoothing parameter for the hessian
%%
% F.numNeighbours = 1;
n=3
%%
for r = 1:n
        ebsd = ebsd1
        F.numNeighbours = r;
ebsd = smooth(ebsd,F);
                    figure; plot(ebsd,ebsd.orientations)
                    h = plot(ebsd,ebsd.orientations)
                    saveas(h,sprintf('medianFilter.Exca%d.png',r));
end