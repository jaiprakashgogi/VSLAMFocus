#include<iostream>
#include<stdlib.h>
#include<ctime>
#include<string>
#include<opencv2/core/core.hpp>
#include "opencv2/features2d/features2d.hpp"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/nonfree/features2d.hpp"

using namespace std;
using namespace cv;

void surfMatch(int minHessian, Mat& im1, Mat& im2,vector<DMatch>& matchesSURF, Mat& imageMatchSurf);
void orbMatch(int maxKeypoints, Mat& im1, Mat& im2, vector<DMatch>& matchesORB, Mat& imageMatchOrb);

int main()
{
	string ImagePath[2];
	ImagePath[0]=("../data/img1.jpg");
	ImagePath[1]=("../data/img2.jpg");
	Mat im1=imread(ImagePath[0],CV_LOAD_IMAGE_GRAYSCALE);
	Mat im2=imread(ImagePath[1],CV_LOAD_IMAGE_GRAYSCALE);

	time_t timer;

	//SURF
	double time1=time(&timer);
	int minHessian=20000;
	vector<DMatch> matchesSURF;
	Mat img_matches_surf;
	surfMatch(minHessian,im1, im2,matchesSURF,img_matches_surf);
	double time2=time(&timer);
	cout<<"time for SURF: "<<(time2-time1)<<endl;

	//ORB
	time1=time(&timer);
	int maxKeypoints=500;
	vector<DMatch> matchesORB;
	Mat img_matches_orb;
	orbMatch(maxKeypoints,im1,im2,matchesORB,img_matches_orb);
	time2=time(&timer);
	cout<<"time for ORB: "<<(time2-time1)<<endl;

	//write matched images
	vector<int> compression_params;
    compression_params.push_back(CV_IMWRITE_JPEG_QUALITY);
    compression_params.push_back(5);
	imwrite("../result/surfMatch.jpg",img_matches_surf,compression_params);
	imwrite("../result/orbMatch.jpg",img_matches_orb,compression_params);

	return 0;
}


void surfMatch(int minHessian, Mat& im1, Mat& im2, vector<DMatch>& matchesSURF, Mat& imageMatchSurf)
{
	//key points detection
	vector<KeyPoint> keyPoints_1_SURF, keyPoints_2_SURF;
	SurfFeatureDetector surfDetector(minHessian);
	surfDetector.detect(im1,keyPoints_1_SURF);
	surfDetector.detect(im2,keyPoints_2_SURF); 
	//extract descriptor
	SurfDescriptorExtractor extractor;
	Mat descriptor_1_SURF, descriptor_2_SURF;
	extractor.compute(im1,keyPoints_1_SURF,descriptor_1_SURF);
	extractor.compute(im2,keyPoints_2_SURF,descriptor_2_SURF);
	//matching
	BFMatcher matcher(4,true);
	matcher.match(descriptor_1_SURF,descriptor_2_SURF,matchesSURF);
	//draw matches
	drawMatches(im1,keyPoints_1_SURF,im2,keyPoints_2_SURF,matchesSURF,imageMatchSurf);	
}

void orbMatch(int maxKeypoints, Mat& im1, Mat& im2, vector<DMatch>& matchesORB, Mat& imageMatchOrb)
{
	//key points detection
	vector<KeyPoint> keyPoints_1_ORB, keyPoints_2_ORB;
	ORB orb(maxKeypoints);
	orb.detect(im1,keyPoints_1_ORB);
	orb.detect(im2,keyPoints_2_ORB);
	//extract descriptor
	Mat descriptor_1_ORB, descriptor_2_ORB;
	orb.compute(im1,keyPoints_1_ORB,descriptor_1_ORB);
	orb.compute(im2,keyPoints_2_ORB,descriptor_2_ORB);
	//matching
	BFMatcher matcher(4,true);
	matcher.match(descriptor_1_ORB,descriptor_2_ORB,matchesORB);
	//draw matches
	drawMatches(im1,keyPoints_1_ORB,im2,keyPoints_2_ORB,matchesORB,imageMatchOrb);	
}
