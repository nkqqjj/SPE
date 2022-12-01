function [B11_3,B12_3,B21_3,B22_3] = PolarCamInterpolation(RAW_image)
%POLARCAMINTERPOLATION Summary of this function goes here
%   Detailed explanation goes here

%% padding the image
% four corner pixels
[mm, nn] = size(RAW_image);
RAW_padding = ones(mm+4,nn+4);
% first and second row/col
R12 = RAW_image(1:2,:); RAW_padding(1:2,3:end-2)=R12;
C12 = RAW_image(:,1:2); RAW_padding(3:end-2,1:2)=C12;
REnd = RAW_image(end-1:end,:); RAW_padding(end-1:end,3:end-2)=REnd;
CEnd = RAW_image(:,end-1:end); RAW_padding(3:end-2,end-1:end)=CEnd;
% four cornners
RAW_padding(1:2,1:2)= RAW_image(1:2,1:2);
RAW_padding(end-1:end,1:2)= RAW_image(end-1:end,1:2);
RAW_padding(1:2,end-1:end)= RAW_image(1:2,end-1:end);
RAW_padding(end-1:end,end-1:end)= RAW_image(end-1:end,end-1:end);
% central part
RAW_padding(3:end-2,3:end-2)= RAW_image;

%% interpolation
B11 = RAW_padding(1:2:end,1:2:end); B11_2 = interp2(single(B11),'linear'); B11_3 = (B11_2(3:end-1,3:end-1));
B12 = RAW_padding(1:2:end,2:2:end); B12_2 = interp2(single(B12),'linear'); B12_3 = (B12_2(3:end-1,4:end));
B21 = RAW_padding(2:2:end,1:2:end); B21_2 = interp2(single(B21),'linear'); B21_3 = (B21_2(4:end,3:end-1));
B22 = RAW_padding(2:2:end,2:2:end); B22_2 = interp2(single(B22),'linear'); B22_3 = (B22_2(4:end,4:end));

% img_merge = ones(mm,nn,4);
% img_merge(:,:,1) = B11_3;
% img_merge(:,:,2) = B12_3;
% img_merge(:,:,3) = B21_3;
% img_merge(:,:,4) = B22_3;




end

