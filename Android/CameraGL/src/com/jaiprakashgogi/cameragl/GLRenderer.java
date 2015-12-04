package com.jaiprakashgogi.cameragl;

/*
 * Base class to all Renderers, defines three functions that are called by the BatchRenderer
 */
public abstract class GLRenderer {
	public void draw() {}
	public void changed(int width, int height) {}
	public void init() {}
}