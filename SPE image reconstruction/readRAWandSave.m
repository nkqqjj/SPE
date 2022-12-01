FilePath = 'D:\UCL\invivo paper\Key data\in vivo human\in vivo human Jan 2016\2';

FlatFieldCalibration_Path='FlatFieldCalibration.jpg';
FFCali=double(imread(FlatFieldCalibration_Path));

S = dir(fullfile(FilePath,'Dep2*.png')); % pattern to match filenames.
for k = 1:numel(S)
    F = fullfile(FilePath,S(k).name);
    RAW_image = double(imread(F))./FFCali;
    [img_merge] = PolarCamInterpolation(RAW_image);
    Intensity = sum(img_merge,3)./4;
    %imwrite(Intensity,['interp',num2str(k),'.png']);    
end
