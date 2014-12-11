function [ output ] = maxminCorrect( input,alpha )
%====================================
%% Introduction
%{linguang;tzlinguang@gmail.com;2014_12_11}
%++++++++++++++++++++++++++++++++++++
%maxminCorrect: constrast strenth;
%++++++++++++++++++++++++++++++++++++
%[ output ] = maxminCorrect( input,alpha )
%         {input} -- input image (double)
%         {alpha} -- scalar factor to choose darkest and brightest pixels
%---------------------
%         [output]: the final result 
%---------------------
%         <beta>== brightness factor used to adjust the brightness of the final image;smaller make final brighter
%                  mean of each channel of input image Here;
%===================================
%%
if nargin==1
    alpha=0.005;
end

[M,N,z]=size(input);
output=zeros(M,N,z);
T=alpha*M*N;
beta=mean(input,3);%brightness factor used to adjust the brightness of the final image;smaller make final brighter
beta(beta>0.5)=0.5./beta(beta>0.5);
beta(beta<=0.5)=beta(beta<=0.5)./0.5;
for i=1:z
    I=input(:,:,i);
    [hmin,hmax]=findhistminmax(I,T,1000);%find the darkest and brightest objects
    I(I<hmin)=0;
    I(I>hmax)=1;
    I(I>hmin&I<hmax)=((I(I>hmin&I<hmax)-hmin)/(hmax-hmin)).^beta(I>hmin&I<hmax);%constrast strench
    output(:,:,i)=I;
end
end

