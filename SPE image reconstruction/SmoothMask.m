function [dark_mask2] = SmoothMask(dark_mask)
%CREATEUNDEREXPOSEMASK morphorlogica operation to make the boundary clearer
%   Detailed explanation goes here

windowSize = 12;
kernel = ones(windowSize) / windowSize ^ 2;
blurryImage = conv2(single(dark_mask), kernel, 'same');
dark_mask2 = blurryImage > 0.5; % Rethreshold

end

