% % Laila Alamri 
% % I worked with Jami Stuckey and Varshini Ramnathan

clear;
close all;
clc;
%% Question 1 
%loading given 3D data (kspace)
load("3DSheppLoganKSpace-1.mat");
kspace3D = kspaceSignal;

%loading given 2D data(kspace)w
load("2DSheppLoganKSpace.mat");
kspace2D = kspaceSignal;

%Converting from kspace to image space 
I3 = ifftshift(ifftn(kspace3D));
I2 = ifftshift(ifftn(kspace2D));

%Getting absolute images 
fullI3 = squeeze(sqrt(sum(abs(I3).^2, 4)));
fullI2 = squeeze(sqrt(sum(abs(I2).^2, 4)));

%Slice Indexing 
slices = round(numel(I3(1,1,:))/2.3);

%Getting Absolute, Real and Imaginary Parts 
boundaries_3D = abs([min(I3,[],'all'),max(I3,[],'all')]);
boundaries_2D = abs([min(I2,[],'all'),max(I2,[],'all')]);

I3_abs = abs(I3(:,:,slices));
I2_abs = abs(I2);

I3_real = real(I3(:,:,slices));
I2_real = real(I2);

I3_imag = imag(I3(:,:,slices));
I2_imag = imag(I2);

%Plotting the Calculated Images (3D)
figure;
subplot(2,2,1)
imagesc(fullI3(:,:,slices),boundaries_3D);
colormap(gray);
title('Full Generated Image (using Squeeze Function)');

subplot(2,2,2)
imagesc(I3_abs,boundaries_3D);
colormap(gray);
title('Absolute Value of Generated Image');

subplot(2,2,3)
imagesc(I3_real,boundaries_3D);
colormap(gray);
title('Real Part of Generated Image');

subplot(2,2,4)
imagesc(I3_imag,boundaries_3D);
colormap(gray);
title('Imaginary Part of Generated Image')

sgtitle("3D Shepp Logan")


%Plotting the Calculated Images (2D)
figure;
subplot(2,2,1)
imagesc(fullI2,boundaries_2D);
colormap(gray);
title('Full Generated Image (using Squeeze Function)');

subplot(2,2,2)
imagesc(I2_abs,boundaries_2D);
colormap(gray);
title('Absolute Value of Generated Image');

subplot(2,2,3)
imagesc(I2_real,boundaries_2D);
colormap(gray);
title('Real Part of Generated Image');

subplot(2,2,4)
imagesc(I2_imag,boundaries_2D);
colormap(gray);
title('Imaginary Part of Generated Image')

sgtitle("2D Shepp Logan")

%spacing 
spacing = [1, 1, 1];

%Writing to VTK File 
write_vtk_Volume(fullI3,spacing,"3DSheppLogan_pview.vtk")
disp('File is stored in MATLAB folder.');


%% Question 2 


%Obtaining the desired subsets 
kspace_i = squeeze(kspace3D(50:1:100,:,:));
kspace_ii = squeeze(kspace3D(1:1:(end/2),:,:));
kspace_iii = squeeze(kspace3D(1:1:round(end/3),:,:));
kspace_iv = squeeze(kspace3D(:,:,53));

%Getting Image Space from kspace subsets
img_i = ifftshift(ifftn(kspace_i));
img_ii = ifftshift(ifftn(kspace_ii));
img_iii = ifftshift(ifftn(kspace_iii));
img_iv = ifftshift(ifftn(kspace_iv));

full_i = squeeze(sqrt(sum(abs(img_i).^2, 4)));
full_ii = squeeze(sqrt(sum(abs(img_ii).^2, 4)));
full_iii = squeeze(sqrt(sum(abs(img_iii).^2, 4)));
full_iv = squeeze(sqrt(sum(abs(img_iv).^2, 4)));

%Spacing for the subsets 
si = [1,1,1];
sii = [2,1,1];
siii = [4,1,1];
siv = [1,1,128];

%Writing to VTK to Visualize 
write_vtk_Volume(full_i,si,"3D_SheppLogan_S1.vtk");
write_vtk_Volume(full_ii,sii,"3D_SheppLogan_S2.vtk");
write_vtk_Volume(full_iii,siii,"3D_SheppLogan_S3.vtk");
write_vtk_Volume(full_iv,siv,"3D_SheppLogan_S4.vtk");

