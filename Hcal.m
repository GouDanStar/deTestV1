function output = Hcal( x,y,sigma )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
output=exp(-sqrt(x.^2+y.^2)/(2*sigma^2));
end

