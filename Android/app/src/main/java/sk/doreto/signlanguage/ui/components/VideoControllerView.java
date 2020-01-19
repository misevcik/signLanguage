package sk.doreto.signlanguage.ui.components;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.widget.ImageButton;
import android.widget.LinearLayout;


import java.util.Timer;
import java.util.TimerTask;

import sk.doreto.signlanguage.R;
import sk.doreto.signlanguage.utils.Utility;

public class VideoControllerView extends LinearLayout {

    private IDetailFragment detailFragment;

    private ImageButton videoSlowMotionButton;
    private ImageButton videoBackwardButton;
    private ImageButton videoPlayButton;
    private ImageButton videoForwardButton;
    private ImageButton videoRotateButton;

    private boolean videoSlowMotion = false;
    private boolean videoRotate = false;

    public VideoControllerView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(context, attrs);

    }

    public void setDefaultVideoSlowMotion(boolean videoSlowMotion) {
        this.videoSlowMotion = videoSlowMotion;
        setVideoSlowMotionButton();
    }

    public void setDefaultVideoRotate(boolean videoRotate) {
        this.videoRotate = videoRotate;
        setVideoRotateButton();
    }

    public void setDetailFragment(IDetailFragment detailFragment) {
        this.detailFragment = detailFragment;
    }

    private void init(Context context, AttributeSet attrs) {

        inflate(context, R.layout.video_controller_view, this);
        initComponents();
    }

    private void initComponents() {

        videoSlowMotionButton = findViewById(R.id.video_slow_motion);
        videoBackwardButton = findViewById(R.id.video_backward);
        videoPlayButton = findViewById(R.id.video_play);
        videoForwardButton = findViewById(R.id.video_forward);
        videoRotateButton = findViewById(R.id.video_rotate);


        videoSlowMotionButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v)  {

                videoSlowMotion = !videoSlowMotion;
                setVideoSlowMotionButton();
                detailFragment.videoSlowMotion(videoSlowMotion);

            }
        });

        videoRotateButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v)  {

                videoRotate = !videoRotate;
                setVideoRotateButton();
                detailFragment.videoRotate(videoRotate);
            }
        });

        videoBackwardButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v)  {
                detailFragment.videoBackward();
            }
        });

        videoPlayButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v)  {
                detailFragment.videoPlay();
            }
        });

        videoForwardButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v)  {
                detailFragment.videoForward();
            }
        });

    }

    private void setVideoSlowMotionButton() {

        if (videoSlowMotion) {
            videoSlowMotionButton.setImageResource(R.drawable.icon_clock_selected);
        } else {
            videoSlowMotionButton.setImageResource(R.drawable.icon_clock);
        }
    }

    private void setVideoRotateButton() {

        if (videoRotate) {
            videoRotateButton.setImageResource(R.drawable.icon_rotate_selected);
        } else {
            videoRotateButton.setImageResource(R.drawable.icon_rotate);
        }
    }
}
