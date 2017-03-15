% RUN THIS FILE TO SEE HOW THE SYSTEM WORKS


clear all;close all;
folder = 'Caltech4/ImageData';
%folder = 'data';
colorSpace = 'opponent';
train_num = 200;
vocab_num = 250; %how many images per class to use for vocabulary creation
vocab_size= 400;
cached = false;
BOW(folder,vocab_num,train_num,vocab_size,colorSpace,cached)