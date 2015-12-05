% addpath('mex');
% % load the two frames
% imagePath1='../dataset/set2/20151204_200009.jpg';
% imagePath2='../dataset/set2/20151204_200012.jpg';
% im1 = im2double(imread(imagePath1));
% im2 = im2double(imread(imagePath2));
% 
% im1 = imresize(im1,0.5,'bicubic');
% im2 = imresize(im2,0.5,'bicubic');
% alpha = 0.012;
% ratio = 0.75;
% minWidth = 20;
% nOuterFPIterations = 7;
% nInnerFPIterations = 1;
% nSORIterations = 30;
% 
% para = [alpha,ratio,minWidth,nOuterFPIterations,nInnerFPIterations,nSORIterations];
% tic;
% [vx,vy,warpI2] = Coarse2FineTwoFrames(im1,im2,para);
% toc
% 
% figure;imshow(im1);figure;imshow(warpI2);
% 
% clear flow;
% flow(:,:,1) = vx;
% flow(:,:,2) = vy;
% imflow = flowToColor(flow);
% 
% figure;imshow(imflow);
%%
load('temp.mat');
load('calibrationSession.mat');
cameraParams = calibrationSession.CameraParameters;
im1 = undistortImage(im1, cameraParams);
im2 = undistortImage(im2, cameraParams);
figure, imshowpair(im1, im2, 'montage'); title('Undistorted Images');
cameraParams = calibrationSession.CameraParameters;
[matchedPoints1, matchedPoints2]=featureMatch2View(im1,im2,0.005);
[F, inliers] = estimateFundamentalMatrix(matchedPoints1,matchedPoints2,'Method', 'RANSAC', 'NumTrials', 2000, 'DistanceThreshold', 1e-4);
F = refineF(F,matchedPoints1(inliers,:), matchedPoints2(inliers,:));
figure; showMatchedFeatures(im1, im2, matchedPoints1(inliers,:), matchedPoints2(inliers,:),'montage','PlotOptions',{'ro','go','y--'}); title('Putative point matches');

%%
K = cameraParams.IntrinsicMatrix';
E = K'*F*K;
[R, T] = cameraPose(E);
% M1 = [eye(3) [0 0 0]'];
% M2s = camera2(E);
camMatrix1 = cameraMatrix(cameraParams, eye(3), [0 0 0]);
% Compute the 3-D points
P = []; dist = [];
cameraSize = 0.3;
for i= 1:size(R,3)
    r= R(:,:,i); t = T(:,:,i);
    camMatrix2 = cameraMatrix(cameraParams, r, -t'*r);
%     camMatrix2 = K*M2s(:,:,i);
%     camMatrix2 = camMatrix2';
    points3D = triangulate(matchedPoints1, matchedPoints2, camMatrix1, camMatrix2);
    %figure, scatter3(points3D(:,1), points3D(:,2), points3D(:,3), 2*ones(size(points3D,1), 1));
    dist = cat(1,dist, min(points3D(:,3)));
end
[~,idx] = max(dist);
r= R(:,:,idx); t = T(:,:,idx);
camMatrix2_final = cameraMatrix(cameraParams, r, -t'*r);
    
    points3D = triangulate(matchedPoints1, matchedPoints2, camMatrix1, camMatrix2);
    figure, scatter3(points3D(:,1), points3D(:,2), points3D(:,3), 2*ones(size(points3D,1), 1));
    hold on
    grid on
    plotCamera('Size', cameraSize, 'Color', 'r', 'Label', '1', 'Opacity', 0);
    plotCamera('Location', t', 'Orientation', r', 'Size', cameraSize, ...
        'Color', 'b', 'Label', '2', 'Opacity', 0);

%% Dense reconstruction
W = size(im1, 1);
H = size(im1, 2);
[x, y] = meshgrid(1:H, 1:W);
VX = x + vx;
VY = y + vy;
pts1 = [x(:) y(:)];
pts2 = [VX(:) VY(:)];
points3D = triangulate(pts1, pts2, camMatrix1, camMatrix2_final);
%%
r = im1(:,:,1);
g = im1(:,:,2);
b = im1(:,:,3);
C = [r(:) g(:) b(:)];
scatter3(points3D(:,1), points3D(:,2), points3D(:,3), 2*ones(size(points3D,1), 1), C , 'o');