run ../vlfeat/toolbox/vl_setup.m
run ../vlg/toolbox/vlg_setup.m

load('3Dview.mat');
% figure, display_points(X, 'pixelsize', 5, 'color', color(index,:)),
% display_cameras(T, Om, K, 'frustum_scale', 0.1), box on, view(3);
% hold on;
% plot3(X(1, end-1:end), X(2, end-1:end), X(3, end-1:end),'r');
X1 = X(1:3,end-1);
X2 = X(1:3,end);

l = 112 / norm(X1-X2);
FX = l*X;

figure, display_points(FX(1:3,:), 'pixelsize', 5, 'color', color(index,:)),
display_cameras(T, Om, K, 'frustum_scale', 10), box on, view(3);
hold on; axis equal; grid on;
plot3(FX(1, end-1:end), FX(2, end-1:end), FX(3, end-1:end),'r');
