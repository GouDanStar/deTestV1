clc;clear all;close all;
%% Image input
for picnum=1:4
input=im2double(imread([num2str(picnum),'.jpg']));
[Height,Width,z]=size(input);
%figure;imshow(input);

%% parameter setting
output1=zeros(Height,Width,z);
output2=zeros(Height,Width,z);
sigma0=min(Height,Width)/4000;% Gaussian filter cutoff frequency
I=zeros(Height,Width);
[X,Y]=meshgrid(linspace(-Width/2,Width/2,Width),linspace(-Height/2,Height/2,Height));
%===step1 parameter===
d1=20/255;%d1 increase; the gray values of cloud areas will be greater;
          %d1 is used to remove more clouds from the image
d2=20/255;%d2 increase; the dark areas will decrease;
          %d2 is used to maintain more ground information
lamda=2;  %set to 2 for simplity;

%===step2 parameters===
alpha=0.005;
M=Height;
N=Width;
T=alpha*M*N;
% beta=mean(input,3);
% beta(beta>=0.5)=beta(beta>=0.5)/0.5;
% beta(beta<0.5)=0.5/beta(beta<0.5);

%% step1 Cloud Background removal
%Bcloud=zeros(Height,Width,z);
for i=1:z%分通道处理
    I=input(:,:,i);
    offset=mean(I(:));%offset = user-defined constant, here as the average of Band I;
    I_fft=fftshift(fft2(I));
    H=Hcal(X,Y,sigma0);%gaussian low-pass filter;
    Bcloud=abs(ifft2((I_fft.*H)));
    th=(max(Bcloud(:))+min(Bcloud(:)))/2;
    Bcloud(Bcloud>th)=Bcloud(Bcloud>th)+((Bcloud(Bcloud>th)-th)/(max(Bcloud(:)-th))).^lamda*d1;
    Bcloud(Bcloud<=th)=Bcloud(Bcloud<=th)-((th-Bcloud(Bcloud<=th))/(th-min(Bcloud(:)))).^lamda*d2;
    output1(:,:,i)=I-Bcloud+offset;
end
%figure;imshow(Bcloud);
imwrite(Bcloud,[num2str(picnum),'_cloud.jpg'])
%figure;imshow(output1)
imwrite(output1,[num2str(picnum),'_output1.jpg'])
%% step2 Max-min radiation correction
beta=mean(output1,3);
beta(beta>=0.5)=beta(beta>=0.5)/0.5;
beta(beta<0.5)=0.5/beta(beta<0.5);
for i=1:z
    I=output1(:,:,i);
    [hmin,hmax]=findhistminmax(I,T,1000);
    I(I<hmin)=0;
    I(I>hmax)=1;
    I(I>hmin&I<hmax)=((I(I>hmin&I<hmax)-hmin)/(hmax-hmin)).^beta(I>hmin&I<hmax);
    output2(:,:,i)=I;
end
%figure;imshow(output2);
imwrite(output2,[num2str(picnum),'_result.jpg'])
end
