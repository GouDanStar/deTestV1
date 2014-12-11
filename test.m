clc;clear all;close all;
%% Image input
input=im2double(imread('1.jpg'));
[Height,Width,z]=size(input);
figure;imshow(input);

%% step1 Cloud Background removal
output1=cloudRM(input);

%% step2 Max-min radiation correction
output2=maxminCorrect(output1);
figure;imshow(output2);

