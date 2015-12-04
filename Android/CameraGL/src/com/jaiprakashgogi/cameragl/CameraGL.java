package com.jaiprakashgogi.cameragl;

import java.io.IOException;

import com.jaiprakashgogi.cameragl.CaptureViewer;
import com.jaiprakashgogi.cameragl.VideoSource;

import android.app.ActionBar;
import android.app.Activity;
import android.content.Context;
import android.graphics.SurfaceTexture;
import android.hardware.Camera;
import android.os.Bundle;
import android.os.PowerManager;
import android.os.PowerManager.WakeLock;
import android.view.Gravity;
import android.view.TextureView;
import android.view.View;
import android.view.TextureView.SurfaceTextureListener;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.LinearLayout.LayoutParams;

public class CameraGL extends Activity {
	
	private VideoSource _videosource;
	private CaptureViewer _capture;
	private CameraGL _self;
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		_self = this;

		// hide system UI
		View decorView = getWindow().getDecorView();
		int uiOptions = View.SYSTEM_UI_FLAG_FULLSCREEN;
		decorView.setSystemUiVisibility(uiOptions);
		ActionBar actionBar = getActionBar();
		actionBar.hide();

		_videosource = new VideoSource();
		_capture = new CaptureViewer(this, _videosource);

		Button btn_action = new Button(this);
		btn_action.setOnClickListener(_capture);
		LayoutParams params = new LayoutParams(btn_action.getMinWidth(), btn_action.getMinHeight(), (float)2.0);
		btn_action.setLayoutParams(params);
		_capture.set_action_button(btn_action);
		_capture.reset_all();

		Button btn_reset_all = new Button(this);
		btn_reset_all.setText("Reset");
		btn_reset_all.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				_capture.reset_all();
			}
		});

		Button btn_reset_zone = new Button(this);
		btn_reset_zone.setText("Reset Zone");
		btn_reset_zone.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				_capture.reset_zone();
			}
		});

		Button btn_reset_tracking = new Button(this);
		btn_reset_tracking.setText("Reset Tracking");
		btn_reset_tracking.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				_capture.reset_tracking();
			}
		});
		
		Button btn_quit = new Button(this);
		btn_quit.setText("Quit");
		btn_quit.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				_self.finish();
			}
		});

		LinearLayout llayout = new LinearLayout(this);
		llayout.setGravity(Gravity.TOP);
		llayout.setHorizontalGravity(Gravity.END);
		llayout.addView(btn_quit);
		llayout.addView(btn_reset_all);
		llayout.addView(btn_reset_zone);
		llayout.addView(btn_reset_tracking);
		llayout.addView(btn_action);

		FrameLayout flayout = new FrameLayout(this);
		flayout.addView(_capture);
		flayout.addView(llayout);

		setContentView(flayout);
		getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
	
	}

	@Override
	protected void onPause() {
		super.onPause();
		_capture.onPause();
		_videosource.camera_release();
	}

	@Override
	protected void onResume() {
		super.onResume();
		_capture.onResume();
	}
}
