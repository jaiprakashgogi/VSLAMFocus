function [R t M]=getCameraPose(matchedPoints1,matchedPoints2,cameraParams,m)
%   m    - max (imwidth, imheight)

%get fundamental matrix and find inliers
%[fMatrix, epipolarInliers] = estimateFundamentalMatrix(...
%    matchedPoints1, matchedPoints2, 'Method', 'RANSAC', 'NumTrials', 1000);
%fMatrix=fMatrix';
%inlierPoints1 = matchedPoints1(epipolarInliers, :);
%inlierPoints2 = matchedPoints2(epipolarInliers, :);
fMatrix=ransacF(matchedPoints1,matchedPoints2,m,100)
inlierPoints1 = matchedPoints1;
inlierPoints2 = matchedPoints2;
%calculate 4 M's and select the proper one
E=cameraParams.IntrinsicMatrix*fMatrix*cameraParams.IntrinsicMatrix';
M2s=camera2(E);
numPositiveDepth=zeros(4,1);
for i=1:4
    camMatrix1 = cameraParams.IntrinsicMatrix'*[eye(3),[0 ;0; 0]];
    camMatrix2 = cameraParams.IntrinsicMatrix'*(M2s(:,:,i));
    points3D = triangulate(camMatrix1,inlierPoints1, camMatrix2,inlierPoints2);
    points3DinCamera2Cor=[points3D,ones(size(points3D,1),1)]*(M2s(:,:,i))';
    PositiveDepth1=points3D(:,3)>0;
    PositiveDepth2=points3DinCamera2Cor(:,3)>0;
    numPositiveDepth(i,1)= sum(PositiveDepth1&PositiveDepth2);
end
[~,idx]=max(numPositiveDepth);
M=M2s(:,:,idx);
R=M(1:3,1:3);
t=-R'*M(:,4);
end

    
    



