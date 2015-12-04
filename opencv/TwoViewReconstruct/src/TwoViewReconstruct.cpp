//============================================================================
// Name        : TwoViewReconstruct.cpp
// Author      : Jai Prakash
// Version     :
// Copyright   : Your copyright notice
// Description : Hello World in C++, Ansi-style
//============================================================================

#include <iostream>
#include "opencv2/opencv.hpp"
#include "opencv2/viz/vizcore.hpp"
#include "Features.h"

using namespace std;
using namespace cv;

int main_viz(void);

int main() {
	Mat img1 = imread("/home/jprakash/workspace/VSLAMFocus/dataset/im1.png");
	Mat img2 = imread("/home/jprakash/workspace/VSLAMFocus/dataset/im2.png");
	/*	Mat img3 = imread("/home/jprakash/workspace/VSLAMFocus/dataset/img3.jpg");*/

	resize(img1, img1, Size(480, 640));
	resize(img2, img2, Size(480, 640));
	/*resize(img3, img3, Size(640, 480));*/

	/*	imshow("img1", img1);
	 imshow("img2", img2);
	 imshow("img3", img3);*/

	Features *f1 = new Features(img1);
	Features *f2 = new Features(img2);

	vector<KeyPoint> keypoints_1 = f1->getKeypoints();
	vector<KeyPoint> keypoints_2 = f2->getKeypoints();

	Mat desc1 = f1->getDescriptors();
	Mat desc2 = f2->getDescriptors();
	vector<DMatch> matches = f1->getMatches(f2);
	//f1->showMatches(f2);

	vector<Point2f> imgpts1,imgpts2;
	for( unsigned int i = 0; i<matches.size(); i++){
		imgpts1.push_back( keypoints_1[matches[i].queryIdx].pt);
		imgpts2.push_back( keypoints_2[matches[i].queryIdx].pt);
	}
	Mat F = findFundamentalMat(imgpts1, imgpts2, FM_RANSAC, 0.1, 0.99);
	double data[]={1189.46 , 0.0, 805.49, 0.0, 1191.78, 597.44, 0.0, 0.0, 1.0};
	Mat K(3, 3, CV_64F, data);
	Mat E = K.t() * F * K;
	cout << E << endl;
	cout << "size:" << img1.rows << "x" << img1.cols << endl;
	SVD svd(E);
	Matx33d W(0,-1,0,   //HZ 9.13
	      1,0,0,
	      0,0,1);
	Matx33d Winv(0,1,0,
	     -1,0,0,
	     0,0,1);
	Mat R = svd.u * Mat(W) * svd.vt; //HZ 9.19
	Mat t = svd.u.col(2);

	Mat H;
	hconcat(R, t, H);
	cout << H << endl;
	main_viz();
	waitKey(0);


cout << "!!!Hello World!!!" << endl; // prints !!!Hello World!!!
return 0;
}


int main_viz()
{
    /// Create a window
    viz::Viz3d myWindow("Coordinate Frame");

    /// Add coordinate axes
    myWindow.showWidget("Coordinate Widget", viz::WCoordinateSystem());

    /// Add line to represent (1,1,1) axis
    viz::WLine axis(Point3f(-1.0f,-1.0f,-1.0f), Point3f(1.0f,1.0f,1.0f));
    axis.setRenderingProperty(viz::LINE_WIDTH, 4.0);
    myWindow.showWidget("Line Widget", axis);

    /// Construct a cube widget
    viz::WCube cube_widget(Point3f(0.5,0.5,0.0), Point3f(0.0,0.0,-0.5), true, viz::Color::blue());
    cube_widget.setRenderingProperty(viz::LINE_WIDTH, 4.0);

    /// Display widget (update if already displayed)
    myWindow.showWidget("Cube Widget", cube_widget);

    /// Rodrigues vector
    Mat rot_vec = Mat::zeros(1,3,CV_32F);
    float translation_phase = 0.0, translation = 0.0;
    while(!myWindow.wasStopped())
    {
        /* Rotation using rodrigues */
        /// Rotate around (1,1,1)
        rot_vec.at<float>(0,0) += CV_PI * 0.01f;
        rot_vec.at<float>(0,1) += CV_PI * 0.01f;
        rot_vec.at<float>(0,2) += CV_PI * 0.01f;

        /// Shift on (1,1,1)
        translation_phase += CV_PI * 0.01f;
        translation = sin(translation_phase);

        Mat rot_mat;
        Rodrigues(rot_vec, rot_mat);

        /// Construct pose
        Affine3f pose(rot_mat, Vec3f(translation, translation, translation));

        myWindow.setWidgetPose("Cube Widget", pose);

        myWindow.spinOnce(1, true);
    }

    return 0;
}
