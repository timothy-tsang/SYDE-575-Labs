%% Section 1
degraded = imread('degraded.tif');
cameraman = imread('cameraman.tif');

figure;
imshow(degraded);
figure;
imshow(cameraman);

%% Section 2 - Image Restoration in the Frequency Domain

h = fspecial('disk',4);
f = im2double(imread('cameraman.tif'));
h_freq = fft2(h, size(f,1), size(f,2)); % pad h
f_blur = real(ifft2(h_freq.*fft2(f)));

figure;
imshow(f_blur);
title('Blurred Image');

% PSNR of blurred image
f_blur_psnr = 10*log10(1/mean2((f-f_blur).^2));

% Inverse Filter
inverseFilterImage = real(ifft2((fft2(f_blur)./h_freq)));
figure;
subplot(1,2,1);
imshow(inverseFilterImage);
title('Restored Image');

subplot(1,2,2);
imshow(cameraman);
title('Original Image');

% PSNR of Inverse Filtered image 
f_inverse_psnr = 10*log10(1/mean2((f-inverseFilterImage).^2));


% Image with Gaussian Noise
% Add Gaussian Noise
noiseyImage = imnoise(f_blur,'gaussian',0,0.002);
inverseFilterNoisyImage = real(ifft2((fft2(noiseyImage)./h_freq)));

figure;
imshow(inverseFilterNoisyImage);
title('Restored Image with Gaussian Noise');

figure;
imshow(noiseyImage);
title('Image with Gaussian Noise');

% PSNR of Noisy image and Restored image
f_noisy_image_psnr = 10*log10(1/mean2((f-noiseyImage).^2));
f_noisy_image_restored_psnr = 10*log10(1/mean2((f-inverseFilterNoisyImage).^2));

%%
% Apply Wiener Function
% https://www.mathworks.com/help/images/ref/deconvwnr.html
var_noise = 0.002;
var_f = var(noiseyImage(:));
nsr = var_noise/var_f;
nsr=0.09;
wienerFilter = deconvwnr(noiseyImage, h, nsr);

figure;
imshow(wienerFilter);
title('Wiener Filtered image');

% PSNR of Wiener Filtered Image
wiener_psnr = 10*log10(1/mean2((f-wienerFilter).^2));


%% Section 3 - Adaptive Filtering

d = im2double(imread('degraded.tif'));
figure;
imshow(d);
title('Degraded Figure');
rect = getrect; % [204,47,19,22]
% rect = [204,47,19,22];
d_rect = d(rect(1):rect(1)+rect(3), rect(2):rect(2)+rect(4));
var_rect = var(d_rect(:));

local_mean = colfilt(d, [5,5], 'sliding', @mean);
local_var = colfilt(d, [5,5], 'sliding', @var);

K = zeros(256,256);
Lee = zeros(256,256);

for i = 1:256
    for j = 1:256
        K(i,j) = (local_var(i,j)-var_rect)/local_var(i,j);
        Lee(i,j) = K(i,j)*d(i,j) + (1-K(i,j))*local_mean(i,j);
    end
end

% Plot
figure;
subplot(1,2,1);
imshow(d);
title('Degraded Figure');

subplot(1,2,2);
imshow(Lee);
title('Denoised image');

% PSNR 
lee_psnr = 10*log10(1/mean2((d-Lee).^2));

%%
% Low pass filter
gaussianFilterImage = imgaussfilt(d, 30);

% Plot
figure;
subplot(1,2,1);
imshow(Lee);
title('Denoised Image');

subplot(1,2,2);
imshow(gaussianFilterImage);
title('Gaussian LPF image');
