function [x,y]=matchTemplate(template_descriptor1,Img)
peak_thresh=5;
edge_thresh=10;
I = rgb2gray(Img) ;
% imshow(Img);hold on;
[f,d] = vl_sift(single(I),'PeakThresh',peak_thresh,'edgethresh',edge_thresh) ;
[match, ~] = vl_ubcmatch(template_descriptor1, d,1)
% h1 = vl_plotframe(f(:,match(2))) ;
% set(h1,'color','y','linewidth',3) ;
position=f(1:2,match(2));
x=position(1);
y=position(2);
end

