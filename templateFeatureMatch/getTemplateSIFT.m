hold onrun('../vlg/vlfeat/toolbox/vl_setup');
imagePath1='../vlg/VSLAMFocus/im1.jpg';
imagePath2='../vlg/VSLAMFocus/im1.jpg';
peak_thresh=10;
edge_thresh=3;
I1 = imread(imagePath1);
I2 = imread(imagePath2);
 I1 = I2( 743:790, 435:501 ,:);
 I2 = I2( 678:731, 839:908 ,:);
 
figure, imshow(I1); figure, imshow(I2);
I1 = rgb2gray(I1) ;
I2 = rgb2gray(I2) ;
[f1,d1] = vl_sift(single(I1),'PeakThresh',peak_thresh,'edgethresh',edge_thresh) ;
[f2,d2] = vl_sift(single(I2),'PeakThresh',peak_thresh,'edgethresh',edge_thresh) ;
imshow(I1);hold on;
h1 = vl_plotframe(f1) ;
set(h1,'color','y','linewidth',3) ;
figure;
imshow(I2);hold on;
h2 = vl_plotframe(f2) ;
set(h2,'color','y','linewidth',3) ;

d1 = mean(d1')';
d2 = mean(d2')';
d1 = uint8(d1);
d2 = uint8(d2);
%save('siftDescriptor1.mat', 'd1');
%save('siftDescriptor2.mat', 'd2');
