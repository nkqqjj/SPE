% ret script --------------------------------------
transparency_value = 0.85;

if strcmp(mode, 'ret')
    
    mask_color = [69 28];% mask is green,with transparency 60% (assigned in MS PPT, then screen capture, then read ), g channel is 69, b channel is 28;
    
    for img_number = f_1:f_2
        % load data
        filename = [filename_prefix, num2str(img_number)];
        [ intensity_FFC,specular_mask, dark_mask, ret, dep, opi ] = ReadPolarGeneral2( path, filename, mode, threshold_highlight,threshold_underexposed);
        [ intensity,~, ~, ~, ~, opi ] = ReadPolarGeneral3_noFFC( path, filename, mode, threshold_highlight,threshold_underexposed);


        %mat2gray, normlize to 0-1
        ret_n0 = ret./intensity_FFC;
        ret_n = mat2gray(ret_n0, range_ret_dep);
       
        intensity0 = double(intensity)./255;
        intensity0 = gamma_corr(intensity0, gamma_value);
        intensity0 = imsharpen(intensity0, 'Radius',sharpenning_parameters(1),'Amount',sharpenning_parameters(2));
        

        % ind2rgb
        ret_n1 = gray2rgb_colormap(ret_n,'hot(256)');%ret_n1 = gamma_corr(ret_n1, 2);
        intensity1 = gray2rgb_colormap(intensity0,'gray(256)');
        
        % the following two lines are to generate uncropped images for roi drawing
        %imwrite(ret_n1,['D:\UCL\invivo paper\Invivo ENT matlab\PolarCam Preprocessing\phantom validation results\mouth2_2\ret\for roi drawing','\ret_',num2str(img_number),'.png'])
        %imwrite(intensity1,['D:\UCL\invivo paper\Invivo ENT matlab\PolarCam Preprocessing\phantom validation results\mouth2_2\ret\for roi drawing','\int_',num2str(img_number),'.png'])
        

        % apply specular mask
        if mask_badAreas_ornot == 1
            [dark_mask2] = SmoothMask(dark_mask);
            [specular_mask2] = SmoothMask(specular_mask);
            mask_badarea = or(specular_mask2,dark_mask2);
            edge_badarea = mark_specular_fun(mask_badarea);
            ret_n2 = imoverlay(ret_n1,edge_badarea, [0 1 0]);

            temp =ret_n2(:,:,2);  temp(mask_badarea) = mask_color(1); ret_n2(:,:,2) = temp;
            temp =ret_n2(:,:,3);  temp(mask_badarea) = mask_color(2); ret_n2(:,:,3) = temp;

            temp =ret_n2(:,:,1);  temp(edge_badarea) = 6; ret_n2(:,:,1) = temp;
            temp =ret_n2(:,:,2);  temp(edge_badarea) = 70; ret_n2(:,:,2) = temp;
            temp =ret_n2(:,:,3);  temp(edge_badarea) = 0; ret_n2(:,:,3) = temp;
            %figure(1);imshow(ret_n2);

            intensity2 = imoverlay(intensity1, mask_badarea, [0 1 0],0.93);
            intensity2 = imoverlay(intensity2, edge_badarea, [0 1 0],transparency_value);
            %figure(2);imshow(intensity2);
        else
            ret_n2 = ret_n1;
            intensity2 = intensity1;

        end

        % FOV mask
        mask = createCirclesMask(ret_n2(:,:,1),centre_coord,radius);
        ret_n3 = ret_n2;
        intensity3 = intensity2;
        NaN_value = 0;%%%%need to specify
        for ii = 1:3
            temp1 = ret_n2(:,:,ii);
            temp1(not(mask)) = NaN_value;
            ret_n3(:,:,ii)= temp1;
            temp2 = intensity2(:,:,ii);
            temp2(not(mask)) = NaN_value;
            intensity3(:,:,ii) = temp2;
        end


        % crop and generate figure
        if centre_coord(2)+radius > size(intensity3,1)
            xlimvalue = size(intensity3,1);
        else
            xlimvalue = centre_coord(2)+radius;
        end
        if centre_coord(1)+radius > size(intensity3,2)
            ylimvalue = size(intensity3,2);
        else
            ylimvalue = centre_coord(1)+radius;
        end
        if centre_coord(2)-radius <= 0
            xlimvalue_min = 1;
        else
            xlimvalue_min = centre_coord(2)-radius;
        end
        if centre_coord(1)-radius <= 0
            ylimvalue_min = 1;
        else
            ylimvalue_min = centre_coord(1)-radius;
        end


        img2write1 = intensity3(xlimvalue_min:xlimvalue,ylimvalue_min:ylimvalue,:);
        intensity3_roi = intensity(xlimvalue_min:xlimvalue,ylimvalue_min:ylimvalue);
        figure(1);imshow(img2write1);
        imwrite(img2write1,[path2write,'/',mode,num2str(img_number), '_intensity_',sample_name,'.png']);
        
        img2write2 = ret_n3(xlimvalue_min:xlimvalue,ylimvalue_min:ylimvalue,:);
        figure(2);imshow(img2write2);
        ret_n0_roi = ret_n0(xlimvalue_min:xlimvalue,ylimvalue_min:ylimvalue);
        ret_n3_roi = ret_n3(xlimvalue_min:xlimvalue,ylimvalue_min:ylimvalue,:);
        imwrite(img2write2,[path2write,'/',mode, num2str(img_number), '_ret_',sample_name,'.png']);
        
                
        subfunction_subplot_generation(mode,range_ret_dep, img2write1,img2write2);        
        print(gcf,[path2write,'/combine_',mode, num2str(img_number), '_ret_',sample_name,'.png'],'-dpng','-r600');
    end

end

