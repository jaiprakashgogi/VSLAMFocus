function [ xx, yy ] = getTemplateLocation(filelist)
xx = [];
yy = [];

load('siftDescriptor1.mat');
load('siftDescriptor2.mat');
for i = 1:length(filelist)
    Img = imread(filelist(i).name);
    [x1,y1]=matchTemplate(d1,Img);
    [x2,y2]=matchTemplate(d2,Img);
% figure;
% imshow(Img);hold on;
% scatter(x1,y1,'y','filled');
% scatter(x2,y2,'g','filled');
    xx = cat(2, xx, [x1; x2]);
    yy = cat(2, yy, [y1; y2]);
end
end

