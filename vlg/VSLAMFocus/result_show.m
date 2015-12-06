run ../vlfeat/toolbox/vl_setup.m
run ../vlg/toolbox/vlg_setup.m

load('../../matlab/calibrationSession.mat');
% get a list of image files
filelist = dir('*.jpg');

% get feature track from the image files
[featx,featy,vis,color] = generate_feature_track( filelist );

[ xx, yy ] = getTemplateLocation(filelist)
featx = [featx; xx];
featy = [featy; yy];
vis = [vis; ones(2,4)];
color = [color; [1 0 0; 1 1 0]];

% run mview reconstruction
% index = sum(vis,2) == size(vis,2); % take features that are seen by all views
index = vis(:,1) & vis(:,2); % take features that are seen by first and second views
good_view_index = sum(vis(index,:)) > 30;
%%
i = 1
im = imread(filelist(i).name);
RGB = insertText(im,[mean(featx(end-1:end,i)) mean(featy(end-1:end,i))],'112 mm', 'FontSize',24);
figure, imshow(RGB)
hold on;
h1 = scatter(featx(:,i), featy(:,i), 'g*');
 set(h1, 'SizeData', 60);
scatter(featx(end-1:end,i), featy(end-1:end,i), 'y*')
l = line(featx(end-1:end,i), featy(end-1:end,i));
l.Color = [1 0 0];
l.LineWidth = 2;
r = rectangle('Position', [620 240 100 75])
r.LineWidth = 2;
r.EdgeColor = [1 1 0]
