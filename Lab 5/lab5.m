%% Section 1
lena = imread('lena.tiff');
peppers = imread('peppers.png');
 
figure;
imshow(lena);
figure;
imshow(peppers);
 
%% Section 2 - Chroma Subsampling
ycbcr_peppers = rgb2ycbcr(peppers);
Y = ycbcr_peppers(:,:,1);
Cb = ycbcr_peppers(:,:,2);
Cr = ycbcr_peppers(:,:,3);
 
figure;
subplot(2,2,1);
imshow(peppers);
title('Original peppers');
 
subplot(2,2,2);
imshow(Y);
title('Y channel');
 
subplot(2,2,3);
imshow(Cb);
title('Cb channel');
 
subplot(2,2,4);
imshow(Cr);
title('Cr channel');
 
% Reduce resolution of Cr by 2 
reduced_cr = imresize(Cr, 0.5);
upscale_cr = imresize(reduced_cr, 2, 'bilinear');
 
% Reduce resolution of Cr by 2 
reduced_cb = imresize(Cb, 0.5);
upscale_cb = imresize(reduced_cb, 2, 'bilinear');
 
ycbcr_upscale = ycbcr_peppers;
ycbcr_upscale(:,:,2) = upscale_cb;
ycbcr_upscale(:,:,3) = upscale_cr;
 
recombined_upscale = ycbcr2rgb(ycbcr_upscale);
 
figure;
subplot(1,2,1);
imshow(recombined_upscale);
title('Reduced CbCr combined with original Y');
subplot(1,2,2);
imshow(peppers);
title('original');
 
% Reduce resolution of Cr by 2 
reduced_y = imresize(Y, 0.5);
upscale_y = imresize(reduced_y, 2, 'bilinear');
 
ycbcr_upscale(:,:,1) = upscale_y;
recombined_upscale = ycbcr2rgb(ycbcr_upscale);
 
figure;
subplot(1,2,1);
imshow(recombined_upscale);
title('Reduced Y combined with original CbCr');
subplot(1,2,2);
imshow(peppers);
title('original');
 

%% Section 3: Colour Segmentation
 
C = makecform('srgb2lab');
converted_pepper = applycform(peppers,C);
 
ab = double(converted_pepper(:,:,2:3)); % NOT im2double
m = size(ab,1);
n = size(ab,2);
ab = reshape(ab,m*n,2);
 
K = 2;
row = [55 200];
col = [155 400];
mu = zeros(2,2);
% K = 4;
% row = [55 130 200 280];
% col = [155 110 400 470];
% mu = zeros(4,2);
% Convert (r,c) indexing to 1D linear indexing.
idx = sub2ind([size(converted_pepper,1) size(converted_pepper,2)], row, col);
% Vectorize starting coordinates
for k = 1:K
    mu(k,:) = ab(idx(k),:);
end
 
cluster_idx = kmeans(ab, K, 'start', mu);
 
% Label each pixel according to k-means
pixel_labels = reshape(cluster_idx, m, n);
figure;
imshow(pixel_labels, []);
title('Image labeled by cluster index, K=2');
colormap('jet');

mask = repmat(pixel_labels, [1,1,3]);
clustered_peppers = peppers;
 
figure;
for k = 1:K
    temp = uint8(mask(:,:,1) == k);
    clustered_peppers(:,:,1) = peppers(:,:,1).*temp;
    clustered_peppers(:,:,2) = peppers(:,:,2).*temp;
    clustered_peppers(:,:,3) = peppers(:,:,3).*temp;
    subplot(2,2,k);
    imshow(clustered_peppers);
    title(sprintf('Segmented region %d',k));
end
 
%% Section 4 
gLena = double(rgb2gray(lena));
 
T = dctmtx(8);
% dct = D*gLena*D';
 
figure;
imshow(T);
title('8X8 DCT matrix');
 
% Apply transformation
F_trans = floor(blockproc(gLena-128, [8 8], @(x) T*x.data*T'));
 
figure;
imshow(F_trans(297:304, 81:88));
title('8x8 F_trans at 297,81');
 
figure;
imshow(F_trans(1:8, 1:8));
title('8x8 F_trans at 1,1');
 
 
% Threshold 
mask = [1 1 1 0 0 0 0 0;
1 1 0 0 0 0 0 0;
1 0 0 0 0 0 0 0;
0 0 0 0 0 0 0 0;
0 0 0 0 0 0 0 0;
0 0 0 0 0 0 0 0;
0 0 0 0 0 0 0 0;
0 0 0 0 0 0 0 0];
F_thresh = blockproc(F_trans, [8 8], @(x) mask.*x.data);
 
f_thresh = floor(blockproc(F_thresh, [8 8], @(x) T'*x.data*T)) + 128;
 
figure;
imshow(f_thresh, []);
title('Final output after DCT transform');
 
lena_psnr = 10*log10(1/mean2((gLena-f_thresh).^2));
 
%% Section 5 - Quantization
gLena = im2double(rgb2gray(lena));
 
Z = [16 11 10 16 24 40 51 61;
12 12 14 19 26 58 60 55;
14 13 16 24 40 57 69 56;
14 17 22 29 51 87 80 62;
18 22 37 56 68 109 103 77;
24 35 55 64 81 104 113 92;
49 64 78 87 103 121 120 101;
72 92 95 98 112 100 103 99];
 
for i = [1,3,5,10]
    F_thresh = blockproc(F_trans, [8 8], @(x) round(x.data./(Z*i)));
 
    f_thresh = floor(blockproc(F_thresh, [8 8], @(x) T'*(x.data.*(Z*i))*T)) + 128;
 
    figure;
    imshow(f_thresh, []);
    title(sprintf('Quantized image with Z*%d', i));
end
