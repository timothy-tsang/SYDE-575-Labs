%% SYDE 575 - Lab 1 
% Timothy Tsang - 20556306
% Jonathan Wen - 

% Load and show images 
figure;
Image1 = imread('cameraman.tif');
imshow(Image1);
title('Original Image 1: Cameraman');
figure;
Image2 = imread('lena.tiff');
imshow(Image2);
title('Original Image 2: Lena');
figure;
Image3 = imread('tire.tif');
imshow(Image3);
title('Original Image 3: Tire');

%% Section 2 - Image Quality Measures 

% Method PSNR that outputs PSNR_out

%% Section 3 - Digital Zooming

% Convert all images to grayscale (if not already) 
GreyImage2 = rgb2gray(Image2); % Lena 

% Reduce resolution of images by factor of 4 using bilateral interpolation: imresize(___,method) 
ReducedImage1 = imresize(Image1, 0.25, 'bilinear'); % Cameraman reduced by factor of 4
ReducedImage2 = imresize(GreyImage2, 0.25, 'bilinear'); % Greyscale Lena reduced by factor of 4

% Plot reduced images by bilateral interpolation 
figure;
subplot(1,2,1), imshow(ReducedImage1);
title('Reduced Image 1: Cameraman');
subplot(1,2,2), imshow(ReducedImage2);
title('Reduced Image 2: Lena');

% Digital Zoom images back to original images using: 
% 1) Nearest Neighbour Interpolation 
% 2) Bilateral Interpolation 
% 3) Bicubic Interpolation 

% 1) Nearest Neighbour Interpolation:
NNImage1 = imresize(ReducedImage1, 4, 'nearest'); % Using a factor of 4 to make original 
NNImage2 = imresize(ReducedImage2, 4, 'nearest'); % Using a factor of 4 to make original 
figure;
imshow(NNImage1);
title('NN Interpolation of Cameraman');
figure;
imshow(NNImage2);
title('NN Interpolation of Lena');

% 2) Bilateral Interpolation 
BilateralImage1 = imresize(ReducedImage1, 4, 'bilinear'); % Using a factor of 4 to make original 
BilateralImage2 = imresize(ReducedImage2, 4, 'bilinear'); % Using a factor of 4 to make original 
figure;
imshow(BilateralImage1);
title('Bilateral Interpolation of Cameraman');
figure;
imshow(BilateralImage2);
title('Bilateral Interpolation of Lena');


% 3) Bicubic Interpolation 
BicubicImage1 = imresize(ReducedImage1, 4, 'bicubic'); % Using a factor of 4 to make original 
BicubicImage2 = imresize(ReducedImage2, 4, 'bicubic'); % Using a factor of 4 to make original 
figure;
imshow(BicubicImage1);
title('Bicubic Interpolation of Cameraman');
figure;
imshow(BicubicImage2);
title('Bicubic Interpolation of Lena');

% Compute PSNR:
% Nearest Neighbour: 
PSNR_out_NNImage1 = PSNR(Image1, NNImage1);
PSNR_out_NNImage2 = PSNR(GreyImage2, NNImage2);

% Bilateral: 
PSNR_out_BilateralImage1 = PSNR(Image1, BilateralImage1);
PSNR_out_BilateralImage2 = PSNR(GreyImage2, BilateralImage2);

% Bicubic: 
PSNR_out_BicubicImage1 = PSNR(Image1, BicubicImage1);
PSNR_out_BicubicImage2 = PSNR(GreyImage2, BicubicImage2);

%% Section 4 - Discrete Convolution for Image Processing 

% Normalize Grey-scale Lena image 
normalizedImage2 = double(GreyImage2)/255;

% 3 Impulse Functions 
h1 = (1/6)*ones(1,6);
h2 = h1';
h3 = [-1 1];

% Convolution with h1 
conv_h1 = conv2(normalizedImage2, h1);
figure;
imshow(normalizedImage2);
title('Normalized Lena');
figure;
imshow(conv_h1);
title('Convolution of Lena with h1');

% Convolution with h2
conv_h2 = conv2(normalizedImage2, h2);
figure;
imshow(normalizedImage2);
title('Normalized Lena');
figure;
imshow(conv_h2);
title('Convolution of Lena with h2');

% Convolution with h3
conv_h3 = conv2(normalizedImage2, h3);
figure;
imshow(normalizedImage2);
title('Normalized Lena');
figure;
imshow(conv_h3);
title('Convolution of Lena with h3');

%% Section 5 - Point Operations for Image Enhancement 

% Plot Tire image and corresponding Historgram 
figure; 
imshow(Image3);
title('Tire Image');
figure;
imhist(Image3);
title('Histogram of Tire Image');

% Plot negatively transformed Tire image and corresponding Histogram
negative_tire = 255 - Image3;
figure; 
imshow(negative_tire);
title('Negative Tire Image');
figure; 
imhist(negative_tire);
title('Histogram of Negative Tire Image');

% Two Power-law Transformation 
% Exponential = 0.5
exp_1 = 0.5;
power_transform_1 = (double(Image3)/255).^exp_1;
figure; 
imshow(power_transform_1);
title('Power-law (0.5) Tire Image');
figure; 
imhist(power_transform_1);
title('Histogram of Power-law (0.5) Tire Image');

% Exponential = 1.3
exp_2 = 1.3;
power_transform_2 = (double(Image3)/255).^exp_2;
figure; 
imshow(power_transform_2);
title('Power-law (1.3) Transformed Tire Image');
figure; 
imhist(power_transform_2);
title('Histogram of Power-law (1.3) Tire Image');

% Histogram Equalization 
figure; 
equalized_image = histeq(Image3);
imshow(equalized_image);
title('Equalized Image of Tire Image');
figure; 
imhist(histeq(Image3));
title('Equalized Histogram of Tire Image');