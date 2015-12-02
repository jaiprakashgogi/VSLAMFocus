function [ P, error ] = triangulate( M1, p1, M2, p2 )
% triangulate:
%       M1 - 3x4 Camera Matrix 1
%       p1 - Nx2 set of points
%       M2 - 3x4 Camera Matrix 2
%       p2 - Nx2 set of points
% Q2.4 - Todo:
%       Implement a triangulation algorithm to compute the 3d locations
%       See Szeliski Chapter 7 for ideas
%
c1=-1*inv(M1(1:3,1:3))*M1(1:3,4);
c2=-1*inv(M2(1:3,1:3))*M2(1:3,4);
v1=inv(M1(1:3,1:3))*[p1,ones(size(p1,1),1)]';
v1=normc(v1);
v2=inv(M2(1:3,1:3))*[p2,ones(size(p2,1),1)]';
v2=normc(v2);
for i=1:size(p1,1)
    P(:,i)=inv(eye(3)-v1(:,i)*(v1(:,i))'+eye(3)-v2(:,i)*(v2(:,i))')*((eye(3)-v1(:,i)*(v1(:,i))')*c1+(eye(3)-v2(:,i)*(v2(:,i))')*c2);
end
P=P';
%calculate error
p1_reproject=M1*[P,ones(size(P,1),1)]';
p1_reproject=(p1_reproject(1:2,:)./repmat(p1_reproject(3,:),[2,1]))';
p2_reproject=M2*[P,ones(size(P,1),1)]';
p2_reproject=(p2_reproject(1:2,:)./repmat(p2_reproject(3,:),[2,1]))';
error=sum(sum((p1-p1_reproject).^2))+sum(sum((p2-p2_reproject).^2));
%error=mean(mean(sum((p1-p1_reproject).^2)),mean(sum((p2-p2_reproject).^2)));
end

