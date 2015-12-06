package com.jaiprakashgogi.vslamfocus;

import java.util.Arrays;

import android.app.Activity;
import android.content.Context;
import android.graphics.Color;
import android.graphics.SurfaceTexture;
import android.hardware.camera2.CameraAccessException;
import android.hardware.camera2.CameraCaptureSession;
import android.hardware.camera2.CameraCaptureSession.CaptureCallback;
import android.hardware.camera2.CameraCharacteristics;
import android.hardware.camera2.CameraDevice;
import android.hardware.camera2.CameraDevice.StateCallback;
import android.hardware.camera2.CameraManager;
import android.hardware.camera2.CameraMetadata;
import android.hardware.camera2.CaptureRequest;
import android.hardware.camera2.CaptureResult;
import android.hardware.camera2.TotalCaptureResult;
import android.hardware.camera2.params.StreamConfigurationMap;
import android.os.Bundle;
import android.os.Handler;
import android.os.HandlerThread;
import android.util.Log;
import android.util.Pair;
import android.util.Size;
import android.view.Surface;
import android.view.TextureView;
import android.view.TextureView.SurfaceTextureListener;
import android.view.Window;
import android.view.WindowManager;
import android.widget.TextView;

public class CameraActivity extends Activity implements SurfaceTextureListener {

	private static final String TAG = "CameraActivity";
	private CameraDevice mCameraDevice = null;
	private CaptureRequest.Builder mPreviewBuilder = null;
	private CameraCaptureSession mPreviewSession = null;
	private TextureView mTextureView = null;
	private int camId = 0;
	private CameraManager manager;
	private Size mPreviewSize;
	private TextView tv;
	private float afState = 0;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		requestWindowFeature(Window.FEATURE_NO_TITLE);
		getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
		setContentView(R.layout.activity_camera);
		mTextureView = (TextureView) findViewById(R.id.tv);
		tv = (TextView) findViewById(R.id.textView1);
		tv.setTextColor(Color.WHITE);
		manager = (CameraManager) getSystemService(Context.CAMERA_SERVICE);
		mTextureView.setSurfaceTextureListener(this);
	}

	@Override
	protected void onPause() {
		// TODO Auto-generated method stub
		super.onPause();
		if (mCameraDevice != null) {
			mCameraDevice.close();
			mCameraDevice = null;
		}
	}

	@Override
	public void onSurfaceTextureAvailable(SurfaceTexture surface, int width, int height) {
		// TODO Auto-generated method stub
		openCamera(width, height, camId);

	}

	@Override
	public void onSurfaceTextureSizeChanged(SurfaceTexture surface, int width, int height) {
		// TODO Auto-generated method stub

	}

	@Override
	public boolean onSurfaceTextureDestroyed(SurfaceTexture surface) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public void onSurfaceTextureUpdated(SurfaceTexture surface) {
		// TODO Auto-generated method stub

	}

	protected void openCamera(int width, int height, int id) {
		// TODO Auto-generated method stub

		try {
			String cameraId = manager.getCameraIdList()[id];
			CameraCharacteristics characteristics = manager.getCameraCharacteristics(cameraId);
			StreamConfigurationMap map = characteristics.get(CameraCharacteristics.SCALER_STREAM_CONFIGURATION_MAP);
			mPreviewSize = map.getOutputSizes(SurfaceTexture.class)[0];
			manager.openCamera(cameraId, mStateCallback, null);
		} catch (CameraAccessException e) {
			e.printStackTrace();
		}
	}

	private StateCallback mStateCallback = new StateCallback() {
		@Override
		public void onOpened(CameraDevice camera) {
			// TODO Auto-generated method stub
			mCameraDevice = camera;
			createCameraPreviewSession();
			Log.i(TAG, "onOpened " + camId);
		}

		@Override
		public void onError(CameraDevice camera, int error) {
			// TODO Auto-generated method stub
			Log.i(TAG, "onError " + camId);
		}

		@Override
		public void onDisconnected(CameraDevice camera) {
			// TODO Auto-generated method stub
			Log.i(TAG, "onDisconnected " + camId);
		}
	};

	protected void createCameraPreviewSession() {
		// TODO Auto-generated method stub
		Log.i(TAG, "createCameraPreviewSession");
		SurfaceTexture texture = mTextureView.getSurfaceTexture();
		if (texture == null) {
			Log.e(TAG, "texture is null");
			return;
		}

		texture.setDefaultBufferSize(mPreviewSize.getWidth(), mPreviewSize.getHeight());
		Surface surface = new Surface(texture);

		try {
			mPreviewBuilder = mCameraDevice.createCaptureRequest(CameraDevice.TEMPLATE_PREVIEW);
		} catch (CameraAccessException e) {
			e.printStackTrace();
		}

		mPreviewBuilder.addTarget(surface);

		try {
			mCameraDevice.createCaptureSession(Arrays.asList(surface), mPreviewStateCallback, null);
		} catch (CameraAccessException e) {
			e.printStackTrace();
		}

	}

	private CameraCaptureSession.StateCallback mPreviewStateCallback = new CameraCaptureSession.StateCallback() {

		@Override
		public void onConfigured(CameraCaptureSession session) {
			// TODO Auto-generated method stub
			Log.i(TAG, "onConfigured");
			mPreviewSession = session;
			mPreviewBuilder.set(CaptureRequest.CONTROL_MODE, CameraMetadata.CONTROL_MODE_AUTO);
			HandlerThread backgroundThread = new HandlerThread("CameraPreview");
			backgroundThread.start();
			Handler backgroundHandler = new Handler(backgroundThread.getLooper());
			try {
				mPreviewSession.setRepeatingRequest(mPreviewBuilder.build(), previewlistener, backgroundHandler);
			} catch (CameraAccessException e) {
				e.printStackTrace();
			}

		}

		@Override
		public void onConfigureFailed(CameraCaptureSession session) {
			// TODO Auto-generated method stub
			Log.e(TAG, "CameraCaptureSession Configure failed");
		}
	};
	
	protected CaptureCallback previewlistener = new CaptureCallback() {

		@Override
		public void onCaptureCompleted(CameraCaptureSession session, CaptureRequest request,
				TotalCaptureResult result) {
			// TODO Auto-generated method stub
			super.onCaptureCompleted(session, request, result);
			//Pair<Float, Float> afState = result.get(CaptureResult.LENS_FOCUS_RANGE);
			afState = result.get(CaptureResult.LENS_FOCUS_DISTANCE);
			Log.i(TAG, "Jai in previewlistener " + afState);
			runOnUiThread(new Runnable() {
			     @Override
			     public void run() {
			    	 tv.setText("Focus distance is - " + 1/afState);

			    }
			});
		}
		
		
	};
	
}
