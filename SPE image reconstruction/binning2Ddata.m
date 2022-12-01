function M1 = binning2Ddata(M,bindims)
%DOWNSAMP2D - simple tool for 2D downsampling
% example: M_binned = binning2Ddata(M,[2 2])
%  M=downsamp2d(M,bindims)
%
%in:
%
% M: a matrix
% bindims: a vector [p,q] specifying pxq downsampling
%
%out:
%
% M: the downsized matrix

p=bindims(1); q=bindims(2);


% cropM so that its size is integral times of bindims
[m,n]=size(M); 
M_crop = M(1:floor(m/p)*p,1:floor(n/q)*q);
M = M_crop;


[m,n]=size(M); %M is the original matrix

M=sum(  reshape(M,p,[]) ,1 );
M=reshape(M,m/p,[]).'; %Note transpose

M=sum( reshape(M,q,[]) ,1);
M=reshape(M,n/q,[]).'; %Note transpose

M1=M/(p*q);
end

