function [] = subfunction_subplot_ret_generation(mode,range_ret_dep, img2write1,img2write2)
%SUBFUNCTION_SUBPLOT_GENERATION Summary of this function goes here
%   This func can generate subplot with one of the subimg + colorbar,
%   at the same time not shrink the subimg size
fontSize = 16;

if strcmp(mode,'ret')

    % Put up a plot in the first position
    h1 = subplot(1,2,1);
    imshow(img2write1);title('Intensity reference','FontSize', fontSize);

    % Get the current axis size
    originalSize1 = get(gca, 'Position');
    % Put up an image in the second position
    h2 = subplot(1, 2, 2);
    imshow(img2write2);title('Retardance Image','FontSize', fontSize); 

    % Enlarge figure to full screen.
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]); % Maximize figure.
    %set(gcf,'name','Demo by ImageAnalyst','numbertitle','off');
    % Get the current axis size
    originalSize2 = get(gca, 'Position');
    %uiwait(msgbox('Click OK to see a colorbar and watch how it changes both axes sizes'));
    colormap(hot(256));caxis(range_ret_dep);
    cbh =colorbar('FontSize', fontSize);
    cbh.Ticks = linspace(range_ret_dep(1), range_ret_dep(2), 6) ; %Create 8 ticks from zero to 1
    cbh.TickLabels = num2cell(linspace(range_ret_dep(1), range_ret_dep(2), 6)) ; 
    title('Shrunken Image with ColorBar', 'FontSize', fontSize);
    % Print out the new sizes and see how they are different.
    newSize1 = get(h1, 'Position');
    newSize2 = get(h2, 'Position');
    %uiwait(msgbox('Click OK to restore the original image size'));
    % Reset axes to original size.
    set(h1, 'Position', originalSize1); % Can also use gca instead of h1 if h1 is still active.
    set(h2, 'Position', originalSize2); % Can also use gca instead of h2 if h2 is still active.
    title('Retardance Image', 'FontSize', fontSize);
    % Print out the restored sizes to verify.
    restoredSize1 = get(h1, 'Position');
    restoredSize2 = get(h2, 'Position');
end

if strcmp(mode,'dep');
        % Put up a plot in the first position
    h1 = subplot(1,2,1);
    imshow(img2write1);title('Intensity reference','FontSize', fontSize);

    % Get the current axis size
    originalSize1 = get(gca, 'Position');
    % Put up an image in the second position
    h2 = subplot(1, 2, 2);
    imshow(img2write2);title('Dep Image','FontSize', fontSize); 

    % Enlarge figure to full screen.
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]); % Maximize figure.
    %set(gcf,'name','Demo by ImageAnalyst','numbertitle','off');
    % Get the current axis size
    originalSize2 = get(gca, 'Position');
    %uiwait(msgbox('Click OK to see a colorbar and watch how it changes both axes sizes'));
    colormap(gamma_corr(gray(256), 1));
    cbh =colorbar('FontSize', fontSize);caxis(range_ret_dep);
    cbh.Ticks = linspace(range_ret_dep(1), range_ret_dep(2), 6) ; %Create 8 ticks from zero to 1
    cbh.TickLabels = num2cell(sort(1-linspace(range_ret_dep(1), range_ret_dep(2), 6))) ; 
    
    title('Depolarization Image', 'FontSize', fontSize);
    
    %h3 = subplot(1, 3, 3);
    %imshow(img2write3);title('Ret Image no colorbar','FontSize', fontSize); 

    % Enlarge figure to full screen.
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]); % Maximize figure.
    %set(gcf,'name','Demo by ImageAnalyst','numbertitle','off');
    % Get the current axis size
    originalSize3 = get(gca, 'Position');
    %uiwait(msgbox('Click OK to see a colorbar and watch how it changes both axes sizes'));
    colormap(flipud(gray(256)));
    %title('Depolarization Image', 'FontSize', fontSize);
    
    
    
    
    % Print out the new sizes and see how they are different.
    newSize1 = get(h1, 'Position');
    newSize2 = get(h2, 'Position');
    %newSize3 = get(h3, 'Position');
    %uiwait(msgbox('Click OK to restore the original image size'));
    % Reset axes to original size.
    set(h1, 'Position', originalSize1); % Can also use gca instead of h1 if h1 is still active.
    set(h2, 'Position', originalSize2); % Can also use gca instead of h2 if h2 is still active.
    %set(h3, 'Position', originalSize3); % Can also use gca instead of h2 if h2 is still active.
    %title('OPI Image', 'FontSize', fontSize);
    % Print out the restored sizes to verify.
%     restoredSize1 = get(h1, 'Position')
%     restoredSize2 = get(h2, 'Position')
%     restoredSize3 = get(h3, 'Position')
end

end

