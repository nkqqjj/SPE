function rect_roi = subfunction_cropImageRectfromROImask(mask)
%SUBFUNCTION_CROPIMAGERECTFROMROIMASK Summary of this function goes here
%   Detailed explanation goes here
        roi_mask_sum_col = sum(mask,1);roi_mask_sum_row = sum(mask,2);
        ind1 = find(roi_mask_sum_col>=1, 1, 'first');ind2 = find(roi_mask_sum_col>=1, 1, 'last');
        ind3 = find(roi_mask_sum_row>=1, 1, 'first');ind4 = find(roi_mask_sum_row>=1, 1, 'last');
        rect_roi =  [ind1,ind3,ind2-ind1,ind4-ind3];
end

