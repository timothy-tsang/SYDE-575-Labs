%% Section 1
cameraman = imread('cameraman.tif');
mandrill = imread('mandrill.png');

%% Section 2

f = [0.3*ones(200,100) 0.7*ones(200,100)];

% Additive zero-mean Gaussian and Salt & Pepper
f_1 = imnoise(f,'gaussian', 0, 0.01);
f_2 = imnoise(f,'salt & pepper',0.05);

% Multiplicative Speckle
f_3 = imnoise(f,'speckle',0.04);

%
figure; 
imshow(f_1);
title('gaussian toy image');
figure;
imhist(f_1);
title('gaussian toy image histogram');

%
figure; 
imshow(f_2);
title('salt & pepper toy image');
figure;
imhist(f_2);
title('salt & pepper toy image histogram');

%
figure; 
imshow(f_3);
title('speckle toy image');
figure;
imhist(f_3);
title('speckle toy image histogram');

%% Section 3 - Noise Reduction in the Spatial Domain

% Convert RGB image to greyscale
g_mandrill = rgb2gray(mandrill);
figure;
imshow(g_mandrill);
title('grey mandrill');

% Convert int8 to double image
dg_mandrill = im2double(g_mandrill);
figure;
imhist(dg_mandrill);
title('grey mandrill histogram');
%%

% Contaminate with variance of 0.002
c_mandrill = imnoise(dg_mandrill,'gaussian', 0, 0.002);
figure;
imshow(c_mandrill);
title('gaussian mandrill');
figure;
imhist(c_mandrill);
title('gaussian mandrill histogram');

% PSNR
c_mandrill_psnr = 10*log10(1/mean2((dg_mandrill-c_mandrill).^2));

%%
% 3x3 Averaging Filter 
avg_filter = fspecial('average');
figure;
imagesc(avg_filter);
colormap('gray');
title('average filter image');

% Apply filter
mandrill_filter = imfilter(c_mandrill, avg_filter);
figure;
imshow(mandrill_filter);
title('3x3 filtered mandrill');
figure;
imhist(mandrill_filter);
title('3x3 filtered mandrill histogram');

f_mandrill_psnr = 10*log10(1/mean2((dg_mandrill-mandrill_filter).^2));
%%

% 7x7 Filter
avg_filter_2 = fspecial('average', 7);

% Apply 7x7 filter
mandrill_filter_2 = imfilter(c_mandrill, avg_filter_2);
figure;
imshow(mandrill_filter_2);
title('7x7 filtered mandrill');
figure;
imhist(mandrill_filter_2);
title('7x7 filtered mandrill histogram');

f_mandrill_psnr_2 = 10*log10(1/mean2((dg_mandrill-mandrill_filter_2).^2));

% 7x7 Gaussian filter
avg_filter_3 = fspecial('gaussian',7,1);
figure;
imagesc(avg_filter_3);
colormap('gray');
title('gaussian filter');

% Apply 7x7 Gaussian filter
mandrill_filter_3 = imfilter(c_mandrill, avg_filter_3);
figure;
imshow(mandrill_filter_3);
title('7x7 gaussian filtered mandrill');
figure;
imhist(mandrill_filter_3);
title('7x7 gaussian filtered mandrill histogram');

f_mandrill_psnr_3 = 10*log10(1/mean2((dg_mandrill-mandrill_filter_3).^2));

%%

% Salt and Pepper image 
sp_mandrill = imnoise(dg_mandrill,'salt & pepper');
figure;
imshow(sp_mandrill);
title('salt & pepper mandrill');

figure;
imhist(sp_mandrill);
title('salt & pepper mandrill histogram');


%%
% Apply 7x7 filter with Salt & Pepper
mandrill_filter_4 = imfilter(sp_mandrill, avg_filter_2);
figure;
imshow(mandrill_filter_4);
title('7x7 filtered salt & pepper mandrill');
figure;
imhist(mandrill_filter_4);
title('7x7 filtered salt & pepper mandrill histogram');

f_mandrill_psnr_4 = 10*log10(1/mean2((sp_mandrill-mandrill_filter_4).^2));

% Apply 7x7 Gaussian filter with Salt & Pepper
mandrill_filter_5 = imfilter(sp_mandrill, avg_filter_3);
figure;
imshow(mandrill_filter_5);
title('7x7 gaussian filtered salt & pepper mandrill');
figure;
imhist(mandrill_filter_5);
title('7x7 gaussian filtered salt & pepper mandrill histogram');

f_mandrill_psnr_5 = 10*log10(1/mean2((sp_mandrill-mandrill_filter_5).^2));
 
% Apply Median filter with Salt & Pepper
mandrill_filter_6 = medfilt2(sp_mandrill);
figure;
imshow(mandrill_filter_6);
title('median filtered mandrill');
figure;
imhist(mandrill_filter_6);
title('median filtered mandrill histogram');

f_mandrill_psnr_6 = 10*log10(1/mean2((sp_mandrill-mandrill_filter_6).^2));

%% Section 4 - Sharpening in the Spatial Domain

intensity = im2double(cameraman);
f_cameraman = imfilter(intensity, avg_filter_2);
figure;
imshow(f_cameraman);
title('7x7 gaussian filtered cameraman');

difference = (intensity-f_cameraman);
figure;
imshow(difference);
title('difference cameraman');

sharpened_image = intensity + difference;
figure;
imshow(sharpened_image);
title('sharpened cameraman');

sharpened_image_2 = intensity + (difference/2);
figure;
imshow(sharpened_image_2);
title('less sharpened cameraman');
