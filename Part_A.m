% CS-867 COMPUTER VISION
% ASSIGNMENT-1, PART-A
% HARRIS KEYPOINT DETECTOR

% Read given images
im1 = imread('famous_five.png');
im2 = imread('mausoleum.jpg');
harris(im1);
harris(im2);
function harris(image)
% Displaying given image
figure; 
imshow(image);
title('GIVEN IMAGE');

% Converting given RGB image to GRAYSCALE
im = rgb2gray(image);
% Displaying GRAYSCALE image
figure;
imshow(im);
title('GRAYSCALE IMAGE');

% Finding Horizontal & Vertical Gradient of GRAYSCALE image
[dx,dy]=meshgrid(-1:1, -1:1);
ix = conv2(double(im),dx,'same');
% Displaying Horizontal gradient/ Vertical Edge
figure; imshow(ix);
title('HORIZONTAL GRADIENT, Ix');
iy = conv2(double(im),dy,'same');
% Displaying Vertical gradient/ Horizontal Edge
figure; imshow(iy); title('VERTICAL GRADIENT, Iy');

% PARAMETERS FOR GAUSSIAN FILTER
sigma = 3;
radius=1;
order = (2*radius+1)^2;


% DEFINING GAUSSIAN FILTER
len = max(1,fix(6*sigma));
p=len; q=len;
[u1,u2]=meshgrid(-(p-1)/2:(p-1)/2, -(q-1)/2: (q-2)/2);
ug = exp(-(u1.^2+u2.^2)/(2*sigma^2));
[w,z] = size(ug);
sum = 0;
for i=1:w
    for j=1:z
        sum = sum+ug(i,j);
    end
end
G = ug ./sum;

% COMPUTING ELEMENTS OF SECOND MOMENT MATRIX, M
Ix2 = conv2(double(ix.^2),G,'same');
Iy2 = conv2(double(iy.^2),G,'same');
Ixy = conv2(double(ix.*iy),G,'same');

% CORNERNESS MEASURE
r = (Ix2.*Iy2 - Ixy.^2)./(Ix2+Iy2 + eps);

% Value of Threshold set empirically 
threshold = 4000;
% FINDING MAX POINT FOR NON-MAX SUPPRESSSION
maximum_point = ordfilt2(r, order^2,ones(order));

% FINDING CORNERS
harris_corners = (r==maximum_point) & (r>threshold);
[R,C]=find(harris_corners);
figure,imshow(im),hold on,
plot(C,R,'yp','MarkerFaceColor','y'), 
title('CORNERS DETECTED BY HARRIS');
end



