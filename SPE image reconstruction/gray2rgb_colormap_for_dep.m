function [out_rgb] = gray2rgb_colormap_for_dep(input_mat, colormap_str)
%GRAY2RGB_COLORMAP Summary of this function goes here
%   input_mat is a 2D matrix with real value, colormap_str is a string (e.g. hot(256), grray(256))
%   probably equivalent to the function ind2rgb

[mm, nn] = size(input_mat);
in_0to1 = im2uint8(mat2gray(input_mat,[0 1]));% normalize the input to 0-1, then further normalize to 0-255

out_rgb = ones(mm,nn,3);
cmap = eval(colormap_str);
for ii = 1:mm
    for jj = 1:nn
        out_rgb(ii,jj,:) = cmap(in_0to1(ii,jj)+1,:);
    end
end

end