disp("All subsets are written to VTK files.");


%% Question 3a


%Calculating the back projection 
steps = 180;
r = zeros(steps,size(fullI2,2)); %I2 is just the 2d pantom in the image space 
for k=1:steps
    r(k,:) = sum(imrotate(fullI2,(-(k-1)*180)/steps,'bilinear','crop'));
end 

%Sinogram Generated Back Projection
I2r = radon(fullI2,0:180);

%Comparing Calculated vs. Generated 
figure;
subplot(1,2,1)
imshow(r,[])
title('Calculated Back Projection')

subplot(1,2,2)
imshow(I2r',[]);
title('Signogram Generated Back Projection')

sgtitle("Calculated vs. Generated Back Projection")


%% Question 3


I = ifftshift(ifftn(r));

%50 steps 
steps = 50;
bp1 = BackProjection_Simple(I,steps);

% 100 steps 
steps = 100;
bp2 = BackProjection_Simple(I,steps);

%180 steps 
steps = 180;
bp3 = BackProjection_Simple(I,steps);

%Displaying the different back projections 
figure;
subplot(3,1,1)
imshow(abs(bp1),[]);
title('50 Steps')

subplot(3,1,2)
imshow(abs(bp2),[])
title('100 Steps')

subplot(3,1,3)
imshow(abs(bp3),[])
title('180 Steps')

sgtitle('Literal Back Projections with Varying Steps')

%% Question 4

%creating the 2D Shepp Logan Image
I = phantom(128);
theta = 180;

%Different M values 
M5 = 5; 
M10 = 10; 
M50 = 50;

%Spacings 
spacing5 = linspace(0,theta,M5);
spacing10 = linspace(0,theta,M10);
spacing50 = linspace(0,theta,M50);

%Getting the kspaces 
k5 = radon(I,spacing5);
k10 = radon(I,spacing10);
k50 = radon(I,spacing50);

%Projections
P5 = iradon(k5,spacing5,'Ram-Lak','none');
P10 = iradon(k10,spacing10,'Ram-Lak','none');
P50 = iradon(k50,spacing50,'Ram-Lak','none');

%Displaying Projections and kspaces 
subplot(3,2,1)
imagesc(k5);
title('Kspace using M = 5')

subplot(3,2,2)
imagesc(P5);
title('Projection using M = 5')

subplot(3,2,3)
imagesc(k10);
title('Kspace using M = 10')

subplot(3,2,4)
imagesc(P10);
title('Projection using M = 10')

subplot(3,2,5)
imagesc(k50);
title('Kspace using M = 50')

subplot(3,2,6)
imagesc(P50);
title('Projection using M = 50')



%% Question 5 


%getting the mean intensity of the image 
I = phantom(128);
avg_I = 100*mean(mean(I));

%adding the artifact to the center of the image 
art = I;
range = linspace(45,84,40);
for i=1:40
    for j=1:40
        art(range(i),range(j)) = avg_I;
    end
end 

%displaying the image with the artifact 
figure;
imagesc(art);
title('Image with Artifact in Center');


%Sinograms with different Mvalues
theta50 = linspace(1,180,50);
S50 = radon(art,theta50);

theta100 = linspace(1,180,100);
S100 = radon(art,theta100);

theta180 = linspace(1,180,180);
S180 = radon(art,theta180);

%Displaying Sinograms
figure; 
subplot(3,1,1)
imagesc(S50);
title('M = 50')

subplot(3,1,2)
imagesc(S100);
title('M = 100');

subplot(3,1,3)
imagesc(S180);
title('M = 180');

sgtitle('Sinograms of Image with Artifact with Different M Values')

%Reconstruction 
I50 = iradon(S50,theta50);
I100 = iradon(S100,theta100);
I180 = iradon(S180,theta180);

%Showing the reconstructions
figure; 
subplot(3,1,1)
imagesc(I50);
title('M = 50')

subplot(3,1,2)
imagesc(I100);
title('M = 100');

subplot(3,1,3)
imagesc(I180);
title('M = 180');

sgtitle('Reconstructions from Different Sinograms');

