% dep script --------------------------------------------
if strcmp(mode, 'dep')
    
    for img_number = f_1:f_2

        % load data
        filename = [filename_prefix, num2str(img_number)];
        [ intensity_FFC,specular_mask, dark_mask, ret, dep, opi ] = ReadPolarGeneral2( path, filename, mode, threshold_highlight,threshold_underexposed);
        [ intensity,~, ~, ~, ~, opi ] = ReadPolarGeneral3_noFFC( path, filename, mode, threshold_highlight,threshold_underexposed);

        %mat2gray, normalize to 0-1
        dep0 = abs(dep)./intensity_FFC;
        intensity0 = double(intensity)./255;
        intensity0 = gamma_corr(intensity0, gamma_value);
        opi0 = double(opi)./255;
        opi0 = gamma_corr(opi0, gamma_value);

        % ind2rgb
        dep1 = mat2gray(dep0,range_ret_dep);
        dep2 = gray2rgb_colormap_for_dep(dep1,'gray(256)');
        intensity2 = gray2rgb_colormap(intensity0,'gray(256)');
        opi2 = gray2rgb_colormap(opi0,'gray(256)');
        
        % the following two lines are to generate uncropped images for roi drawing
        %imwrite(dep2,['D:\UCL\invivo paper\Invivo ENT matlab\PolarCam Preprocessing\phantom validation results\mouth2_2\dep\for roi drawing','\dep_',num2str(img_number),'.png'])
        %imwrite(intensity2,['D:\UCL\invivo paper\Invivo ENT matlab\PolarCam Preprocessing\phantom validation results\mouth2_2\dep\for roi drawing','\int_',num2str(img_number),'.png'])
        

        % apply specular and dark area mask 
        if mask_badAreas_ornot == 1
            [dark_mask2] = SmoothMask(dark_mask);
            [specular_mask2] = SmoothMask(specular_mask);
            mask_badarea = or(specular_mask2,dark_mask2);
            edge_badarea = mark_specular_fun(mask_badarea);
            edge_dark_mask2 = mark_specular_fun(dark_mask2);

            dep2 = imoverlay(dep2, mask_badarea, [0 1 0],0.93);
            dep2 = imoverlay(dep2, edge_badarea, [0 1 0],transparency_value);
            opi2 = imoverlay(opi2, dark_mask2, [0 1 0],0.93);
            opi2 = imoverlay(opi2, edge_dark_mask2, [0 1 0],transparency_value);
            intensity2 = imoverlay(intensity2, mask_badarea, [0 1 0],0.93);
            intensity2 = imoverlay(intensity2, edge_badarea, [0 1 0],transparency_value);
        end
            
            
%figure(1);imshow(ret_n2);



        % FOV mask
        mask = createCirclesMask(dep,centre_coord,radius);
        dep3 = dep2;
        intensity3 = intensity2;
        opi3 = opi2;
        NaN_value = 0; % need to specify
        for ii = 1:3
            temp1 = dep2(:,:,ii);
            temp1(not(mask)) = NaN_value;
            dep3(:,:,ii)= temp1;
            temp2 = intensity2(:,:,ii);
            temp2(not(mask)) = NaN_value;
            intensity3(:,:,ii) = temp2;
            temp3 = opi2(:,:,ii);
            temp3(not(mask)) = NaN_value;
            opi3(:,:,ii) = temp3;
        end
%imshow(dep3);
%imagesc(dep0);


        % generate figure
        % crop and generate figure
        if centre_coord(2)+radius > size(intensity3,1)
            xlimvalue = size(intensity3,1);
        else
            xlimvalue = centre_coord(2)+radius;
        end
        if centre_coord(1)+radius > size(intensity3,2)
            ylimvalue = size(intensity3,2);
        else
            ylimvalue = centre_coord(1)+radius;
        end
        if centre_coord(2)-radius <= 0
            xlimvalue_min = 1;
        else
            xlimvalue_min = centre_coord(2)-radius;
        end
        if centre_coord(1)-radius <= 0
            ylimvalue_min = 0;
        else
            ylimvalue_min = centre_coord(1)-radius;
        end
    
   
        img2write1 = intensity3(xlimvalue_min:xlimvalue,ylimvalue_min:ylimvalue,:);
        intensity3_roi = intensity(xlimvalue_min:xlimvalue,ylimvalue_min:ylimvalue);
        figure(1);imshow(img2write1);
        imwrite(img2write1,[path2write,'/',mode,num2str(img_number), '_intensity_',sample_name,'.png']);

        img2write2 = dep3(xlimvalue_min:xlimvalue,ylimvalue_min:ylimvalue,:);
        figure(2);imshow(img2write2);
        dep0_roi = dep0(xlimvalue_min:xlimvalue,ylimvalue_min:ylimvalue);
        imwrite(img2write2,[path2write,'/',mode, num2str(img_number), '_dep_',sample_name,'.png']);
        
        img2write3 = opi3(xlimvalue_min:xlimvalue,ylimvalue_min:ylimvalue,:);
        figure(2);imshow(img2write3);
        opi0_roi = opi0(xlimvalue_min:xlimvalue,ylimvalue_min:ylimvalue);
        imwrite(img2write3,[path2write,'/',mode, num2str(img_number), '_opi_',sample_name,'.png']);
        
        %subfunction_subplot_generation(mode,range_ret_dep, img2write1,img2write2, img2write3);        
        %print(gcf,[path2write,'/1combine_',mode, num2str(img_number), '',sample_name,'.png'],'-dpng','-r600');
        
        subfunction_subplot_generation2('dep',range_ret_dep, img2write1,img2write2);        
        print(gcf,[path2write,'/2combine_',mode, num2str(img_number), '',sample_name,'.png'],'-dpng','-r600');
        
    end

end
    