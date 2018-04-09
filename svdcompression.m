%% SVD Compression
% written by Armaan Kohli 
% the following program uses Singular Value Decomposition (SVD) to preform 
%image compression on a grayscale and color image 

%% Gray Scale Image

image=imread('pout.tif');
imageD=double(image);

% decomposing the image via singular value decomposition
[U,S,V]=svd(imageD);

% constructing a compressed image using different numbers of singular
% values 

errmtx = [];
nums = [];
for N=5:10:300

    C = S;

    % remove non-diagonal entries 
    C(N+1:end,:)=0;
    C(:,N+1:end)=0;

    % Construct an Image using the selected singular values
    D=U*C*V';


    % display images and compute error
    figure;
    buffer = sprintf('Image output using %d singular values', N);
    imshow(uint8(D));
    title(buffer);
    error=sum(sum((imageD-D).^2));

    errmtx = [errmtx; error];
    nums = [nums; N];
end

%error plot
figure; 
title('Compression Error');
plot(nums, errmtx);
grid on
xlabel('Number of Singular Values Used');
ylabel('Error between Compressed and Original');

%% Color Image

% because the built-in SVD function does not accept 3-D matricies (ie.
% color images), we must first split the image into three channels

image = imread('autumn.tif');
imageD = double(image);

red = imageD(:,:,1); % Red channel
green = imageD(:,:,2); % Green channel
blue = imageD(:,:,3); % Blue channel
a = zeros(size(imageD, 1), size(imageD, 2));
redscale = cat(3, red, a, a);
greenscale = cat(3, a, green, a);
bluescale = cat(3, a, a, blue);

% decomposing each image channel using singular value decompostion
[Ur,Sr,Vr]=svd(red);
[Ub,Sb,Vb]=svd(blue);
[Ug,Sg,Vg]=svd(green);

% constructing a compressed image using different numbers of singular
% values 

errmtx = [];
nums = [];
for N=5:10:300
    
    C = Sr;
    E = Sb;
    G = Sg;
    
    % removing non-diagonal entries 
    C(N+1:end,:)=0;
    C(:,N+1:end)=0;
    E(N+1:end,:)=0;
    E(:,N+1:end)=0;
    G(N+1:end,:)=0;
    G(:,N+1:end)=0;
    
    % Construct each channel via SVD
    D=Ur*C*Vr';
    F=Ub*E*Vb';
    H=Ug*G*Vg';

    % reconstruct compressed image channels into the original image
    figure;
    buffer = sprintf('Image output using %d singular values', N);
    comp_img = cat(3, D, H, F);
    imshow(uint8(comp_img));
    title(buffer);
    error=sum(sum((imageD-comp_img).^2));
    fileinfo = dir(uint8(comp_img));
    filesize = fileinfo(1).bytes
    errmtx = [errmtx; error];
    nums = [nums; N];
end

% error plot
figure; 
title('Error in compression');
plot(nums, errmtx(:,1),'r', nums, errmtx(:,2),'g', nums, errmtx(:,3),'b')
grid on
xlabel('Number of Singular Values Used');
ylabel('Error between Compressed and Original');


