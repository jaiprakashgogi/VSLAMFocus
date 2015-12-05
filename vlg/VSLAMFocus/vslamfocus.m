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
K1 = calibrationSession.CameraParameters.IntrinsicMatrix';
[K T Om X] = VLmvg(featx(index,good_view_index), featy(index,good_view_index),...
    'calibrated', 'K', K1);
% [K T Om X] = VLmvg(featx(index,good_view_index), featy(index,good_view_index), vis(index,good_view_index) );
figure, display_points(X, 'pixelsize', 5, 'color', color(index,:)),
display_cameras(T, Om, K, 'frustum_scale', 0.1), box on, view(3);

save('3Dview.mat');