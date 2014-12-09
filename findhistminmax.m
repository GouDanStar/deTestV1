function [ hmin,hmax ] = findhistminmax( image,T,binNum )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[n,xout]=hist(image(:),binNum);
sumHist=0;
hmin=xout(1);
hmax=xout(binNum);
for i=1:binNum
    sumHist=sumHist+n(i);
    if (sumHist>=T)
        hmin=xout(i-1);
        break;
    end
end
sumHist=0;

for i=binNum:-1:1
    sumHist=sumHist+n(i);
    if (sumHist>=T)
        hmax=xout(i+1);
        break;
    end
end

end

