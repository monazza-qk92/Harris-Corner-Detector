
% CS-867 COMPUTER VISION
% ASSIGNMENT-1,PART-C
% ROBUSTNESS OF HARRIS KEYPOINT DETECTOR TO SCALING 

OimageI = imread('famous_five.png');
scale_eff(OimageI);
function scale_eff(Oimagek)
[Orows,Ocols] = harris(Oimagek);
 Ocpoints = [Orows,Ocols];
for sfp=0:1:8  % RANGE OF SCALING FACTOR FROM 0 TO 8
    sf=(1.2)^sfp; %SCALING FACTOR FOR IMAGE
    Rimage1 = imresize(Oimagek,sf); %RESIZE IMAGE WITH SCALE FACTOR
    [Rrows,Rcols] = harris(Rimage1);
    Rcpoints = [Rrows,Rcols]; 
    thresh = 100;
    Ocpointssize = length(Ocpoints);
    N=length(Ocpoints);  % HARRIS CORNERS IN ORIGINAL IMAGE
    rot_ang=15*pi/180; % ROTATION ANGLE FOR IMAGE
    % TRANSFORMATION MATRIX FOR ROTATION OF KEYPOINT 
    RotMatrix = [cosd(rot_ang) -sind(rot_ang);sind(rot_ang) cosd(rot_ang)];
    % RETURNS THE CENTER OF ORIGINAL IMAGE(GRAYSCALE)
    CenterO = (size(rgb2gray(Oimagek))/2)';
    % RETURNS THE CENTER OF ROTATED IMAGE(GRAYSCALE)
    CenterR = (size(rgb2gray(Rimage1))/2)';
    M=0; % COUNT OF MATCHED CORNERS
    
    
    % PREDICTING IDEAL POSITION OF KEYPOINT
for i=1:1:Ocpointssize
    % KEYPOINT ROTATED BY TRANSFORMATION MATRIX
    RotatedP = RotMatrix*((Ocpoints(i))'-CenterO)+CenterR;
    % EUCLIDEAN DISTANCE BTW TRANSFORMED & ROTATED IMAGE KEYPOINT
    Euc_D = sqrt(sum((Rcpoints(i)-RotatedP).^2));
    if(Euc_D<thresh) % IF DISTANCE LESS THAN THRESHOLD, THEN
    M=M+1; % INCREMENT IN COUNT OF MATCHED KEYPOINTS
    end
end
% REPEATABILITY MEASURE, RATIO OF MATCHED CORNERS TO ORIGINAL CORNERS
rep=M/N;
figure,imshow(Rimage1),hold on,
    plot(Rcols,Rrows,'yp','MarkerFaceColor','y','MarkerSize',15),title(['RESIZED IMAGE WITH m^',num2str(sfp),',  M =',num2str(M),' & N =',num2str(N),'  REPEATABILITY FACTOR,M/N =',num2str(rep)]);
end
end

% HARRIS KEYPOINT DETECTOR AS IN PART-A
function [R,C] = harris(image)   
im = rgb2gray(image);  % CONVERTING GIVEN IMAGE FROM RGB TO GRAYSCALE
[dx,dy]=meshgrid(-1:1, -1:1);
ix = conv2(double(im),dx,'same'); % HORIZONTAL GRADIENT / VERTICAL EDGES
iy = conv2(double(im),dy,'same'); % VERTICAL GRADIENT / HORIZONTAL EDGES

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

% FINFDING MAX POINT FOR NON-MAX SUPPRESSSION
maximum_point = ordfilt2(r, order^2,ones(order));

% FINDING CORNERS
harris_corners = (r==maximum_point) & (r>threshold);
[R,C]=find(harris_corners);
end

