// -*- c++ -*-
// Copyright 2008 Isis Innovation Limited
//
// System.h
//
// Defines the System class
//
// This stores the main functional classes of the system, like the
// mapmaker, map, tracker etc, and spawns the working threads.
//
#ifndef __SYSTEM_H
#define __SYSTEM_H
#include <cvd/image.h>
#include <cvd/rgb.h>
#include <cvd/byte.h>

#include "../PTAM/Capture.h"
#include "../PTAM/Capture.h"
#include "../PTAM/VideoSource.h"

class ATANCamera;
class Map;
class MapMaker;
class Tracker;
class ARDriver;
class MapViewer;

class System
{
public:
    System(int* size);

    static System* get_instance();
    static System* _instance;

    float* get_modelview();
    float* get_viewmodel();
    float* get_corners();
    void set_size(int* size);
    void update_frame(unsigned char* frame, int size);
    void update();
    void store_corner();
    bool map_is_good();
    bool object_is_good();
    void reset_corners();
    void reset_positions();
    void reset_stereo();

    bool started;
    long long time;

private:
    /* CVD::Image<CVD::Rgb<CVD::byte> > mimFrameRGB; */
    CVD::Image<CVD::byte> mimFrameBW;

    CVD::ImageRef _imsize;

    Map *mpMap; 
    MapMaker *mpMapMaker; 
    Tracker *mpTracker; 
    ATANCamera *mpCamera;
    ARDriver *mpARDriver;
    MapViewer *mpMapViewer;

    Capture* _capture;

    bool mbDone;

    void draw_center();
    void draw_rectangle();
    void draw_painted();
    void store_time();

    static void GUICommandCallBack(void* ptr, std::string sCommand, std::string sParams);
};



#endif
