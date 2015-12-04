imagePath1='../dataset/set1/im3.jpg';
imagePath2='../dataset/set1/im4.jpg';
I1 = imread(imagePath1);
I2 = imread(imagePath2);
%imshowpair(I1,I2,'montage');
%load('../dataset/cameraParams_freiburg1.mat');
%load('../dataset/temple/cameraParams_temple.mat');
load('../dataset/set1/cameraParams_frommv.mat');
[matchedPoints1, matchedPoints2]=featureMatch2View(I1,I2,0.005);
[R,t,M]=getCameraPose(matchedPoints1,matchedPoints2,cameraParams,max(size(I1)));


%%visualization
% Detect dense feature points
[matchedPoints1, matchedPoints2]=featureMatch2View(I1,I2,0.0001);

% Compute the camera matrices for each position of the camera
% The first camera is at the origin looking along the X-axis. Thus, its
% rotation matrix is identity, and its translation vector is 0.
camMatrix1 = cameraParams.IntrinsicMatrix'*[eye(3),[0 ;0; 0]];
camMatrix2 = cameraParams.IntrinsicMatrix'*M;

% Compute the 3-D points
points3D = triangulate(camMatrix1,matchedPoints1, camMatrix2,matchedPoints2);
%xmean=mean(abs(points3D(:,1)));
%ymean=mean(abs(points3D(:,2)));
%zmean=mean(abs(points3D(:,3)));
%points3D=points3D./repmat([xmean,ymean,zmean],[size(points3D,1),1]);

%visualize 3-D points
figure;
numPixels = size(I1, 1) * size(I1, 2);
allColors = reshape(I1, [numPixels, 3]);
colorIdx = sub2ind([size(I1, 1), size(I1, 2)], round(matchedPoints1(:,2)), ...
    round(matchedPoints1(:, 1)));
color = allColors(colorIdx, :);
scatter3(points3D(:,1),points3D(:,2),points3D(:,3),[],double(color)/255,'filled'); hold on;


% Visualize the camera locations and orientations
cameraSize = 0.1;
plotCamera('Size', cameraSize, 'Color', 'r', 'Label', '1', 'Opacity', 0);
hold on
grid on
plotCamera('Location', t, 'Orientation', R, 'Size', cameraSize, ...
    'Color', 'b', 'Label', '2', 'Opacity', 0);

