x = P_(:,1);
y = P_(:,2);
z = P_(:,3);

plot3(x,y,z,'.-')

tri = delaunay(x,y);
plot(x,y,'.')

%%
% How many triangles are there?

[r,c] = size(tri);
disp(r)

%% Plot it with TRISURF

h = trisurf(tri, x, y, z);
axis vis3d

%% Clean it up

axis off
l = light('Position',[-50 -15 29])
set(gca,'CameraPosition',[208 -50 7687])
lighting phong
shading interp
colorbar EastOutside