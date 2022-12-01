function [output2Dmatrix] = gamma_corr(input2Dmatrix, gamma)
%GAMMA_CORR of a 2D real matrix
%   Detailed explanation goes here
if quantile(input2Dmatrix(:),0.95)>1
    disp('please normalize the input');
end
if quantile(input2Dmatrix(:),0.05)<0
    disp('please normalize the input');
end

output2Dmatrix = input2Dmatrix.^(1/gamma);

end

