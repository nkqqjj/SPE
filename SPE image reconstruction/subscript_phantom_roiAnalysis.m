% ROI example generation


dim1 = size(ROI_database,1);
mean_array_RET = ones(1,dim1);
mean_array_INTENSITY = ones(1,dim1);


for ii = 1: dim1
    Position_mat = ROI_database(ii,:); 
    %ret value analysis
    roi = ret_n0_roi(Position_mat(2):(Position_mat(2)+Position_mat(3)),Position_mat(1):(Position_mat(1)+Position_mat(4)));
    mean_array_RET(ii) = mean2(roi);std_array_RET(ii) = std2(roi);
    roi_hot = ret_n3_roi(Position_mat(2):(Position_mat(2)+Position_mat(3)),Position_mat(1):(Position_mat(1)+Position_mat(4)),:);
    imshow(roi_hot);
    imwrite(roi_hot,[path2write,'/',sample_name, '_retROI',num2str(ii),'.png']);
    %intensity value analysis
    roi = intensity3_roi(Position_mat(2):(Position_mat(2)+Position_mat(3)),Position_mat(1):(Position_mat(1)+Position_mat(4)));
    mean_array_INTENSITY(ii) = mean2(roi);std_array_INTENSITY(ii) = std2(roi);
    imshow(roi);
    imwrite(roi,[path2write,'/',sample_name, '_intensityROI',num2str(ii),'.png']);
    
end

temp_to_save = double(cat(1,mean_array_RET,std_array_RET));
save([path2write,'/',sample_name, '_retROI',num2str(ii),'.dat'],'temp_to_save','-ascii');%mean and std of each roi
temp_to_save = cat(1,mean_array_INTENSITY,std_array_INTENSITY);
save([path2write,'/',sample_name, '_intROI',num2str(ii),'.dat'],'temp_to_save','-ascii');%mean and std of each roi

% ret with roi rects
fh = figure;
imshow(ret_n3_roi);
for ii = 1: dim1
    Position_mat = ROI_database(ii,:);
    rectangle('Position',Position_mat,'Curvature',0,'EdgeColor','b','LineWidth',0.5);
end

frm = getframe( fh ); %// get the image+rectangle
imwrite( frm.cdata, [path2write,'/',sample_name, '_ret_imgwithRect.png'] ); %// save to file
% intensity with roi rects
fh = figure;
imshow(intensity3(xlimvalue_min:xlimvalue,ylimvalue_min:ylimvalue,:));
for ii = 1: dim1
    Position_mat = ROI_database(ii,:);
    rectangle('Position',Position_mat,'Curvature',0,'EdgeColor','b','LineWidth',0.5);
end

frm = getframe( fh ); %// get the image+rectangle
imwrite( frm.cdata, [path2write,'/',sample_name, '_intensity_imgwithRect.png'] ); %// save to file


% line plot
position_to_plot = ROI_database(1,2):(ROI_database(1,2)+ROI_database(1,3));
fig = figure;
left_color = [0.1 0.1 0.1];
right_color = [0 .1 .9];
set(fig,'defaultAxesColorOrder',[left_color; right_color]);
yyaxis left; plot(mean(ret_n0_roi(position_to_plot,50:1050),1));
yyaxis right; plot(mean(intensity3_roi(position_to_plot,50:1050),1));

raw_profile_data_fig2_ret = mean(ret_n0_roi(position_to_plot,:),1);
raw_profile_data_fig2_int = mean(intensity3_roi(position_to_plot,:),1);


% stats
% xx1 = double(imread([path2write,'/',sample_name, '_intensityROI',num2str(1),'.png']));
% xx2 = double(imread([path2write,'/',sample_name, '_intensityROI',num2str(2),'.png']));
% kstest(xx1(:))
% [p,h] = ranksum(xx1(:),xx2(:))





    