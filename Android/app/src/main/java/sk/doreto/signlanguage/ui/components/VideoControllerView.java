package sk.doreto.signlanguage.ui.components;

import android.content.Context;
import android.util.AttributeSet;
import android.util.Log;
import android.view.View;
import android.widget.ImageButton;
import android.widget.LinearLayout;


import sk.doreto.signlanguage.R;

public class VideoControllerView extends LinearLayout {

    private IVideoControllerView videoController;

    private ImageButton videoSpeed;
    private ImageButton videoBackward;
    private ImageButton videoPlay;
    private ImageButton videoForward;
    private ImageButton videoRotate;


    public VideoControllerView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(context, attrs);

    }

    public void setVideoController(IVideoControllerView videoController) {
        this.videoController = videoController;
    }

    private void init(Context context, AttributeSet attrs) {

        inflate(context, R.layout.video_controller_view, this);
        initComponents();
    }

    private boolean videoSlowSpeed = false;
    private boolean videoRotateed = false;

    private void initComponents() {

        videoSpeed = findViewById(R.id.video_speed);
        videoBackward = findViewById(R.id.video_backward);
        videoPlay = findViewById(R.id.video_play);
        videoForward = findViewById(R.id.video_forward);
        videoRotate = findViewById(R.id.video_rotate);

        videoSpeed.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v)  {

                videoSlowSpeed = !videoSlowSpeed;
                if (videoSlowSpeed) {
                    videoSpeed.setImageResource(R.mipmap.icon_clock_selected);
                } else {
                    videoSpeed.setImageResource(R.mipmap.icon_clock);
                }
                videoController.videoSpeed(videoSlowSpeed);

            }
        });

        videoRotate .setOnClickListener(new View.OnClickListener() {
            public void onClick(View v)  {

                videoRotateed = !videoRotateed;

                if (videoRotateed) {
                    videoRotate.setImageResource(R.mipmap.icon_rotate_selected);
                } else {
                    videoRotate.setImageResource(R.mipmap.icon_rotate);
                }
                videoController.videoRotate(videoRotateed);
            }
        });

        videoBackward.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v)  {
                Log.i("VideoController", "videoBackward");
            }
        });

        videoPlay.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v)  {
                videoController.videoPlay();
            }
        });

        videoForward.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v)  {
                Log.i("VideoController", "videoForward");
            }
        });

    }
}
