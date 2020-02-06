package sk.doreto.signlanguage;

import android.app.Activity;
import android.content.res.Configuration;
import android.media.MediaPlayer;
import android.media.PlaybackParams;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.widget.MediaController;
import android.widget.VideoView;

import sk.doreto.signlanguage.utils.Utility;
import sk.doreto.signlanguage.utils.ZipFileContentProvider;

public class VideoPlayerActivity extends Activity implements MediaPlayer.OnCompletionListener {

    private VideoView videoView;
    private boolean videoSlowMotion = false;
    private String videoPath = null;

    @Override
    public void onCreate(Bundle b) {
        super.onCreate(b);

        setContentView(R.layout.activity_video_player);


        Bundle bundle = getIntent().getExtras();

        if (bundle != null) {
            videoPath = bundle.getString("videoPath");
            videoSlowMotion = bundle.getBoolean("videoSlowMotion");
        }

        videoView = (VideoView) findViewById(R.id.myvideoview);
        videoView.setOnCompletionListener(this);

        MediaController mediaController = new MediaController(this);
        mediaController.setAnchorView(videoView);
        mediaController.setMediaPlayer(videoView);
        videoView.setMediaController(mediaController);

        Uri uri = ZipFileContentProvider.buildUri(videoPath + ".mp4");

        if(!Utility.isValidMediaURI(getBaseContext(), uri)) {
            Log.e("VideoPlayerActivity", "Video path is not valid: " + uri.getPath());
            finish();
        }

        videoView.setVideoURI(uri);
        videoView.setOnPreparedListener(new MediaPlayer.OnPreparedListener() {
            @Override
            public void onPrepared(MediaPlayer mp) {

                if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M) {
                    if (videoSlowMotion) {
                        PlaybackParams myPlayBackParams = new PlaybackParams();
                        myPlayBackParams.setSpeed(0.5f);
                        mp.setPlaybackParams(myPlayBackParams);
                    }
                }

                videoView.start();
            }
        });
    }


    @Override
    public void onCompletion(MediaPlayer mp) {

        finish();
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
    }


}
