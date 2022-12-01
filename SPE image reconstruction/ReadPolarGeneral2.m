function [ intensity,specular_mask,dark_mask, ret, dep, opi ] = ReadPolarGeneral2(path, filename, mode,thres_overexpose,thres_underexpose)
%READPOLARGENERAL read polarCam images. No normalization. No absolute
%operation for dep.
%    filename: if images acquired by labview, it is a char string
%               if by Bobcat, it is an numeric value
% mode: a string 'ret', or 'dep';
% thres is the threshold for specular detection

%load the flat field calibration file
FlatFieldCalibration_Path='FlatFieldCalibration.jpg';
FFCali=double(imread(FlatFieldCalibration_Path));
mean_cali = mean2(FFCali(1:2:end,2:2:end));
%FFCali=ones(size(imread(FlatFieldCalibration_Path)));

%get the full name of the images to readout

%if images acquired by labview, filenames are like 'depxx.png'
%otherwise, acquired by Bobcat, filenames are like '00001.png'
if isa(filename, 'char')
    full_filename = [path, '\',filename,'.png'];
else
    img_number = filename;
    if img_number<=9
        imgID_prefix1='0000000';
    else if img_number<=99
        imgID_prefix1='000000';
        else if img_number<=999
            imgID_prefix1='00000';
            else if img_number<=9999
                imgID_prefix1='0000';
                else if img_number<=99999
                    imgID_prefix1='000';
                    else
                        disp('im_number should not exceed 99999')
                    end
                end
            end
        end
    end
    full_filename=[path, '\',imgID_prefix1,num2str(img_number),'.jpg'];
end
    
% read raw image data    
A=double(imread(full_filename))./FFCali*mean_cali/255;
[B11,B12,B21,B22] = PolarCamInterpolation(A);

intensity=(B11+B12+B21+B22)/2;

%thres = 245;% threshold for specular detection
[B11_raw,B12_raw,B21_raw,B22_raw] = PolarCamInterpolation(imread(full_filename));
specular_mask = (B11_raw>thres_overexpose|B12_raw>thres_overexpose|B21_raw>thres_overexpose|B22_raw>thres_overexpose);%this is not flat field corrected. Used for specular high light detection
dark_mask = (B11_raw+B12_raw+B21_raw+B22_raw)/4 < thres_underexpose;%this is not flat field corrected. Used for specular high light detection
%specular_mask = mark_specular_fun( specular_mask );

if strcmp(mode,'ret')
    ret = sqrt((B11-B22).^2 + (B12-B21).^2);% linear polarized emergence
    dep=NaN;
    opi=NaN;
else if strcmp(mode,'dep')
        ret=NaN;
        dep= (B11-B22);% this is actually polarizatin maintaining degree
        opi= B22;
    else
        disp('please specify correct mode')
    end
end


end

