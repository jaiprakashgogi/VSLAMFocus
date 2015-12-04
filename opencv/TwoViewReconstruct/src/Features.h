/*
 * Features.h
 *
 *  Created on: Nov 19, 2015
 *      Author: jprakash
 */

#ifndef FEATURES_H_
#define FEATURES_H_
#include <iostream>
#include "opencv2/opencv.hpp"
#include "opencv2/xfeatures2d.hpp"

using namespace std;
using namespace cv;
using namespace cv::xfeatures2d;

class Features {
	Mat img;
	vector<KeyPoint> keypoints;
	vector<DMatch> good_matches;
	Mat descriptors;
	Features();
public:
	Features(Mat& im);
	vector<KeyPoint> getKeypoints();
	Mat getDescriptors();
	void showFeatures();
	vector<DMatch> getMatches(Features *);
	void showMatches(Features *);
	virtual ~Features();
};

#endif /* FEATURES_H_ */
