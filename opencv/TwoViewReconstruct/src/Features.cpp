/*
 * Features.cpp
 *
 *  Created on: Nov 19, 2015
 *      Author: jprakash
 */

#include "Features.h"

Features::Features(Mat& im) {
	img = im;
	// TODO Auto-generated constructor stub
	int minHessian = 400;
	Ptr<SIFT> detector = SIFT::create();
	//detector->setHessianThreshold(minHessian);
	detector->detectAndCompute(img, Mat(), keypoints, descriptors);
}

Features::~Features() {
	// TODO Auto-generated destructor stub
}

vector<KeyPoint> Features::getKeypoints() {
	return keypoints;
}

Mat Features::getDescriptors() {
	return descriptors;
}

void Features::showFeatures() {
	Mat img_keypoints_1;
	drawKeypoints(img, keypoints, img_keypoints_1, Scalar::all(-1),
			DrawMatchesFlags::DEFAULT);
	imshow("Keypoint", img_keypoints_1);
}

vector<DMatch> Features::getMatches(Features *f2) {
	Mat descriptors_2 = f2->getDescriptors();
	FlannBasedMatcher matcher;
	std::vector<DMatch> matches;
	matcher.match(descriptors, descriptors_2, matches);

	//-- Quick calculation of max and min distances between keypoints
	double max_dist = 0;
	double min_dist = 100;
	for (int i = 0; i < descriptors.rows; i++) {
		double dist = matches[i].distance;
		if (dist < min_dist)
			min_dist = dist;
		if (dist > max_dist)
			max_dist = dist;
	}
	printf("-- Max dist : %f \n", max_dist);
	printf("-- Min dist : %f \n", min_dist);
	//-- Draw only "good" matches (i.e. whose distance is less than 2*min_dist,
	//-- or a small arbitary value ( 0.02 ) in the event that min_dist is very
	//-- small)
	//-- PS.- radiusMatch can also be used here.
	for (int i = 0; i < descriptors.rows; i++) {
		if (matches[i].distance <= max(4 * min_dist, 0.02)) {
			good_matches.push_back(matches[i]);
		}
	}
	return good_matches;
}

void Features::showMatches(Features *f2){
	  Mat img_matches;
	  drawMatches( img, keypoints, f2->img, f2->keypoints,
	               good_matches, img_matches, Scalar::all(-1), Scalar::all(-1),
	               vector<char>(), DrawMatchesFlags::NOT_DRAW_SINGLE_POINTS );
	  imshow( "Good Matches", img_matches );
}

