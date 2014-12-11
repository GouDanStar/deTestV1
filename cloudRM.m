function [ output ] = cloudRM( input,d1,d2,sigma,lamda )
%====================================
%% Introduction
%{linguang;tzlinguang@gmail.com;2014_12_11}
%+++++++++++++++++++++++++++++++++++++++++++++++
%cloudRM: remove uneveness cloud from the image
%+++++++++++++++++++++++++++++++++++++++++++++++
%[ output ] = cloudRM( input,d1,d2,sigma,lamda ):
%         {input} -- input image (double)
%         {d1,d2} -- d1 increase; the gray values of cloud areas will be greater;d1 is used to remove more clouds from the image
%                    d2 increase; the dark areas will decrease;d2 is used to maintain more ground information
%         {sigma} -- Gaussian filter cutoff frequency[main factor affect the final result];(*Could be choose automatically?!*)
%         {lamda} -- set to 2 for simplity; 
%---------------------
%         [output]: the final result 
%---------------------
%         <offset>== user-defined constant, here as the average of Band I;
%===================================
%% Parameter default setting
switch nargin
    case 1
       d1=5/255;
       d2=5/255;
       lamda=2; 
       sigma=1.7;
    case 3
       lamda=2;  
       sigma=1.7;
    case 4
       lamda=2; 
    otherwise
end

[Height,Width,z]=size(input);
output=zeros(Height,Width,z);%the result without uneven hist
[X,Y]=meshgrid(linspace(-Width/2,Width/2,Width),linspace(-Height/2,Height/2,Height));
%% procedure
for i=1:z%split channels
    I=input(:,:,i);
    offset=mean(I(:));%offset = user-defined constant, here as the average of Band I;
    I_fft=fftshift(fft2(I));
    H=Hcal(X,Y,sigma);%gaussian low-pass filter;sigma0 is key to get a final output without over constrast stretch
    Bcloud=abs(ifft2((I_fft.*H)));%cloud veil
    th=(max(Bcloud(:))+min(Bcloud(:)))/2;
    Bcloud(Bcloud>th)=Bcloud(Bcloud>th)+((Bcloud(Bcloud>th)-th)/(max(Bcloud(:)-th))).^lamda*d1;%suppress the areas with greater gray value 
    Bcloud(Bcloud<=th)=Bcloud(Bcloud<=th)-((th-Bcloud(Bcloud<=th))/(th-min(Bcloud(:)))).^lamda*d2;%enhance the dark objects
    output(:,:,i)=I-Bcloud+offset;%removel uneven cloud
end

end

