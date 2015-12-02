function [ F ] = sevenpoint( pts1, pts2, M )
% sevenpoint:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.2 - Todo:
%     Implement the eightpoint algorithm
%     Generate a matrix F from some '../data/some_corresp.mat'
%     Save recovered F (either 1 or 3 in cell), M, pts1, pts2 to q2_2.mat

%     Write recovered F and display the output of displayEpipolarF in your writeup

pts1=pts1/M;
pts2=pts2/M;
x1=pts1(:,1);
y1=pts1(:,2);
x2=pts2(:,1);
y2=pts2(:,2);
A=[x1.*x2, x1.*y2, x1, y1.*x2, y1.*y2, y1, x2, y2, ones(size(x1,1),1)];
Z=null(A,'r');
F1=reshape(Z(:,1),3,3);
F2=reshape(Z(:,2),3,3);
syms x;
y=det(x*F1+(1-x)*F2);
root=roots(sym2poly(y));
a=root(imag(root)==0);
F=cell(size(a));
T=[1/M,0 0;0 1/M 0;0 0 1];
for i=1:size(a,1)
    F{i}=a(i)*F1+(1-a(i))*F2;
    F{i}=T'*F{i}*T;
end
end

