package sk.doreto.signlanguage;

import android.app.Activity;
import android.content.res.Configuration;
import android.media.MediaPlayer;
import android.media.PlaybackParams;
import android.net.Uri;
import android.os.Bundle;
import android.widget.MediaController;
import android.widget.VideoView;

public class VideoPlayerActivity extends Activity implements MediaPlayer.OnCompletionListener {

    private VideoView videoView;

    @Override
    public void onCreate(Bundle b) {
        super.onCreate(b);

        setContentView(R.layout.activity_video_player);

        String videoPath = null;
        Bundle bundle = getIntent().getExtras();

        if (bundle != null) {
            videoPath = bundle.getString("videoPath");
        }

        videoView = (VideoView) findViewById(R.id.myvideoview);
        videoView.setOnCompletionListener(this);

        MediaController mediaController = new MediaController(this);
        mediaController.setAnchorView(videoView);
        mediaController.setMediaPlayer(videoView);
        videoView.setMediaController(mediaController);

        videoView.setVideoURI(Uri.parse(videoPath));
        videoView.setOnPreparedListener(new MediaPlayer.OnPreparedListener() {
            @Override
            public void onPrepared(MediaPlayer mp) {

                if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M){
                    PlaybackParams myPlayBackParams = new PlaybackParams();
                    myPlayBackParams.setSpeed(0.5f);
                    mp.setPlaybackParams(myPlayBackParams);
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
