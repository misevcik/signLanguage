package sk.doreto.signlanguage.ui.components;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.widget.ImageButton;
import android.widget.LinearLayout;


import sk.doreto.signlanguage.R;

public class VideoControllerView extends LinearLayout {

    private IDetailFragment detailFragment;

    private ImageButton videoSpeed;
    private ImageButton videoBackward;
    private ImageButton videoPlay;
    private ImageButton videoForward;
    private ImageButton videoRotate;


    public VideoControllerView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(context, attrs);

    }

    public void setDetailFragment(IDetailFragment detailFragment) {
        this.detailFragment = detailFragment;
    }

    private void init(Context context, AttributeSet attrs) {

        inflate(context, R.layout.video_controller_view, this);
        initComponents();
    }

    private boolean videoSlowMotion = false;
    private boolean videoRotated = false;

    private void initComponents() {

        videoSpeed = findViewById(R.id.video_speed);
        videoBackward = findViewById(R.id.video_backward);
        videoPlay = findViewById(R.id.video_play);
        videoForward = findViewById(R.id.video_forward);
        videoRotate = findViewById(R.id.video_rotate);

        videoSpeed.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v)  {

                videoSlowMotion = !videoSlowMotion;
                if (videoSlowMotion) {
                    videoSpeed.setImageResource(R.mipmap.icon_clock_selected);
                } else {
                    videoSpeed.setImageResource(R.mipmap.icon_clock);
                }
                detailFragment.videoSpeed(videoSlowMotion);

            }
        });

        videoRotate .setOnClickListener(new View.OnClickListener() {
            public void onClick(View v)  {

                videoRotated = !videoRotated;

                if (videoRotated) {
                    videoRotate.setImageResource(R.mipmap.icon_rotate_selected);
                } else {
                    videoRotate.setImageResource(R.mipmap.icon_rotate);
                }
                detailFragment.videoRotate(videoRotated);
            }
        });

        videoBackward.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v)  {
                detailFragment.videoBackward();
            }
        });

        videoPlay.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v)  {
                detailFragment.videoPlay();
            }
        });

        videoForward.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v)  {
                detailFragment.videoForward();
            }
        });

    }
}
