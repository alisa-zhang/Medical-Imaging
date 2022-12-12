% % Laila Alamri 
% % I worked with Jami Stuckey and Varshini Ramnathan
clear 
clc 
close all 

%% QUESTION 1 

files = dir("RatBrain/*.TIFF");
image = imread("RatBrain/I_VOL_1.TIFF"); %read image

%crop image and store dimensions for later
[x ,rect] = imcrop(image); %yellow portion
[x2,rect2]=imcrop(image);

image = imcrop(image,rect);


% SNR FOR EACH IMAGE
for i=1:length(files)

    %obtain files
    file = files(i,1,1);
        fullfilename = strcat("RatBrain/",file.name);

    img4 = imread(fullfilename); %read image
    img4 = imcrop(img4,rect); %crop by same dimensions as before
    img4 = double(img4); %convert to double

    %calculate SNR
    S = mean(img4(:));
    sigma = std(img4(:));
    SNR(i) = abs(S/sigma);
end

%displaying the SNR values 
figure; 
histogram(SNR);
title('SNR Values')

% Compute the average image of the provided N image & find SNR

% Create summed image
for k = 1:length(files)

    %obtain files
    file = files(k,1,1);
        fullfilename = strcat("RatBrain/",file.name);

    img2 = imread(fullfilename); %read image
    img2 = imcrop(img2,rect); %crop by same dimensions as before
    img2 = double(img2); %convert to double

    if k == 1
        SumImage = img2;
    else
        SumImage = SumImage + img2;
    end
end

% average image & find SNR
avgImg2 = SumImage/length(files);

S_avg = mean(avgImg2(:));
sigma_avg = std(avgImg2(:));
SNR_avg = S_avg/sigma_avg;

%showing time series averaged image versus reference image 
figure()
subplot(1,2,1);
imshow(uint8(avgImg2));
title('Time Series Averaged Image')
subplot(1,2,2);
imshow(image)
title('Reference Image')

%Sqrt(N) 
n = linspace(1,50,50);
n_square = sqrt(n);

figure;
plot(n_square,SNR);
xlabel('Sqrt(N)')
ylabel('SNR')
title('Sqrt(N) Verification')

%% QUESTION 1 compute CNR

files = dir("RatBrain/*.TIFF");
img3 = imread("RatBrain/I_VOL_1.TIFF"); %read image



%CNR FOR EACH IMAGE
for i=1:length(files)

    %obtain files
    file = files(i,1,1);
        fullfilename = strcat("RatBrain/",file.name);

    img4 = imread(fullfilename); %read image
    ylw = imcrop(img4,rect);
    ylw = double(ylw);
    red = imcrop(img4,rect2);
    red = double(red); %convert to double

    %calculate CNR
    S_ylw = mean(ylw(:));
    S_red = mean(red(:));
    sigma_CNR = std([ylw(:);red(:)]);
    CNR(i) = abs((S_ylw-S_red)/sigma_CNR);
end

%displaying the CNR
figure();
histogram(CNR);
title('CNR Values')

% Create summed image
for k = 1:length(files)

    %obtain files
    file = files(k,1,1);
        fullfilename = strcat("RatBrain/",file.name);
      
    I = imread(fullfilename); %read image
    I2 = imread(fullfilename); %read image

    I = imcrop(I,rect);
    I2 = imcrop(I2,rect2);

    I = double(I);
    I2 = double(I2); %convert to double;

    if k == 1
        sumI = I;
        sumI2 = I2;
    else
        sumI = sumI + I;
        sumI2 = sumI2 + I2;
    end
end

% average image & find CNR
avgI = sumI/length(files);
avgI2 = sumI2/length(files);

mu_ylw_avg = mean(avgI(:));
mu_red_avg = mean(avgI2(:));
sigma_avg = std([avgI(:);avgI2(:)]);
CNR_avg = abs((mu_ylw_avg-mu_red_avg)/sigma_avg);


%Comparing the CNRs
CNR_time = mean(CNR);
CNR_improv = abs(CNR_avg-CNR_time/CNR_time)*100;

fprintf('The CNR improves as a result of time series averaging by %4.2f%% \n',CNR_improv)

%% QUESTION 2 

clear; clc; close all;
load('2DSheppLoganKSpace.mat')

I = ifftshift(ifftn(kspaceSignal));
reI = real(I);
imI = abs(complex(I));

% view images (original, real, and im)
figure
subplot(1,3,1)
imagesc(reI);
title('2D Shepp Logan Image: Real');
colormap(gray);

subplot(1,3,2)
imagesc(imI);
title('2D Shepp Logan Image: Complex');
colormap(gray);

subplot(1,3,3)
totI = squeeze(sqrt(sum(abs(I).^2, 4)));
imagesc(totI)
title('Original')
colormap(gray);

kspacecalc = fftshift(fftn(totI));

reK = real(kspaceSignal);
imK = abs(complex((kspaceSignal)));
reK_calc = real(kspacecalc);
imK_calc = abs(complex((kspacecalc)));


% showing kspace graphs 
figure
subplot(1,2,1)
imshow(kspaceSignal)
title('Original K-Space from MRI')
subplot(1,2,2)
kspacecalc = fftshift(fftn(totI));
imshow(kspacecalc)
title('K-Space (Calculated)')

figure 
subplot(1,2,1)
imshow(reK_calc)
title('K-Space (Real)')

subplot(1,2,2)
imshow(imK_calc)
title('K-Space (Complex)')

