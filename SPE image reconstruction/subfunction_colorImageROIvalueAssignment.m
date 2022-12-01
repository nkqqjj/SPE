function [ret_n4] = subfunction_colorImageROIvalueAssignment(ret_n4,roi_mask)
%SUBFUNCTION_COLORIMAGEROIVALUEASSIGNMENT Summary of this function goes here
%   Detailed explanation goes here
        temp321 = ret_n4(:,:,1);temp321(not(roi_mask))=255;ret_n4(:,:,1)=temp321;
        temp321 = ret_n4(:,:,2);temp321(not(roi_mask))=255;ret_n4(:,:,2)=temp321;
        temp321 = ret_n4(:,:,3);temp321(not(roi_mask))=255;ret_n4(:,:,3)=temp321;
end

