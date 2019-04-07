%% Section 1
cameraman = imread('cameraman.tif');
mandrill = imread('mandrill.png');
frequnoisy = imread('frequnoisy.tif');

%% Section 2

f = zeros(256,256);
f(:,108:148)=1;

% Plot test image 
figure;
subplot(1,2,1);
imshow(f);
title('Test Image');

% Fourier Transform & Spectra of f
ft_f = fft2(f);
shift_ft = fftshift(abs(ft_f));
subplot(1,2,2);
imshow(shift_ft, []);
title('Spectra of Test Image');

% Rotate 45 degrees 
angle = 45;
rotated_image = imrotate(f, angle);
figure;
subplot(1,2,1);
imshow(rotated_image, []);
title('Rotated test image');

% Fourier Transform & Spectra of rotated f 
ft_f_rotate = fft2(rotated_image);
shift_ft_rotate = fftshift(abs(ft_f_rotate));
subplot(1,2,2);
imshow(shift_ft_rotate, []);
title('Spectra of Rotated Image'); 

% Amplitude and Phase of Mandrill
rgb_mandrill = rgb2gray(mandrill);
figure;
subplot(1,2,1);
imshow(mandrill);
title('Original Mandrill Image');

ft_mandrill = fft2(rgb_mandrill);
ft_mandrill_shift = fftshift(ft_mandrill);
mandrill_amplitude = abs(ft_mandrill_shift);
mandrill_phase = ft_mandrill_shift./mandrill_amplitude;

% Inverse FT
ift_amplitude = ifft2(mandrill_amplitude);
ift_phase = ifft2(mandrill_phase);

% Plot original image, reconstructed image using amplitude and phase
% separately 
subplot(1,2,2);
imshow(rgb_mandrill);
title('grayscale mandril');

figure;
subplot(1,2,1);
imshow(mandrill_amplitude, []);
title('Amplitude');

subplot(1,2,2);
imshow(mandrill_phase, []);
title('Phase');

figure;
subplot(1,2,1);
imshow(ift_amplitude, []);
title('Reconstructued Image using Amplitude');

subplot(1,2,2);
imshow(ift_phase, []);
title('Reconstructued Image using Phase');

%% Section 3

% Used to test the cameraman image instead of the mandrill image
% This is b/c ringing is seen more in the cameraman image
% rgb_mandrill = cameraman;

intensities = im2double(rgb_mandrill);
noisy_image = imnoise(intensities,'gaussian', 0, 0.005);
figure;
subplot(1,2,1);
imshow(intensities, []);
title('Original Image');
subplot(1,2,2);
imshow(noisy_image, []);
title('Noisy Image');

% Fourier Spectra 
ft_original = log(fftshift(abs(fft2(intensities))));
figure;
subplot(1,2,1);
imshow(ft_original, []);
title('Log Fourier Spectra of Original Image');

ft_noise = fft2(noisy_image);
shift_ft = log(fftshift(abs(ft_noise)));
subplot(1,2,2);
imshow(shift_ft, []);
title('Log Fourier Spectra of Noisy Image');

% Low Pass Filter
r = 60;
h = fspecial('disk',r); h(h > 0)=1;
h_freq = zeros(512,512);
h_freq(512/2-r:512/2+r,512/2-r:512/2+r)=h;
% h_freq = zeros(256,256);
% h_freq(256/2-r:256/2+r,256/2-r:256/2+r)=h;

% Fourier Spectra of the LFP 
ft_lpf_shift = h_freq; % Already in the frequency domain!
figure;
subplot(1,2,1);
imshow(ft_lpf_shift, []);
title('Fourier Spectra of LFP with Radius 60');

% Apply filter onto noisy image 
mandrill_filter = fftshift(ft_noise).*ft_lpf_shift;

% Inverse FT on filtered noisy image
ift_mandrill = ifft2(ifftshift(mandrill_filter));

% Plot the images 
subplot(1,2,2);
imshow(ift_mandrill,[]);
title('Inverse FT of Filtered Noisy Image with radius 60');

% PSNR
mandrill_psnr_60 = 10*log10(1/mean2((intensities-mat2gray(abs(ift_mandrill))).^2));

% Low Pass Filter with radius of 20 
r = 20;
h = fspecial('disk',r); h(h > 0)=1;
h_freq = zeros(512,512);
h_freq(512/2-r:512/2+r,512/2-r:512/2+r)=h;
% h_freq = zeros(256,256);
% h_freq(256/2-r:256/2+r,256/2-r:256/2+r)=h;

% Fourier Spectra of the LFP 
ft_lpf_shift = h_freq; % Already in the frequency domain!
figure;
subplot(1,2,1);
imshow(ft_lpf_shift, []);
title('Fourier Spectra of LFP with Radius 20');

% Apply filter onto noisy image 
mandrill_filter = fftshift(ft_noise).*ft_lpf_shift;

% Inverse FT on filtered noisy image
ift_mandrill = ifft2(ifftshift(mandrill_filter));

% Plot the images 
subplot(1,2,2);
imshow(ift_mandrill,[]);
title('Inverse FT of Filtered Noisy Image with radius 20');

% PSNR
mandrill_psnr_20 = 10*log10(1/mean2((intensities-mat2gray(abs(ift_mandrill))).^2));

%%

% Gaussian Filter
gaussian_filter = fspecial('gaussian',512,60);
gaussian_filter = gaussian_filter./max(max(gaussian_filter));
figure;
imshow(gaussian_filter);
title('Gaussian Filter');

% Fourier Transform the Filter
ft_gaussian = fft2(gaussian_filter);
ft_gaussian_shift = fftshift(abs(ft_gaussian));
figure;
subplot(1,2,1);
imshow(ft_gaussian_shift, []);
title('Fourier Spectra of Gaussian');

% Apply filter onto noisy image 
mandrill_gaussian_filter = fftshift(ft_noise).*ft_gaussian_shift;

% Inverse FT on filtered noisy image
ift_mandrill = ifft2(ifftshift(mandrill_gaussian_filter));

% Plot the images 
subplot(1,2,2);
imshow(ift_mandrill,[]);
title('Inverse FT of Gaussian Filtered Noisy Image');

% PSNR
mandrill_psnr_gaussian = 10*log10(1/mean2((intensities-mat2gray(ift_mandrill)).^2));

%% Section 4

figure;
subplot(1,2,1);
imshow(frequnoisy);
title('Frequnoisy image');

ft_image = fft2(frequnoisy);
ft_shift = log(fftshift(abs(ft_image)));
subplot(1,2,2);
imshow(ft_shift, []);
title('Fourier Spectrum of Frequnoisy');

% delete points at (65,65), (105,119), (153, 139), (193, 193)
ft_image(65,65)=0;
ft_image(119,105)=0; % Flip
ft_image(139,153)=0; % Flip 
ft_image(193,193)=0;

% ft_shift = log(fftshift(abs(ft_image)));
% figure;
% % subplot(1,2,1);
% imshow(ft_shift, []);
% title('Filtered FFT');

% new_image = ft_shift*fftshift(ft_shift);

final = ifft2((ft_image));
figure;
% % subplot(1,2,2);
imshow(final, []);
title('Final Filtered Image');