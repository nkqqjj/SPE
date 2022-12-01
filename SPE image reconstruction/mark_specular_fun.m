function [ BW4 ] = mark_specular_fun( BW1 )
%HH is co-polarised image, Intensity is m00 image
%   BW1 is the mask, img is to be overlayed

%%%Detect saturated pixels


%%%Dilate BW1
se2 = strel('square',4);
%BW2 = imdilate(BW1,se2); 

%%%edge detection
BW3 = edge(BW1,'sobel');
BW3=imclose(BW3,se2);%close the inner circle
se = strel('square',3);%define line width
BW4 = imdilate(BW3,se);



%%%overlay
%AA=imoverlay(Intensity, BW4, [0 1 0]);
%imshow(AA);
end

